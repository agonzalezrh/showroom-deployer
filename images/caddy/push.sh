#!/usr/bin/env bash

VERSION=${1:-latest}

podman push quay.io/andrew-jones/caddy:$VERSION