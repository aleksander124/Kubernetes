
#! /bin/bash
#
# Author: Aleksander Okon
# Delete completed replicasets from all namespaces

kubectl get replicasets -A | awk '{if ($3 + $4 + $5 == 0) print $1"\t"$2}' | xargs -l bash -c 'kubectl delete replicaset $1 -n $0'