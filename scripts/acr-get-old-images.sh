#!/bin/bash

# Your Azure Container Registry name
acr_name="youracrname"

# Log in to Azure (if not already logged in)
az login

# Set the Azure Container Registry as the active registry
az acr login --name "$acr_name"

# Get a list of all repositories in the ACR
repositories=$(az acr repository list --name "$acr_name" --output json)

# Calculate the date 30 days ago in the format required by Azure CLI
date_threshold=$(date -d "30 days ago" --utc +"%Y-%m-%dT%H:%M:%SZ")

# Loop through each repository and list images older than 30 days
for repository in $(echo "$repositories" | jq -r '.[]'); do
    echo "Repository: $repository"

    # List all tags (images) for the current repository
    tags=$(az acr repository show-tags --name "$acr_name" --repository "$repository" --orderby time_desc --output json)

    # Loop through each tag and check if it's older than 30 days
    for tag in $(echo "$tags" | jq -r '.[]'); do
        image_creation_time=$(az acr repository show-manifests --name "$acr_name" --repository "$repository" --reference "$tag" --query "lastUpdateTime" --output tsv)

        if [[ "$image_creation_time" < "$date_threshold" ]]; then
            echo "Tag: $tag (Created: $image_creation_time)"
        fi
    done

    # Add a separator for better readability
    echo "--------------------------"
done