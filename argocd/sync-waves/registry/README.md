# create a civo cluster
```sh
terraform init

terraform apply -var=cluster_name=fred-demo -var=civo_token=$CIVO_TOKEN

kubectl -n argocd get secret/argocd-initial-admin-secret -ojsonpath="{.data.password}" | base64 -D | pbcopy

# get the argocd root password
# visit the argocd ui

#! <freegitopsmagic.com> address this token 
#! targetRevision: sync-waves

kubectl apply -f https://raw.githubusercontent.com/kubefirst/workshops/sync-waves/argocd/sync-waves/registry.yaml

# watch the registry application in the argocd ui
```