terraform {
  required_providers {
    scaleway = {
      source = "scaleway/scaleway"
    }
  }
  required_version = ">= 0.13"

  backend "http" {
  }

}

variable "name" {
  type    = string
  default = "myfirstcluster"
}

variable "kubernetes_version" {
  type    = string
  default = "1.24.3"
}

variable "node_type" {
  type    = string
  default = "DEV1-M"
}

variable "size" {
  type    = number
  default = "2"
}

resource "scaleway_k8s_cluster" "kubernetes" {
  name    = "${var.name}"
  version = "${var.kubernetes_version}"
  cni     = "cilium"
}


resource "scaleway_k8s_pool" "pool" {
  cluster_id = scaleway_k8s_cluster.kubernetes.id
  name       = "worker"
  node_type  = "${var.node_type}"
  size       = "${var.size}"
}

resource "local_file" "kubeconfig" {
  content = scaleway_k8s_cluster.kubernetes.kubeconfig[0].config_file
  filename = "kubeconfig"
}
