#!/bin/bash

set -euo pipefail # Exit on error, unset variable, or pipe failure

# Prevent git from prompting for credentials interactively
export GIT_TERMINAL_PROMPT=0

# Set a writable location for git config to avoid permission issues in containers
export GIT_CONFIG_GLOBAL=/tmp/.gitconfig

# --- Configuration ---
# GIT_REPO_URL: Mandatory, URL of the git repository to clone.
# GIT_REPO_REF: Optional, git ref (branch, tag, commit SHA) to checkout. Defaults to repository's default branch.
# CLONE_DIR: Optional, directory where the repo will be cloned. Defaults to "/app/repo".

: "${GIT_REPO_URL:?Error: GIT_REPO_URL environment variable is not set or empty.}" # Exits if not set

CLONE_DIR="${CLONE_DIR:-/files}" # Default clone directory

# --- Script Logic ---
echo "--- Git Cloner Starting ---"
echo "Git Repository URL: ${GIT_REPO_URL}"
echo "Target Directory: ${CLONE_DIR}"
[ -n "${GIT_REPO_REF:-}" ] && echo "Git Reference: ${GIT_REPO_REF}" || echo "Git Reference: Using default branch"

# If CLONE_DIR is a directory, remove it so we can git clone
test -d ${CLONE_DIR} && find "${CLONE_DIR}" -mindepth 1 -delete

echo
echo "Cloning repository ${GIT_REPO_URL} into ${CLONE_DIR}..."
if ! git clone --progress "${GIT_REPO_URL}" "${CLONE_DIR}"; then
  echo "Error: Failed to clone repository ${GIT_REPO_URL}." >&2
  exit 1
fi
echo "Repository cloned successfully."
echo

cd "${CLONE_DIR}" || { echo "Error: Failed to change directory to ${CLONE_DIR}." >&2; exit 1; }

# Fix potential ownership issues that can occur in containerized environments
echo "Configuring git safe directory..."
git config --global --add safe.directory "${CLONE_DIR}"

if [ -n "${GIT_REPO_REF:-}" ]; then # Check if GIT_REPO_REF is set and not empty
  echo "Checking out reference: ${GIT_REPO_REF}..."
  if ! git checkout "${GIT_REPO_REF}"; then
    echo "Error: Failed to checkout reference ${GIT_REPO_REF}." >&2
    exit 1
  fi
  echo "Successfully checked out reference ${GIT_REPO_REF}."
else
  echo "No GIT_REPO_REF specified. Using the default branch already checked out by 'git clone'."
fi

# Create a file so any containters that rely on the git repo existing can wait until the file exists
echo "Creating file .git-cloner..."
touch .git-cloner

echo
echo "--- Git Cloner Finished Successfully ---"