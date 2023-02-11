terraform {
  backend "kubernetes" {
    secret_suffix = "pki-state"
    config_path   = "~/.kube/config"
    namespace     = "terraform"
  }
}
