#!/bin/bash

clusters=("ss" "preprod" "prod")

output=()
UNIQUE_IMAGES=()

for cluster in "${clusters[@]}"; do
  echo "Executing on cluster: $cluster"
  kubectl config use-context "$cluster"
  images=$(kubectl get deployments --all-namespaces -o json | jq -r '.items[].spec.template.spec.containers[].image | select(startswith("<registry>.azurecr.io"))')
  output+=("$images")
  echo "--------------------------"
done

mapfile -t UNIQUE_IMAGES < <(for image in "${output[@]}"; do echo "${image}"; done | sort -u)

echo "k8s Images:"
for image in "${UNIQUE_IMAGES[@]}"; do
  echo "$image"
done