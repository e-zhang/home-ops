resource "vault_identity_oidc_key" "oidc_key" {
  name               = "lab-oidc-key"
  allowed_client_ids = ["*"]
}

resource "vault_identity_oidc_scope" "user" {
  name     = "user"
  template = "{ \"username\": {{identity.entity.name}} }"
}

resource "vault_identity_oidc_scope" "groups" {
  name     = "groups"
  template = "{ \"groups\": {{identity.entity.groups.names}} }"
}

resource "vault_identity_oidc_provider" "oidc_provider" {
  name               = "lab-oidc-provider"
  https_enabled      = true
  issuer_host        = "vault.lab.home:8443"
  allowed_client_ids = [vault_identity_oidc_client.kubelogin.client_id]
  scopes_supported = [
    vault_identity_oidc_scope.groups.name,
    vault_identity_oidc_scope.user.name,
  ]
}

output "issuer" {
  value = vault_identity_oidc_provider.oidc_provider.issuer
}
