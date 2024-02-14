```sh
k3d cluster create kubefirst --agents "1" --agents-memory "4096m" \
    --volume $PWD/manifests/bootstrap-k3d.yaml:/var/lib/rancher/k3s/server/manifests/bootstrap-k3d.yaml

# get the argocd root password
# visit the argocd ui

kubectl apply -f https://raw.githubusercontent.com/kubefirst/workshops/main/argocd/sync-waves/demo-registry/registry.yaml

# watch the registry application in the argocd ui
```