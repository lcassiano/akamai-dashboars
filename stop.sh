#!/bin/bash

# Find kubectl binary in the os path.
KUBECTL_CMD=$(which kubectl)

# Check if kubectl is installed.
if [ ! -f "$KUBECTL_CMD" ]; then
  echo "Kubernetes client (kubectl) is not installed. Please install it to continue!"

  exit 1
fi

# Check if the kubeconfig file is available.
if [ ! -f "kubeconfig" ]; then
  echo "kubeconfig file not found! You can proceed without this file!"

  exit 1
fi

# Deploy the stack (uncomment the desired deployments and services to be applied).
export KUBECONFIG=kubeconfig

$KUBECTL_CMD delete -f stack-namespaces.yaml
$KUBECTL_CMD delete -f splunk-deployments.yaml
$KUBECTL_CMD delete -f elastic-deployments.yaml
$KUBECTL_CMD delete -f stack-services.yaml


