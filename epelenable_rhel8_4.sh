#!/bin/bash -ex
# install repo
sudo dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm

# enable repo in subscription-manager
sudo subscription-manager repos --enable "codeready-builder-for-rhel-8-$(arch)-rpms"

# on RED HAT 8 recommend enable powertools
sudo dnf config-manager --set-enabled powertools
