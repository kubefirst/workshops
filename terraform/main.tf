terraform {
  required_providers {
    civo = {
      source = "civo/civo"
    }
  }
}
provider "civo" {
  region = var.region
}

locals {
  kubeconfig_path = "./kubeconfig-${var.cluster_name}"
}

resource "civo_network" "kubefirst" {
  label = var.cluster_name
}

resource "civo_firewall" "kubefirst" {
  name                 = var.cluster_name
  network_id           = civo_network.kubefirst.id
  create_default_rules = true
}

resource "civo_kubernetes_cluster" "kubefirst" {
  name        = var.cluster_name
  network_id  = civo_network.kubefirst.id
  firewall_id = civo_firewall.kubefirst.id
  pools {
    label      = var.cluster_name
    size       = var.node_type
    node_count = var.node_count
  }
}

resource "local_file" "kubeconfig" {
  content  = civo_kubernetes_cluster.kubefirst.kubeconfig
  filename = local.kubeconfig_path
}

provider "kubernetes" {
  host                   = civo_kubernetes_cluster.kubefirst.api_endpoint
  client_certificate     = base64decode(yamldecode(civo_kubernetes_cluster.kubefirst.kubeconfig).users[0].user.client-certificate-data)
  client_key             = base64decode(yamldecode(civo_kubernetes_cluster.kubefirst.kubeconfig).users[0].user.client-key-data)
  cluster_ca_certificate = base64decode(yamldecode(civo_kubernetes_cluster.kubefirst.kubeconfig).clusters[0].cluster.certificate-authority-data)
}

resource "kubernetes_cluster_role_binding" "example" {
  metadata {
    name = "kustomize-apply-argocd"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "default"
    namespace = "default"
  }
}

resource "kubernetes_job" "wait" {
  metadata {
    name = "wait-for-cluster-ready"
  }
  spec {
    template {
      metadata {}
      spec {
        container {
          name    = "wait"
          image   = "ubuntu:latest"
          command = ["sh", "-c", "sleep 15"]
        }
        restart_policy = "Never"
      }
    }
    backoff_limit = 2
  }
  wait_for_completion = true
}

resource "kubernetes_job" "argocd_install" {
  depends_on = [ kubernetes_job.wait ]
  metadata {
    name = "kustomize-apply-argocd"
  }
  spec {
    template {
      metadata {}
      spec {
        container {
          name    = "argocd-install"
          image   = "bitnami/kubectl:1.25.12"
          command = ["sh", "-c", "kubectl kustomize https://github.com/kubefirst/manifests/argocd/demo?ref=main | kubectl apply -f -"]
        }
        restart_policy = "Never"
      }
    }
    backoff_limit = 2
  }
  wait_for_completion = true
}

resource "kubernetes_job" "argocd_wait" {
  depends_on = [ kubernetes_job.argocd_install ]
  metadata {
    name = "wait-for-apply-argocd"
  }
  spec {
    template {
      metadata {}
      spec {
        active_deadline_seconds = 120
        container {
          name    = "argocd-install"
          image   = "bitnami/kubectl:1.25.12"
          command = ["sh", "-c", "kubectl -n argocd wait --for=jsonpath='{.status.conditions[0].status}'='True' deploy/argocd-server"]
        }
        restart_policy = "Never"
      }
    }
    backoff_limit = 2
  }
  wait_for_completion = false
}

resource "kubernetes_namespace_v1" "external_dns" {
  metadata {
    name = "external-dns"
  }
}

resource "kubernetes_secret_v1" "external_dns" {
  metadata {
    name = "${kubernetes_namespace_v1.external_dns.metadata[0].name}-secrets"
    namespace = kubernetes_namespace_v1.external_dns.metadata[0].name
  }
  data = {
    token = var.civo_token
  }
  type = "Opaque"
}
