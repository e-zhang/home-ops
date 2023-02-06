data "vault_identity_entity" "admin_entity" {
  entity_name = var.admin_user
}

resource "vault_identity_group" "kube_admins" {
  name = "kube_admins"
  type = "internal"

  member_entity_ids = [data.vault_identity_entity.admin_entity.id]
}

resource "vault_identity_oidc_assignment" "kube_assignment" {
  name = "kube_assignment"
  entity_ids = [
    data.vault_identity_entity.admin_entity.id
  ]
  group_ids = [
    vault_identity_group.kube_admins.id
  ]
}

resource "vault_identity_oidc_client" "kubelogin" {
  name = "kubelogin"
  key  = vault_identity_oidc_key.oidc_key.name
  redirect_uris = [
    "http://localhost:8000",
    "http://localhost:18000",
  ]
  assignments = [
    vault_identity_oidc_assignment.kube_assignment.name
  ]
  id_token_ttl     = "14400"
  access_token_ttl = "43200"
  client_type      = "public"
}
