#!/usr/bin/env bash
set -o nounset
set -o errexit
set -o pipefail

VEGETA_TARGET="https://azure.updates.jenkins.io/update-center.actual.json"
VEGETA_ATTACK_PARAMETERS="-duration=10s"

# Required tools
for tool in pdsh az scp;
do
    command -v "${tool}" >/dev/null 2>&1 || { echo >&2 "${tool} not found, please add ${tool} into PATH"; exit 1; }
done

# Retrieve vegeta executable from GitHub if not present in the current folder
if [[ ! -f "vegeta" ]]; then
    echo "Retrieving vegeta executable from GitHub..."
    VEGETA_VERSION="12.11.1"
    OS_NAME=$(uname | tr '[:upper:]' '[:lower:]')
    ARCHITECTURE=$(uname -m)
    [[ ${ARCHITECTURE} == x86_64 ]] && ARCHITECTURE="amd64"
    VEGETA_URL="https://github.com/tsenart/vegeta/releases/download/v${VEGETA_VERSION}/vegeta_${VEGETA_VERSION}_${OS_NAME}_${ARCHITECTURE}.tar.gz"
    curl --fail --silent --show-error --location "${VEGETA_URL}" --output vegeta.tgz
    tar --extract --gunzip --file="vegeta.tgz"
    chmod +x vegeta
    rm vegeta.tgz
fi

# VMs preparation
RANDOM_ID="$(openssl rand -hex 3)"
RESOURCE_GROUP_NAME="helpdesk2649-load-testing"
REGION=eastus2
VM_NAME="vm-load-testing-$RANDOM_ID"
USERNAME=azureuser
VM_IMAGE="Canonical:0001-com-ubuntu-minimal-jammy:minimal-22_04-lts-gen2:latest"
VM_SIZE="Standard_DS1_v2" # To be adjusted
VM_COUNT="${VM_COUNT:-2}"

echo "= Creating ${RESOURCE_GROUP_NAME} resource group..."
az group create --name "${RESOURCE_GROUP_NAME}" --location "${REGION}"

echo "= Creating ${VM_COUNT} VMs..."
json=$(az vm create \
    --resource-group "${RESOURCE_GROUP_NAME}" \
    --name "${VM_NAME}" \
    --image "${VM_IMAGE}" \
    --size "${VM_SIZE}" \
    --ephemeral-os-disk=true \
    --accelerated-network=true \
    --priority "Spot" \
    --admin-username "${USERNAME}" \
    --assign-identity \
    --count "${VM_COUNT}" \
    --generate-ssh-keys)

vmNames=$(echo "${json}" | jq -r '.[] | .name')
vmIPs=$(echo "${json}" | jq -r '.[] | .publicIps')

echo '= Enabling Azure AD Login...'
while IFS= read -r vmName ; do
    az vm extension set \
        --publisher Microsoft.Azure.ActiveDirectory \
        --name AADSSHLoginForLinux \
        --resource-group "${RESOURCE_GROUP_NAME}" \
        --vm-name "${vmName}" >/dev/null 2>&1 &
done <<< "${vmNames}"
wait

echo '= Copy vegeta to VMs...'
ipList=''
while IFS= read -r vmIP ; do
    ipList+="${USERNAME}@${vmIP},"
    scp -o StrictHostKeyChecking=no vegeta "${USERNAME}@${vmIP}:/home/${USERNAME}" &
done <<< "${vmIPs}"
ipList=${ipList::-1}
wait

# Load testing
echo '= Launch distributed attack with vegeta from VMs...'
PDSH_RCMD_TYPE=ssh pdsh -b -w "${ipList}" \
    "echo \"GET ${VEGETA_TARGET}\" | ./vegeta attack ${VEGETA_ATTACK_PARAMETERS} > result.bin" || true

echo '= Compress result...'
PDSH_RCMD_TYPE=ssh pdsh -b -w "${ipList}" \
    'tar czf  result.bin.tgz result.bin'

echo '= Retrieve compressed results from VMs...'
while IFS= read -r vmIP ; do
    scp "${USERNAME}@${vmIP}:/home/${USERNAME}/result.bin.tgz" "${VM_NAME}.${vmIP}.bin.tgz" &
    # TODO: wait to download results 3 by 3 or something like that, not all at once?
done <<< "${vmIPs}"
wait

echo '= Cleanup VMs and associated resources in the background...'
az group delete --yes --no-wait --name "${RESOURCE_GROUP_NAME}"

echo '= Uncompress results...'
while IFS= read -r vmIP ; do
    vmId="${VM_NAME}-${vmIP//./-}"
    vmResultFolder="results/${vmId}"
    mkdir -p "${vmResultFolder}" \
    && tar xzf "${VM_NAME}.${vmIP}.bin.tgz" --directory "${vmResultFolder}" \
    && rm "${VM_NAME}.${vmIP}.bin.tgz" \
    && mv "${vmResultFolder}/result.bin" "result_${vmId}.bin" &
done <<< "${vmIPs}"
wait

echo '= Vegeta report:'
vegeta report *.bin
