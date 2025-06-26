#!/usr/bin/env bash

VERSION=${1:-latest}

podman build -t=localhost/git-cloner:$VERSION .
podman tag localhost/git-cloner:$VERSION quay.io/rhpds/git-cloner:$VERSION