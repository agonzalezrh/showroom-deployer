# Use Red Hat UBI9 as the base image
FROM --platform=linux/amd64 registry.access.redhat.com/ubi9/ubi:9.5

# Install git
RUN dnf -y update && dnf -y upgrade && \
    dnf -y --quiet install git && \
    dnf clean all && \
    rm -rf /var/cache/yum /root/.cache

# Copy the entrypoint script into the container
COPY ./entrypoint.sh /entrypoint.sh

# Set the entrypoint script as the command to run when the container starts
ENTRYPOINT ["/entrypoint.sh"]