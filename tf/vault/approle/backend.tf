terraform {
  backend "kubernetes" {
    secret_suffix = "approle-auth-state"
    config_path   = "~/.kube/config"
    namespace     = "terraform"
  }
}
