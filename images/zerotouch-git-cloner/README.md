# Git Cloner Docker Container

A simple and configurable Docker container to clone a Git repository. It can be used to fetch a specific version of a repository (branch, tag, or commit) and make it available within a container or a mounted volume.

## Features

* Clones any Git repository specified by URL.
* Optionally checks out a specific branch, tag, or commit SHA.
* Configurable clone directory.
* Creates a `.git-cloner` file in the root of the cloned repository upon successful completion, which can be used as a signal for other processes.
* Based on Red Hat UBI 9.
* Includes scripts for building and pushing the image with Podman.

## Prerequisites

* Docker or Podman installed.

## Files in this Project

* `Dockerfile`: Defines the Docker image for the Git cloner.
* `entrypoint.sh`: The script executed when the container starts. It handles the cloning logic.
* `docker-compose.yml`: A Docker Compose file for easy local testing and usage.
* `build.sh`: A helper script to build the Docker image using Podman.
* `push.sh`: A helper script to push the built image to a container registry (Quay.io in the example) using Podman.

## Configuration (Environment Variables)

The container's behavior is controlled by the following environment variables:

| Variable        | Description                                                                                                | Default      | Required |
| :-------------- | :--------------------------------------------------------------------------------------------------------- | :----------- | :------- |
| `GIT_REPO_URL`  | The URL of the Git repository to clone (e.g., `https://github.com/user/repo.git`).                         | N/A          | **Yes** |
| `GIT_REPO_REF`  | Optional. The Git reference (branch name, tag name, or commit SHA) to checkout after cloning.              | Default branch | No       |
| `CLONE_DIR`     | Optional. The directory inside the container where the repository will be cloned.                          | `/files`     | No       |

## How to Use

### 1. Building the Image

You can build the Docker image using the provided `build.sh` script (which uses Podman) or directly with Docker/Podman.

**Using `build.sh`:**

This script builds the image and tags it as `localhost/git-cloner:<version>` and `quay.io/rhpds/showroom-git-cloner:<version>`.

```bash
./build.sh
# or specify a version
./build.sh v1.0.0
```

**Using Docker:**

```bash
docker build -t git-cloner:latest .
```

**Using Podman:**

```bash
podman build -t git-cloner:latest .
```

### 2. Running the Container

#### Using `docker-compose.yml` (Recommended for local testing)

The `docker-compose.yml` file is pre-configured to run the `git-cloner` service.

1.  **Modify `docker-compose.yml` (Optional):**
    Update the `GIT_REPO_URL` environment variable to point to your desired repository. You can also set `GIT_REPO_REF` if needed.

    ```yaml
    ---
    version: '3.8'
    services:
      git-cloner:
        build: .
        environment:
          - GIT_REPO_URL=https://github.com/namespace/your-repo.git # <-- CHANGE THIS
          # - GIT_REPO_REF=my-branch # Optional: specify a branch, tag, or commit
          # - CLONE_DIR=/custom/clone/path # Optional: specify a custom clone directory
        volumes:
          - ./.files:/files:Z # Cloned files will be available in ./.files on your host
    ```

2.  **Run with Docker Compose:**

    ```bash
    docker-compose up
    ```
    The repository will be cloned into the `./.files` directory on your host machine.

#### Using `docker run` or `podman run`

You can also run the container directly. Remember to set the required `GIT_REPO_URL` environment variable and mount a volume if you want to access the cloned repository on your host.

**Example with Podman:**

```bash
# Clone the main branch of a public repository into ./my-repo on the host
podman run --rm \
  -e GIT_REPO_URL="[https://github.com/someuser/somerepo.git](https://github.com/someuser/somerepo.git)" \
  -v "$(pwd)/my-repo:/files:Z" \
  localhost/git-cloner:latest # Assuming you used build.sh

# Clone a specific tag (e.g., v1.2.3)
podman run --rm \
  -e GIT_REPO_URL="[https://github.com/someuser/somerepo.git](https://github.com/someuser/somerepo.git)" \
  -e GIT_REPO_REF="v1.2.3" \
  -v "$(pwd)/my-repo:/files:Z" \
  localhost/git-cloner:latest
```

### 3. Verifying Success

Upon successful cloning and checkout, the `entrypoint.sh` script creates a file named `.git-cloner` in the root of the cloned repository (e.g., `/files/.git-cloner` inside the container, or `./.files/.git-cloner` on the host if using the `docker-compose.yml` example). This file can be used by other processes or containers to verify that the cloning process is complete.

Example check:
```bash
if [ -f "./.files/.git-cloner" ]; then
  echo "Repository cloned successfully."
else
  echo "Cloning may have failed or is still in progress."
fi
```

## Helper Scripts

### `build.sh`

Builds the Docker image using Podman and tags it appropriately for local use and for pushing to `quay.io/rhpds/showroom-git-cloner`.

**Usage:**

```bash
./build.sh [version]
```
If `[version]` is not provided, it defaults to `latest`.

### `push.sh`

Pushes the specified version of the image (or `latest` if no version is provided) to `quay.io/rhpds/showroom-git-cloner` using Podman. You must be logged into Quay.io with Podman for this to succeed.

**Usage:**

```bash
./push.sh [version]
```
If `[version]` is not provided, it defaults to `latest`. Ensure you have run `./build.sh [version]` first.