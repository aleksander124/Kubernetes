#!/bin/bash

main(){

echo "Podaj klaster z którego chcesz dostać tokeny:"
echo "1. new-prod"
echo "2. new-prod-2"
echo "3. new-preprod"
echo "4. new-SS"
echo "5. new-test"

read -r SELECTED

source /home/olek/workspace/scripts/variables.txt

if [ "$SELECTED" == 1 ]
then
CLUSTER=$CLUSTER_NEW_PROD
CERT_CLUSTER=$CERT_NEW_PROD
CLUSTER_IP=$IP_NEW_PROD
fi

if [ "$SELECTED" == 2 ]
then
CLUSTER=$CLUSTER_NEW_PROD_2
CERT_CLUSTER=$CERT_NEW_PROD_2
CLUSTER_IP=$IP_NEW_PROD_2
fi

if [ "$SELECTED" == 3 ]
then
CLUSTER=$CLUSTER_NEW_PREPROD
CERT_CLUSTER=$CERT_NEW_PREPROD
CLUSTER_IP=$IP_NEW_PREPROD
fi

if [ "$SELECTED" == 4 ]
then
CLUSTER=$CLUSTER_NEW_SS
CERT_CLUSTER=$CERT_NEW_SS
CLUSTER_IP=$IP_NEW_SS
fi

if [ "$SELECTED" == 5 ]
then
CLUSTER=$CLUSTER_NEW_TEST
CERT_CLUSTER=$CERT_NEW_TEST
CLUSTER_IP=$IP_NEW_TEST
fi


NS="default"
SA=$(kubectl get serviceaccounts -n $NS | awk '{print $1}')

kubectl config use-context $CLUSTER
kubectl config set-context --current --namespace=$NS
mkdir -p "$HOME"/$CLUSTER
arr=($SA)

for i in "${arr[@]:1}"
do
TOKEN_NAME=$(kubectl get serviceaccount "$i" -o jsonpath='{.secrets[].name}')
DECODED=$(kubectl get secret "$TOKEN_NAME" -o jsonpath='{.data.token}' | base64 -d)
tee "$HOME/$CLUSTER/$i-$CLUSTER.yaml" <<EOF
apiVersion: v1
clusters:
- cluster:
$CERT_CLUSTER
    server: $CLUSTER_IP
  name: $CLUSTER
contexts:
- context:
    cluster: $CLUSTER
    namespace: $NS
    user: $i-$CLUSTER
  name: $CLUSTER
current-context: $CLUSTER
kind: Config
preferences: {}
users:
- name: $i-$CLUSTER
  user:
    token: $DECODED
EOF
done
}

main
