#!/bin/bash

excluded_namespaces="monitoring nginx kube-system kube-node-lease devops-ado-sc-creator default networking"

# Get list of namespaces excluding excluded_namespaces
namespaces=$(kubectl get namespaces --no-headers | awk '{print $1}' | grep -v -E "$(echo "$excluded_namespaces" | tr ' ' '|')")

# Loop through each namespace
for namespace in $namespaces; do
    # Create service account "test" in the namespace
    kubectl create serviceaccount test -n "$namespace"
done