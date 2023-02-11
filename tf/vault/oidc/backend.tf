terraform {
  backend "kubernetes" {
    secret_suffix = "oidc-state"
    config_path   = "~/.kube/config"
    namespace     = "terraform"
  }
}
