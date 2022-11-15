#!/bin/bash
kubectl get secrets -A --field-selector type=kubernetes.io/tls -o=json | jq 'del(.items[].metadata.resourceVersion,.items[].metadata.uid,.items[].metadata.selfLink,.items[].metadata.creationTimestamp, .items[].metadata.managedFields)' | yq eval - -P > tls.yaml

kubectl get secrets -A --field-selector type=kubernetes.io/dockerconfigjson  -o=json | jq 'del(.items[].metadata.resourceVersion,.items[].metadata.uid,.items[].metadata.selfLink,.items[].metadata.creationTimestamp,.items[].metadata.annotations, .items[].metadata.managedFields)' | yq eval - -P > dockerregistry.yaml

kubectl get secrets -A --field-selector metadata.name=cert-wildcard -o=json | jq 'del(.items[].metadata.resourceVersion,.items[].metadata.uid,.items[].metadata.selfLink,.items[].metadata.creationTimestamp, .items[].metadata.managedFields)' | yq eval - -P > wildcards.yaml