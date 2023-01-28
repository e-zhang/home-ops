resource "vault_auth_backend" "kubernetes" {
  type = "kubernetes"
}

resource "vault_kubernetes_auth_backend_config" "kube_config" {
  backend         = vault_auth_backend.kubernetes.path
  kubernetes_host = "https://10.43.0.1:443"
}

resource "vault_kubernetes_auth_backend_role" "vault_issuer_role" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "vault-issuer"
  bound_service_account_names      = ["certmanager-vault-issuer"]
  bound_service_account_namespaces = ["vault"]
  token_ttl                        = 3600
  token_policies                   = ["vault_issuer_policy"]
  audience                         = null
}
