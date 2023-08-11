# https://tom-sapak.medium.com/do-we-need-terraform-for-helm-application-deployment-2d0d46b07a33



resource "kubernetes_namespace" "ingress" {
  metadata {
    name = "ingress"
  }
}

# resource "kubernetes_namespace" "dev1" {
#   metadata {
#     name = "dev1"
#   }
# }
provider "azurerm" {
  features {}
}

resource "helm_release" "nginx_ingress_controller" {
  name             = "nginx-ingress-controller"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  version          = "4.1.3"
  namespace        = "ingress"
  create_namespace = "true"

  set {
    name  = "controller.service.type"
    value = "LoadBalancer"
  }
  set {
    name  = "controller.autoscaling.enabled"
    value = "true"
  }
  set {
    name  = "controller.autoscaling.minReplicas"
    value = "2"
  }
  set {
    name  = "controller.autoscaling.maxReplicas"
    value = "10"
  }
}
# ===================

resource "kubernetes_namespace" "external-dns-public1" {
  metadata {
    name   = "externaldns"
  }
}

resource "kubernetes_namespace" "external-dns-public" {
  metadata {
    name   = "external-dns"
  }
}

resource "helm_release" "external-dns" {
  name        = "external-dns"
  chart       = "external-dns"
  repository  = "https://charts.bitnami.com/bitnami"
  # values      = [file("${path.module}/values.yaml")]
  # values      = [file("values.yaml")]
  namespace   = "external-dns"
  # version     = local.chart_version
  max_history = 5

  set {
    name  = "logLevel"
    value = "info"
  }

  set {
    name  = "policy"
    value = "upsert-only"
  }

  # set {
  #   name  = "provider"
  #   value = "azure"
  # }

  postrender {
    binary_path = "${path.module}/kustomize/kustomize.sh"
  }
  depends_on = [kubernetes_secret.external-dns-config]
}






provider "helm" {
  # Several Kubernetes authentication methods are possible: https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs#authentication
  kubernetes {
    config_path = pathexpand(var.kube_config)
  }
}

provider "kubernetes" {
  config_path = pathexpand(var.kube_config)
}

variable "kube_config" {
  type    = string
  default = "~/.kube/config"
}

variable "namespace" {
  type    = string
  default = "monitoring"
}