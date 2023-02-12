resource "vault_mount" "secrets" {
  path    = "secrets"
  type    = "kv"
  options = { version = "2" }
}

resource "vault_policy" "secret_policy" {
  for_each = toset(var.services)

  name = "${each.key}_secret_policy"

  policy = <<EOF
path "secrets/data/${each.key}/*" {
  capabilities = ["read"]
}
path "secrets/metadata/${each.key}/*" {
  capabilities = ["list", "read"]
}
EOF
}

resource "vault_kubernetes_auth_backend_role" "secret_read_role" {
  for_each = toset(var.services)

  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "${each.key}-secrets-role"
  bound_service_account_names      = ["${each.key}"]
  bound_service_account_namespaces = ["${each.key}"]
  token_ttl                        = 3600
  token_policies                   = [vault_policy.secret_policy[each.key].name]
  audience                         = null
}

