#!/bin/bash

# Function to display script usage
usage() {
    echo "Usage: $0 -n <namespace>"
    exit 1
}

# Parse command line options
while getopts ":n:" opt; do
    case ${opt} in
        n )
            namespace=$OPTARG
            ;;
        \? )
            echo "Invalid option: $OPTARG" 1>&2
            usage
            ;;
        : )
            echo "Invalid option: $OPTARG requires an argument" 1>&2
            usage
            ;;
    esac
done
shift $((OPTIND -1))

# Check if namespace is provided
if [ -z "$namespace" ]; then
    echo "Namespace not provided."
    usage
fi

# Output file
output_file="kubernetes_backup.yaml"

# Start with empty file
: > "$output_file"

# Export Deployments
echo "Exporting Deployments from namespace $namespace..."
kubectl get deployments -n "$namespace" -o yaml >> "$output_file"

# Export Services
echo "Exporting Services from namespace $namespace..."
kubectl get services -n "$namespace" -o yaml >> "$output_file"

# Export Ingresses
echo "Exporting Ingresses from namespace $namespace..."
kubectl get ingresses -n "$namespace" -o yaml >> "$output_file"

# Export Secrets
echo "Exporting Secrets from namespace $namespace..."
kubectl get secrets -n "$namespace" -o yaml >> "$output_file"

# Export ConfigMaps
echo "Exporting ConfigMaps from namespace $namespace..."
kubectl get configmaps -n "$namespace" -o yaml >> "$output_file"

# Export ServiceAccounts
echo "Exporting ServiceAccounts from namespace $namespace..."
kubectl get serviceaccounts -n "$namespace" -o yaml >> "$output_file"

# Export DaemonSets
echo "Exporting DaemonSets from namespace $namespace..."
kubectl get daemonsets -n "$namespace" -o yaml >> "$output_file"

# Export StatefulSets
echo "Exporting StatefulSets from namespace $namespace..."
kubectl get statefulsets -n "$namespace" -o yaml >> "$output_file"

echo "Backup completed to $output_file"