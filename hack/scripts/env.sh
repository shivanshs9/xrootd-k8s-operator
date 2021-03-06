#!/usr/bin/env bash

# Environment variables used in development. This file is sourced in the other scripts.

DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")"; pwd -P)

# K8S-cluster related
export KUBE_CONTEXT="$(kubectl config current-context)"
export KUBE_CLUSTER_PROVIDER=""
if [[ -n "$KUBE_CONTEXT" ]]; then
    if echo -n "$KUBE_CONTEXT" | egrep -q "(minishift|:8443)"; then
        export KUBE_CLUSTER_PROVIDER=minishift
    elif echo -n "$KUBE_CONTEXT" | egrep -q "kind"; then
        export KUBE_CLUSTER_PROVIDER=kind
    fi
fi

## General vars
export XROOTD_OPERATOR_NAME="xrootd-operator"
export XROOTD_OPERATOR_VERSION=$(awk '$1 == "Version" {gsub(/"/, "", $3); print $3}' version/version.go)
export XROOTD_OPERATOR_IMAGE_VERSION="$(. $DIR/release-support.sh ; getVersion)"
export XROOTD_OPERATOR_REGISTRY=""
# export XROOTD_OPERATOR_REGISTRY="quay.io/"

## Container Image vars
export XROOTD_OPERATOR_IMAGE_REPO="qserv/$XROOTD_OPERATOR_NAME"
export XROOTD_OPERATOR_IMAGE_TAG="$XROOTD_OPERATOR_IMAGE_VERSION"
export XROOTD_OPERATOR_IMAGE="$XROOTD_OPERATOR_REGISTRY$XROOTD_OPERATOR_IMAGE_REPO"
export XROOTD_OPERATOR_FULL_IMAGE="$XROOTD_OPERATOR_IMAGE:$XROOTD_OPERATOR_IMAGE_TAG"

## Operator Bundle vars
export XROOTD_OPERATOR_BUNDLE_DIR="bundle"
export XROOTD_OPERATOR_BUNDLE_MANIFEST_DIR="${XROOTD_OPERATOR_BUNDLE_DIR}/manifests"
export XROOTD_OPERATOR_BUNDLE_METADATA_DIR="$XROOTD_OPERATOR_BUNDLE_DIR/metadata"
export XROOTD_OPERATOR_BUNDLE_IMAGE_REPO="qserv/$XROOTD_OPERATOR_NAME-bundle"
export XROOTD_OPERATOR_BUNDLE_IMAGE_TAG="$XROOTD_OPERATOR_VERSION"
export XROOTD_OPERATOR_BUNDLE_IMAGE="$XROOTD_OPERATOR_REGISTRY$XROOTD_OPERATOR_BUNDLE_IMAGE_REPO:$XROOTD_OPERATOR_BUNDLE_IMAGE_TAG"

## Ensure go module support is enabled
export GO111MODULE=on
