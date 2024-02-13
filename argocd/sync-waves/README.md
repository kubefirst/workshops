```sh
k3d cluster create kubefirst --agents "1" --agents-memory "4096m"

# todo  https://docs.k3s.io/helm#automatically-deploying-manifests-and-helm-charts
# consider creating a kubernetes job at a URL that will bootstrap this through a manifest (wrap it in a helm chart?)
kubectl kustomize https://github.com/kubefirst/manifests/argocd/demo\?ref\=main | kubectl apply -f -

# get the argocd root password
# visit the argocd ui

# TODO need to adjust this to use main or a tag
kubectl apply -f https://raw.githubusercontent.com/kubefirst/workshops/sync-waves/argocd/sync-waves/registry/registry.yaml

# watch the glory
```