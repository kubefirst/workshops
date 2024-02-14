```sh
k3d cluster create kubefirst --agents "1" --agents-memory "4096m" \
    --volume $PWD/manifests/bootstrap-k3d.yaml:/var/lib/rancher/k3s/server/manifests/bootstrap-k3d.yaml

# get the argocd root password
# visit the argocd ui

#! <freegitopsmagic.com> address this token 

kubectl -n crossplane-system create secret generic crossplane-secrets --from-literal=CIVO_TOKEN=$CIVO_TOKEN --from-literal=TF_VAR_civo_token=$CIVO_TOKEN

kubectl apply -f https://raw.githubusercontent.com/kubefirst/navigate/main/sync-waves/registry/registry.yaml

# watch the registry application in the argocd ui
```