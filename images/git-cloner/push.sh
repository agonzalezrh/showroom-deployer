#!/usr/bin/env bash

VERSION=${1:-latest}

podman push quay.io/andrew-jones/git-cloner:$VERSION