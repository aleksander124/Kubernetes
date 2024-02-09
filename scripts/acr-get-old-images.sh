#!/bin/bash

# Your Azure Container Registry name
ACR_NAME="youracrname"

ACR_IMAGES=()

REPOSITORIES=$(az acr repository list --name "$ACR_NAME" --output json | jq -r '.[]')

# Set the threshold date (1 year ago)
THRESHOLD_DATE=$(date -d "1 year ago" --utc +"%Y-%m-%dT%H:%M:%SZ")

for REPOSITORY_NAME in $REPOSITORIES; do
  # Get a list of image manifests from the ACR
  IMAGE_LIST=$(az acr repository show-manifests --name "$ACR_NAME" --repository "$REPOSITORY_NAME" --orderby time_desc --detail --output json)

  # Parse the image manifests and filter images older than 1 year
  OLDEST_IMAGES=$(echo "$IMAGE_LIST" | jq -r --arg THRESHOLD "$THRESHOLD_DATE" '.[] | select(.createdTime < $THRESHOLD) | .tags[0]')

  # Check if OLDEST_IMAGES is not empty before storing
  while IFS= read -r TAG; do
    ACR_IMAGES+=("$ACR_NAME.azurecr.io/$REPOSITORY_NAME:$TAG")
  done <<< "$OLDEST_IMAGES"
done

# Print the final output as a list
echo "ACR Images:"
for image in "${ACR_IMAGES[@]}"; do
  echo "$image"
done

# Count the number of images
image_count=${#ACR_IMAGES[@]}
echo "Number of Images: $image_count"