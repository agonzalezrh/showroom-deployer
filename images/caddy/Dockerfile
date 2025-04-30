# Use Red Hat UBI9 as the base image
FROM --platform=linux/amd64 registry.access.redhat.com/ubi9/ubi:9.5

# Install Caddy
RUN dnf -y update && dnf -y upgrade && \
    dnf -y --quiet install 'dnf-command(copr)' && \
    dnf -y --quiet copr enable @caddy/caddy && \
    dnf -y --quiet install caddy && \
    dnf clean all && \
    rm -rf /var/cache/yum /root/.cache

COPY Caddyfile /etc/caddy/Caddyfile

RUN mkdir -p /usr/share/caddy
COPY index.html /usr/share/caddy/index.html

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile"]