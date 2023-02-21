#!/usr/bin/env bash

# Usage:
#
# Requirements:
# - https://github.com/lindell/multi-gitter
# - https://github.com/comby-tools/comby
# - A GitHub Personal Access Token in GITHUB_TOKEN env var


# Example of string to remove (note the diverse file extensions):
# https://github.com/jenkinsci/simple-theme-plugin/blob/ea25d3c04297f1d2985ef76c79dda3d3edf38743/README.markdown?plain=1#L6
#
# https://github.com/jenkinsci/test-results-aggregator-plugin/blame/4e0f84559db83285177386ead001bd39bad35a85/README.adoc#L24
#

# TODO: duplicate all example with `core`|`plugins` instead of `Plugins`, and `%2F` instead of `/`

# A) [![Jenkins](https://ci.jenkins.io/job/plugins/job/jenkins-infra-test-plugin/job/master/badge/icon)](https://ci.jenkins.io/job/plugins/job/jenkins-infra-test-plugin/job/master/)
# B) [![Build Status](https://ci.jenkins.io/buildStatus/icon?job=Plugins%2Fsimple-theme-plugin%2Fmain)](https://ci.jenkins.io/job/Plugins/job/simple-theme-plugin/job/main/)
# C) image:https://ci.jenkins.io/buildStatus/icon?job=Plugins/test-results-aggregator-plugin/master[https://github.com/jenkinsci/role-strategy-plugin/releases/latest]
# D) [![Build Status](https://ci.jenkins.io/buildStatus/icon?job=Plugins/jenkins-infra-test-plugin/master)](https://ci.jenkins.io/buildStatus/icon?job=Plugins/jenkins-infra-test-plugin/master)
# F) image:https://ci.jenkins.io/buildStatus/icon?job=Plugins/test-results-aggregator-plugin/master[https://github.com/jenkinsci/role-strategy-plugin/releases/latest]
# G) [![Build Status](https://ci.jenkins.io/buildStatus/icon?style=plastic&job=Plugins%2Fgraphql-server-plugin%2Fmaster)](https://ci.jenkins.io/job/Plugins/job/graphql-server-plugin/job/master/)
# H) [![Build Status](https://ci.jenkins.io/buildStatus/icon?subject=Jenkins%20CI&job=Plugins%2Fmuuri-api-plugin%2Fmaster)](https://ci.jenkins.io/job/Plugins/job/muuri-api-plugin/job/master/)
# I) [![Jenkins](https://ci.jenkins.io/job/Core/job/acceptance-test-harness/job/master/badge/icon)](https://ci.jenkins.io/job/Core/job/acceptance-test-harness/job/master/)
# https://github.com/jenkinsci/scm-filter-branch-pr-plugin/blob/ac8eeefa235a55fbdbddb19bb086e50e06081d4b/DEVELOPER_README.md?plain=1#L59
# J) [build-icon]: https://ci.jenkins.io/buildStatus/icon?job=Plugins/scm-filter-branch-pr-plugin/master
# https://github.com/jenkinsci/log-command-plugin/blame/e8e78fa1f8de2efc1ebd7613682214b8dcb1c1bf/README.adoc#L14
# K) image:https://ci.jenkins.io/buildStatus/icon?job=Plugins%2Flog-command-plugin%2Fmaster[]
# https://github.com/Mojang/git-parameter-plugin/blame/a466390e7f27fb205bec874cec5dfed946a13d57/README.textile#L14
# L) * The Jenkins-CI of this plugin can be seen at "DEV@cloud":https://ci.jenkins.io/job/Plugins/job/git-parameter-plugin/. The status is <a href='https://ci.jenkins.io/job/Plugins/job/git-parameter-plugin/'><img src='https://ci.jenkins.io/buildStatus/icon?job=Plugins/git-parameter-plugin/master'></a>

mardownreplacement="[**\2** builds status on ci.jenkins.io](https:\/\/ci.jenkins.io\/job\/\1\/job\/\2\/job\/\3)"
adocreplacement="link:https:\/\/ci.jenkins.io\/job\/\1\/job\/\2\/job\/\3[**\2** builds status on ci.jenkins.io]"

