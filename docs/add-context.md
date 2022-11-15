### First add cluster section to .kube/config

- cluster:
    certificate-authority-data:
    server: <https://address:6443> #api address
  name: <cluster-name>

### Save the token as system var

TOKEN=<your_token>      # For each cluster other token

### Add credentials token to specific user

# User can be random you can specify cluster too like "user-prod"

kubectl config set-credentials <your user> --token=${TOKEN}

### Add user with his token to specific context/cluster

kubectl config set-context <context-name> --cluster=<cluster-name> --user=<your-user-name>

# You can choose context name it will be helpful later to switch between contexts
