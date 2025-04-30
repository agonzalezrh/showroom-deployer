#!/bin/bash

if [ -z "${GIT_REPO_URL}" ]; then
  echo "GIT_REPO_URL is not set. Exiting."
  exit 1
fi

WORKDIR=/files
test -d ${WORKDIR} && rm -rfv ${WORKDIR}/{*,.*}

echo
echo "git clone the ${GIT_REPO_URL} into ${WORKDIR}"
git clone ${GIT_REPO_URL} ${WORKDIR}
cd ${WORKDIR}

if [ -z ${GIT_REPO_REF} ]; then
  echo "No GIT_REPO_REF specified. Using default branch"
else
  echo "Checking out ref ${GIT_REPO_REF}"
  git checkout ${GIT_REPO_REF}
fi

touch .git-cloner