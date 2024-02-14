# demo civo cluster

export CIVO_TOKEN=$CIVO_TOKEN

terraform init

terraform apply -var="cluster_name=fred-demo"
