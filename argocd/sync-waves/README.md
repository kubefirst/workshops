```sh
k3d cluster create kubefirst --agents "1" --agents-memory "4096m" \
    --volume $PWD/manifests/bootstrap-k3d.yaml:/var/lib/rancher/k3s/server/manifests/bootstrap-k3d.yaml

# get the argocd root password
# visit the argocd ui

kubectl apply -f https://raw.githubusercontent.com/kubefirst/navigate/main/sync-waves/registry/registry.yaml

kubectl apply -f https://raw.githubusercontent.com/kubefirst/navigate/main/sync-waves/kubernetes-dashboard/kubernetes-dashboard.yaml

# watch the glory