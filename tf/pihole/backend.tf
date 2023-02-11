terraform {
  backend "kubernetes" {
    secret_suffix = "pihole-dns-state"
    config_path   = "~/.kube/config"
    namespace     = "terraform"
  }
}

