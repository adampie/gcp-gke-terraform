### Variables
variable "project" {}

variable "region" {}

variable "env" {}

## GKE
variable "cluster_name" {}

variable "preemptible" {
  default = "true"
}

variable "disk_size_gb" {
  default = 100
}

variable "machine_type" {
  default = "n1-standard-1"
}

variable "kubernetes_dashboard_disabled" {
  default = true
}

variable "enable_legacy_abac" {
  default = false
}
