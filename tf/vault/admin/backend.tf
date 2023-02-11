terraform {
  backend "kubernetes" {
    secret_suffix = "admin-state"
    config_path   = "~/.kube/config"
    namespace     = "terraform"
  }
}
