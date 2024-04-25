#!/bin/bash

# List of namespaces to exclude
excluded_namespaces="monitoring nginx kube-system kube-node-lease devops-ado-sc-creator default networking"

# List of service accounts to exclude
excluded_service_accounts=("default" "deployment")

# Get list of namespaces excluding excluded_namespaces
namespaces=$(kubectl get namespaces --no-headers | awk '{print $1}' | grep -v -E "$(echo "$excluded_namespaces" | tr ' ' '|')")

# Loop through each namespace
for namespace in $namespaces; do
    # Get list of service accounts in the namespace
    service_accounts=$(kubectl get serviceaccounts -n "$namespace" --no-headers | awk '{print $1}')

    # Loop through each service account
    for service_account in $service_accounts; do
        # Check if the service account is excluded
        excluded=false
        for excluded_sa in "${excluded_service_accounts[@]}"; do
            if [ "$excluded_sa" = "$service_account" ]; then
                excluded=true
                break
            fi
        done

        if $excluded; then
            echo "Skipping service account $service_account in namespace $namespace (excluded)"
            continue
        fi

        secret_name="${service_account}-token"

        # Generate YAML for the secret
        secret_yaml=$(cat <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: $secret_name
  namespace: $namespace
  annotations:
    kubernetes.io/service-account.name: $service_account
type: kubernetes.io/service-account-token
EOF
)

        # Apply the secret
        echo "Creating secret $secret_name in namespace $namespace..."
        echo "$secret_yaml" | kubectl apply -f -
    done
done
