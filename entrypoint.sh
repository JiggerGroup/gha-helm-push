#!/bin/bash
set -e

if [ -z "${CHART_FOLDER}" ]; then
  echo "Chart folder is required but not defined."
  exit 1
fi

if [ -z "${REGISTRY_URL}" ]; then
  echo "Repository url is required but not defined."
  exit 1
fi

if [ -z "${REGISTRY_USERNAME}" ] || [ -z "${REGISTRY_PASSWORD}" ]; then
  echo "Credentials are required, but none defined."
  exit 1
fi

if [ "${FORCE}" == "1" ] || [ "${FORCE}" == "True" ] || [ "${FORCE}" == "TRUE" ] || [ "${FORCE}" == "true" ]; then
  FORCE="-f"
else
  FORCE=""
fi

if [ "${REGISTRY_USERNAME}" ]; then
  echo "Username is defined, using as parameter."
  REGISTRY_USERNAME="--username ${REGISTRY_USERNAME}"
fi

if [ "${REGISTRY_PASSWORD}" ]; then
  echo "Password is defined, using as parameter."
  REGISTRY_PASSWORD="--password ${REGISTRY_PASSWORD}"
fi

if [ "${REGISTRY_VERSION}" ]; then
  echo "Version is defined, using as parameter."
  REGISTRY_VERSION="--version ${REGISTRY_VERSION}"
fi

if [ "${REGISTRY_APPVERSION}" ]; then
  echo "App version is defined, using as parameter."
  REGISTRY_APPVERSION="--app-version ${REGISTRY_APPVERSION}"
fi

helm registry login ${REGISTRY_HOSTNAME} ${REGISTRY_USERNAME} ${REGISTRY_PASSWORD}

cd ${CHART_FOLDER}
helm lint .
helm package . ${REGISTRY_APPVERSION} ${REGISTRY_VERSION}
helm inspect chart *.tgz
helm push *.tgz ${REGISTRY_URL} ${FORCE}
