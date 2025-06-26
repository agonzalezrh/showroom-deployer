#!/usr/bin/env bash

VERSION=${1:-latest}

podman push quay.io/rhpds/git-cloner:$VERSION