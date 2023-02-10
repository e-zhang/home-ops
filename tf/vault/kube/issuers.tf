resource "vault_policy" "ingress_issuer_policy" {
  name = "ingress_issuer_policy"

  policy = <<EOF
path "pki/+/lab/+/sign/lab-ingress-role" {
  capabilities = ["create", "update"]
}
EOF
}

resource "vault_kubernetes_auth_backend_role" "ingress_issuer_role" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "ingress-issuer"
  bound_service_account_names      = ["ingress-issuer"]
  bound_service_account_namespaces = ["cert-issuers"]
  token_ttl                        = 3600
  token_policies                   = [vault_policy.ingress_issuer_policy.name]
  audience                         = null
}

resource "vault_policy" "internal_issuer_policy" {
  name = "internal_issuer_policy"

  policy = <<EOF
path "pki/+/lab/+/sign/lab-internal-role" {
  capabilities = ["create", "update"]
}
EOF
}

resource "vault_kubernetes_auth_backend_role" "internal_issuer_role" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "internal-issuer"
  bound_service_account_names      = ["internal-issuer"]
  bound_service_account_namespaces = ["cert-issuers"]
  token_ttl                        = 3600
  token_policies                   = [vault_policy.internal_issuer_policy.name]
  audience                         = null
}

