resource "vault_auth_backend" "kubernetes" {
  type = "kubernetes"
}

resource "vault_kubernetes_auth_backend_config" "kube_config" {
  backend         = vault_auth_backend.kubernetes.path
  kubernetes_host = "https://10.43.0.1:443"
}

resource "vault_kubernetes_auth_backend_role" "ingress_issuer_role" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "ingress-issuer"
  bound_service_account_names      = ["ingress-issuer"]
  bound_service_account_namespaces = ["cert-issuers"]
  token_ttl                        = 3600
  token_policies                   = ["ingress_issuer_policy"]
  audience                         = null
}

resource "vault_kubernetes_auth_backend_role" "internal_issuer_role" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "internal-issuer"
  bound_service_account_names      = ["internal-issuer"]
  bound_service_account_namespaces = ["cert-issuers"]
  token_ttl                        = 3600
  token_policies                   = ["internal_issuer_policy"]
  audience                         = null
}
