#!/bin/bash

# Array of clusters to be processed
clusters=("new-ss" "new-preprod" "new-prod-2")

output=() # Array to store the images from all clusters
UNIQUE_IMAGES=() # Array to store unique images

# Loop through each cluster
for cluster in "${clusters[@]}"; do
  echo "Executing on cluster: $cluster"
  # Set the kubectl context to the current cluster
  kubectl config use-context "$cluster"
  # Get the images from all deployments in the current cluster
  images=$(kubectl get deployments --all-namespaces -o json | jq -r '.items[].spec.template.spec.containers[].image ')
  output+=("$images") # Add the images to the output array
  echo "--------------------------"
done

# Populate the UNIQUE_IMAGES array with unique images
mapfile -t UNIQUE_IMAGES < <(for image in "${output[@]}"; do echo "${image}"; done | sort -u)

# Print the unique images
echo "k8s Images:"
for image in "${UNIQUE_IMAGES[@]}"; do
  echo "$image"
done