output "kubeconfig_file" {
    value = "export KUBECONFIG=${local.kubeconfig_path}"
    description = "the path of the kubeconfig file generated by the terraform"
}
