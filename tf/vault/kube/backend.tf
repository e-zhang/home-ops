terraform {
  backend "kubernetes" {
    secret_suffix = "kube-auth-state"
    config_path   = "~/.kube/config"
    namespace     = "vault"
  }
}
