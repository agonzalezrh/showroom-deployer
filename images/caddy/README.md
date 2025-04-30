# Caddy Web Server Docker Image

This directory contains the files needed to build a Docker/Podman image for the Caddy web server based on Red Hat Universal Base Image (UBI) 9.

## Image Details

*   **Base Image**: `registry.access.redhat.com/ubi9/ubi:9.5`
*   **Web Server**: Caddy
*   **Configuration**: Uses the `Caddyfile` in this directory to configure the server.
*   **Content**: Serves the `index.html` file located in `/usr/share/caddy` within the container.
*   **Exposed Port**: 8000

## Building the Image

A build script (`build.sh`) is provided for convenience. It uses `podman` to build the image and tags it.

```bash
./build.sh [version]
```

Replace `[version]` with the desired tag (e.g., `latest`, `v1.0`). If no version is provided, it defaults to `latest`.

The script will build the image and tag it as:
*   `localhost/caddy:[version]`
*   `quay.io/andrew-jones/caddy:[version]`

## Running the Container

To run the container after building:

```bash
podman run -d -p 8080:8000 --name my-caddy-server localhost/caddy:latest
```

This command will:
*   Run the container in detached mode (`-d`).
*   Map port 8080 on the host to port 8000 in the container (`-p 8080:8000`).
*   Name the container `my-caddy-server` (`--name`).
*   Use the image tagged as `localhost/caddy:latest`.

You can then access the default `index.html` page by navigating to `http://localhost:8080` in your web browser.

## Customization

You can customize the Caddy configuration and the served content by mounting volumes:

*   **Custom Caddyfile**: Mount your own `Caddyfile` to `/etc/caddy/Caddyfile` in the container.
    ```bash
    podman run -d -p 8080:8000 --name my-caddy-server -v ./my-custom-Caddyfile:/etc/caddy/Caddyfile:Z localhost/caddy:latest
    ```
*   **Custom HTML Content**: Mount your website's root directory to `/usr/share/caddy` in the container.
    ```bash
    podman run -d -p 8080:8000 --name my-caddy-server -v ./my-html-content:/usr/share/caddy:Z localhost/caddy:latest
    ```
    *(Note: Ensure your custom `Caddyfile` is configured to serve files from `/usr/share/caddy` if you mount custom content.)*

## Files

*   `Dockerfile`: Defines the image build steps.
*   `Caddyfile`: Caddy server configuration file.
*   `index.html`: Default HTML page served by Caddy.
*   `build.sh`: Script to build and tag the image.
*   `push.sh`: Script to push the image to a registry (likely `quay.io/andrew-jones/caddy`).
