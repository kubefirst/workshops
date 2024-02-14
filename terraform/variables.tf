variable "civo_token" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "node_count" {
  type = string
  default = 2
}

variable "node_type" {
  type = string
  default = "g4s.kube.medium"
}

variable "region" {
  type = string
  default = "lon1"
}
