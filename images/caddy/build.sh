#!/usr/bin/env bash

VERSION=${1:-latest}

podman build -t=localhost/caddy:$VERSION .
podman tag localhost/caddy:$VERSION quay.io/andrew-jones/caddy:$VERSION