# On .md files
find ./ -type f -name "*.md" -exec sed -i '' \
  -e "s/^.*ci\.jenkins\.io\/job\/\(plugins\)\/job\/\(.*\)\/job\/\(.*\)\/badge.*/${mardownreplacement}/gI" \
  -e "s/^.*ci\.jenkins\.io\/buildStatus\/icon\?.*job=\(Plugins\)%2F\(.*\)%2F\(.*\))].*/${mardownreplacement}/gI" \
  -e "s/^.*ci\.jenkins\.io\/buildStatus\/icon\?.*job=\(Plugins\)%2F\(.*\)%2F\(.*\)\[.*/${mardownreplacement}/gI" \
  -e "s/^.*ci\.jenkins\.io\/buildStatus\/icon\?.*job=\(Plugins\)\/\(.*\)\/\(.*\)\[.*/${mardownreplacement}/gI" \
  -e "s/^.*ci\.jenkins\.io\/buildStatus\/icon\?.*job=\(Plugins\)\/\(.*\)\/\(.*\))/${mardownreplacement}/gI" \
  -e "s/^.*ci\.jenkins\.io\/buildStatus\/icon\?.*job=\(Plugins\)\/\(.*\)\/\(.*\)/${mardownreplacement}/gI" \
  -e "s/^.*ci\.jenkins\.io\/job\/\(core\)\/job\/\(.*\)\/job\/\(.*\)\/badge.*/${mardownreplacement}/gI" \
  -e "s/^.*ci\.jenkins\.io\/buildStatus\/icon\?.*job=\(core\)%2F\(.*\)%2F\(.*\))].*/${mardownreplacement}/gI" \
  -e "s/^.*ci\.jenkins\.io\/buildStatus\/icon\?.*job=\(core\)%2F\(.*\)%2F\(.*\)\[.*/${mardownreplacement}/gI" \
  -e "s/^.*ci\.jenkins\.io\/buildStatus\/icon\?.*job=\(core\)\/\(.*\)\/\(.*\)\[.*/${mardownreplacement}/gI" \
  -e "s/^.*ci\.jenkins\.io\/buildStatus\/icon\?.*job=\(core\)\/\(.*\)\/\(.*\))/${mardownreplacement}/gI" \
  -e "s/^.*ci\.jenkins\.io\/buildStatus\/icon\?.*job=\(core\)\/\(.*\)\/\(.*\)/${mardownreplacement}/gI" \
  -e 's/\/job\/master))/\/job\/master)/gI' \
  -e "s/master'><\/job\/a>/master/gI" {} \;

# On .markdown files
find ./ -type f -name "*.markdown" -exec sed -i '' \
  -e "s/^.*ci\.jenkins\.io\/job\/\(core\)\/job\/\(.*\)\/job\/\(.*\)\/badge.*/${mardownreplacement}/gI" \
  -e "s/^.*ci\.jenkins\.io\/job\/\(plugins\)\/job\/\(.*\)\/job\/\(.*\)\/badge.*/${mardownreplacement}/gI" \
  -e "s/^.*ci\.jenkins\.io\/buildStatus\/icon\?.*job=\(Plugins\)%2F\(.*\)%2F\(.*\))].*/${mardownreplacement}/gI" \
  -e "s/^.*ci\.jenkins\.io\/buildStatus\/icon\?.*job=\(Plugins\)%2F\(.*\)%2F\(.*\)\[.*/${mardownreplacement}/gI" \
  -e "s/^.*ci\.jenkins\.io\/buildStatus\/icon\?.*job=\(Plugins\)\/\(.*\)\/\(.*\)\[.*/${mardownreplacement}/gI" \
  -e "s/^.*ci\.jenkins\.io\/buildStatus\/icon\?.*job=\(Plugins\)\/\(.*\)\/\(.*\))/${mardownreplacement}/gI" \
  -e "s/^.*ci\.jenkins\.io\/buildStatus\/icon\?.*job=\(Plugins\)\/\(.*\)\/\(.*\)/${mardownreplacement}/gI" \
  -e "s/^.*ci\.jenkins\.io\/job\/\(core\)\/job\/\(.*\)\/job\/\(.*\)\/badge.*/${mardownreplacement}/gI" \
  -e "s/^.*ci\.jenkins\.io\/buildStatus\/icon\?.*job=\(core\)%2F\(.*\)%2F\(.*\))].*/${mardownreplacement}/gI" \
  -e "s/^.*ci\.jenkins\.io\/buildStatus\/icon\?.*job=\(core\)%2F\(.*\)%2F\(.*\)\[.*/${mardownreplacement}/gI" \
  -e "s/^.*ci\.jenkins\.io\/buildStatus\/icon\?.*job=\(core\)\/\(.*\)\/\(.*\)\[.*/${mardownreplacement}/gI" \
  -e "s/^.*ci\.jenkins\.io\/buildStatus\/icon\?.*job=\(core\)\/\(.*\)\/\(.*\))/${mardownreplacement}/gI" \
  -e "s/^.*ci\.jenkins\.io\/buildStatus\/icon\?.*job=\(core\)\/\(.*\)\/\(.*\)/${mardownreplacement}/gI" \
  -e 's/\/job\/master))/\/job\/master)/gI' \
  -e "s/master'><\/job\/a>/master/gI" {} \;

