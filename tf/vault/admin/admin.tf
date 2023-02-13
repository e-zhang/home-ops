resource "vault_policy" "admin_policy" {
  name   = "admins"
  policy = file("admin_policy.hcl")
}

resource "vault_auth_backend" "userpass" {
  type = "userpass"

  tune {
    default_lease_ttl = "4h"
    max_lease_ttl     = "12h"
  }
}

resource "vault_generic_endpoint" "admin_user" {
  depends_on = [vault_auth_backend.userpass]

  path                 = "auth/userpass/users/${var.admin_user}"
  ignore_absent_fields = true

  data_json = jsonencode({
    "password" : var.admin_password
  })
}

resource "vault_identity_entity" "admin_entity" {
  name = var.admin_user
}

resource "vault_identity_entity_alias" "admin_entity_alias" {
  depends_on = [vault_auth_backend.userpass, vault_identity_entity.admin_entity]

  name           = var.admin_user
  canonical_id   = vault_identity_entity.admin_entity.id
  mount_accessor = vault_auth_backend.userpass.accessor
}

resource "vault_identity_group" "admin_group" {
  depends_on = [vault_auth_backend.userpass, vault_identity_entity.admin_entity]

  name              = "admins"
  type              = "internal"
  policies          = [vault_policy.admin_policy.name]
  member_entity_ids = [vault_identity_entity.admin_entity.id]
}

resource "vault_identity_mfa_totp" "totp" {
  issuer    = "Lab Vault"
  algorithm = "SHA256"
  digits    = 6
  period    = 60
}

resource "vault_identity_mfa_login_enforcement" "mfa_login_enforcement" {
  name = "mfa_login"
  mfa_method_ids = [
    vault_identity_mfa_totp.totp.method_id
  ]
  auth_method_accessors = [
    vault_auth_backend.userpass.accessor
  ]
  identity_group_ids = [
    vault_identity_group.admin_group.id
  ]
}

output "admin_entity_id" {
  value = vault_identity_entity.admin_entity.id
}

output "mfa_method_id" {
  value = vault_identity_mfa_totp.totp.method_id
}
