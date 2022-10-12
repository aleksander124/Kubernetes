if [[ $# -eq 0 ]]; then echo specify usernames as args; exit 69; fi;

for user in $@; do
  TOKEN=$(kubectl get sa ${user} -ojsonpath='{.secrets[0].name}' -n default)
  echo -e "\nuser: $user\ntoken: $(kubectl get secret -n default ${TOKEN} -ojsonpath='{.data.token}' | base64 -d)"
done