# On .adoc files
find ./ -type f -name "*.adoc" -exec sed -i '' \
  -e "s/^.*ci\.jenkins\.io\/job\/\(core\)\/job\/\(.*\)\/job\/\(.*\)\/badge.*/${adocreplacement}/gI" \
  -e "s/^.*ci\.jenkins\.io\/job\/\(plugins\)\/job\/\(.*\)\/job\/\(.*\)\/badge.*/${adocreplacement}/gI" \
  -e "s/^.*ci\.jenkins\.io\/buildStatus\/icon\?.*job=\(Plugins\)%2F\(.*\)%2F\(.*\))].*/${adocreplacement}/gI" \
  -e "s/^.*ci\.jenkins\.io\/buildStatus\/icon\?.*job=\(Plugins\)%2F\(.*\)%2F\(.*\)\[.*/${adocreplacement}/gI" \
  -e "s/^.*ci\.jenkins\.io\/buildStatus\/icon\?.*job=\(Plugins\)\/\(.*\)\/\(.*\)\[.*/${adocreplacement}/gI" \
  -e "s/^.*ci\.jenkins\.io\/buildStatus\/icon\?.*job=\(Plugins\)\/\(.*\)\/\(.*\))/${adocreplacement}/gI" \
  -e "s/^.*ci\.jenkins\.io\/buildStatus\/icon\?.*job=\(Plugins\)\/\(.*\)\/\(.*\)/${adocreplacement}/gI" \
  -e "s/^.*ci\.jenkins\.io\/job\/\(core\)\/job\/\(.*\)\/job\/\(.*\)\/badge.*/${mardownreplacement}/gI" \
  -e "s/^.*ci\.jenkins\.io\/buildStatus\/icon\?.*job=\(core\)%2F\(.*\)%2F\(.*\))].*/${mardownreplacement}/gI" \
  -e "s/^.*ci\.jenkins\.io\/buildStatus\/icon\?.*job=\(core\)%2F\(.*\)%2F\(.*\)\[.*/${mardownreplacement}/gI" \
  -e "s/^.*ci\.jenkins\.io\/buildStatus\/icon\?.*job=\(core\)\/\(.*\)\/\(.*\)\[.*/${mardownreplacement}/gI" \
  -e "s/^.*ci\.jenkins\.io\/buildStatus\/icon\?.*job=\(core\)\/\(.*\)\/\(.*\))/${mardownreplacement}/gI" \
  -e "s/^.*ci\.jenkins\.io\/buildStatus\/icon\?.*job=\(core\)\/\(.*\)\/\(.*\)/${mardownreplacement}/gI" \
  -e 's/\/job\/master))/\/job\/master)/gI' \
  -e "s/master'><\/job\/a>/master/gI" {} \;

find ./ -type f -name "*.textile" -exec sed -i '' \
  -e "s/^.*ci\.jenkins\.io\/job\/\(core\)\/job\/\(.*\)\/job\/\(.*\)\/badge.*/${adocreplacement}/gI" \
  -e "s/^.*ci\.jenkins\.io\/job\/\(plugins\)\/job\/\(.*\)\/job\/\(.*\)\/badge.*/${adocreplacement}/gI" \
  -e "s/^.*ci\.jenkins\.io\/buildStatus\/icon\?.*job=\(Plugins\)%2F\(.*\)%2F\(.*\))].*/${adocreplacement}/gI" \
  -e "s/^.*ci\.jenkins\.io\/buildStatus\/icon\?.*job=\(Plugins\)%2F\(.*\)%2F\(.*\)\[.*/${adocreplacement}/gI" \
  -e "s/^.*ci\.jenkins\.io\/buildStatus\/icon\?.*job=\(Plugins\)\/\(.*\)\/\(.*\)\[.*/${adocreplacement}/gI" \
  -e "s/^.*ci\.jenkins\.io\/buildStatus\/icon\?.*job=\(Plugins\)\/\(.*\)\/\(.*\))/${adocreplacement}/gI" \
  -e "s/^.*ci\.jenkins\.io\/buildStatus\/icon\?.*job=\(Plugins\)\/\(.*\)\/\(.*\)/${adocreplacement}/gI" \
  -e "s/^.*ci\.jenkins\.io\/job\/\(core\)\/job\/\(.*\)\/job\/\(.*\)\/badge.*/${mardownreplacement}/gI" \
  -e "s/^.*ci\.jenkins\.io\/buildStatus\/icon\?.*job=\(core\)%2F\(.*\)%2F\(.*\))].*/${mardownreplacement}/gI" \
  -e "s/^.*ci\.jenkins\.io\/buildStatus\/icon\?.*job=\(core\)%2F\(.*\)%2F\(.*\)\[.*/${mardownreplacement}/gI" \
  -e "s/^.*ci\.jenkins\.io\/buildStatus\/icon\?.*job=\(core\)\/\(.*\)\/\(.*\)\[.*/${mardownreplacement}/gI" \
  -e "s/^.*ci\.jenkins\.io\/buildStatus\/icon\?.*job=\(core\)\/\(.*\)\/\(.*\))/${mardownreplacement}/gI" \
  -e "s/^.*ci\.jenkins\.io\/buildStatus\/icon\?.*job=\(core\)\/\(.*\)\/\(.*\)/${mardownreplacement}/gI" \
  -e 's/\/job\/master))/\/job\/master)/gI' \
  -e "s/master'><\/job\/a>/master/gI" {} \;

