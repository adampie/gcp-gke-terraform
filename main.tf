### GCP
provider "google" {
  project = "${var.project}"
  region  = "${var.region}"
}

# Uncomment if you want to use a remote state bucket
# terraform {
#   backend "gcs" {
#     bucket = "YOUR_BUCKET_NAME"
#     prefix = "YOUR_PREFIX"
#   }
# }

### GKE
resource "google_container_cluster" "cluster" {
  name                     = "${var.cluster_name}-cluster"
  region                   = "${var.region}"
  remove_default_node_pool = true
  enable_legacy_abac       = "${var.enable_legacy_abac}"
  network                  = "projects/${var.project}/global/networks/default"

  lifecycle {
    ignore_changes = ["node_pool"]
  }

  node_pool {
    name = "default-pool"
  }

  addons_config {
    kubernetes_dashboard {
      disabled = "${var.kubernetes_dashboard_disabled}"
    }
  }
}

resource "google_container_node_pool" "base_np" {
  name               = "base-pool"
  region             = "${var.region}"
  cluster            = "${google_container_cluster.cluster.name}"
  initial_node_count = 1

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    preemptible  = "${var.preemptible}"
    disk_size_gb = "${var.disk_size_gb}"
    machine_type = "${var.machine_type}"

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

### OUTPUTS
output "cluster_master_endpoint" {
  value = "${google_container_cluster.cluster.endpoint}"
}
