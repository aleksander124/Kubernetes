
#! /bin/bash 
kubectl get replicasets -A | awk '{if ($3 + $4 + $5 == 0) print $1 " " $2}' | xargs -l bash -c 'kubectl delete replicaset -n $0 $1'