# find ./ -type f -name "*.*" -exec sed -i '' \
#   -e "s/^.*ci\.jenkins\.io\/job\/\(core\)\/job\/\(.*\)\/job\/\(.*\)\/badge.*/${adocreplacement}/gI" \
#   -e "s/^.*ci\.jenkins\.io\/job\/\(plugins\)\/job\/\(.*\)\/job\/\(.*\)\/badge.*/${adocreplacement}/gI" \
#   -e "s/^.*ci\.jenkins\.io\/buildStatus\/icon\?.*job=\(Plugins\)%2F\(.*\)%2F\(.*\))].*/${adocreplacement}/gI" \
#   -e "s/^.*ci\.jenkins\.io\/buildStatus\/icon\?.*job=\(Plugins\)%2F\(.*\)%2F\(.*\)\[.*/${adocreplacement}/gI" \
#   -e "s/^.*ci\.jenkins\.io\/buildStatus\/icon\?.*job=\(Plugins\)\/\(.*\)\/\(.*\)\[.*/${adocreplacement}/gI" \
#   -e "s/^.*ci\.jenkins\.io\/buildStatus\/icon\?.*job=\(Plugins\)\/\(.*\)\/\(.*\))/${adocreplacement}/gI" \
#   -e "s/^.*ci\.jenkins\.io\/buildStatus\/icon\?.*job=\(Plugins\)\/\(.*\)\/\(.*\)/${adocreplacement}/gI" \
  # -e "s/^.*ci\.jenkins\.io\/job\/\(core\)\/job\/\(.*\)\/job\/\(.*\)\/badge.*/${mardownreplacement}/gI" \
  # -e "s/^.*ci\.jenkins\.io\/buildStatus\/icon\?.*job=\(core\)%2F\(.*\)%2F\(.*\))].*/${mardownreplacement}/gI" \
  # -e "s/^.*ci\.jenkins\.io\/buildStatus\/icon\?.*job=\(core\)%2F\(.*\)%2F\(.*\)\[.*/${mardownreplacement}/gI" \
  # -e "s/^.*ci\.jenkins\.io\/buildStatus\/icon\?.*job=\(core\)\/\(.*\)\/\(.*\)\[.*/${mardownreplacement}/gI" \
  # -e "s/^.*ci\.jenkins\.io\/buildStatus\/icon\?.*job=\(core\)\/\(.*\)\/\(.*\))/${mardownreplacement}/gI" \
  # -e "s/^.*ci\.jenkins\.io\/buildStatus\/icon\?.*job=\(core\)\/\(.*\)\/\(.*\)/${mardownreplacement}/gI" \
#   -e 's/\/job\/master))/\/job\/master)/gI' \
#   -e "s/master'><\/job\/a>/master/gI" {} \;

git checkout -b helpdesk-3013

git add .

git commit -S -s -m "cleanup(doc): removal of embedabble-build-status badge(s)"

git push -u origin helpdesk-3013

# Ref: jenkinsci/embeddable-build-status-plugin issue #82 & jenkins-infra/helpdesk issue #3013`

gh pr create --head helpdesk-3013 --title "cleanup(doc): removal of embedabble-build-status badge(s)" --label "ci-skip" --body "As explained in [this announcement](https://github.com/jenkinsci/embeddable-build-status-plugin/issues/82), the `embeddable-build-status` plugin will be removed from the ci.jenkins.io public instance, thus the badge(s) in this repository won't work anymore. <br />This pull request made in bulk for the Jenkins Infrastructure team aims at replacing these badges by a link to the builds status on ci.jenkins.io"
