resource "vault_mount" "pki-lab" {
  path        = "pki/v2023/lab/v2023"
  type        = "pki"
  description = "lab intermediate CA"

  # 24h
  default_lease_ttl_seconds = 86400
  # 1 year
  max_lease_ttl_seconds = 31536000
}

resource "vault_pki_secret_backend_role" "lab-ingress-role" {
  backend = vault_mount.pki-lab.path
  name    = "lab-ingress-role"
  max_ttl = vault_mount.pki-lab.max_lease_ttl_seconds

  allowed_domains  = ["lab.home"]
  allow_subdomains = true
  require_cn       = true

  organization = ["EZ Homelab"]
  country      = ["US"]
  locality     = ["Seattle"]
  province     = ["WA"]
}

resource "vault_pki_secret_backend_role" "lab-interal-role" {
  backend = vault_mount.pki-lab.path
  name    = "lab-internal-role"
  max_ttl = vault_mount.pki-lab.max_lease_ttl_seconds

  allowed_domains    = concat(var.k8s_svc, var.k8s_ns, ["svc.cluster.local", "svc"])
  allow_subdomains   = true
  allow_bare_domains = true
  require_cn         = true

  ou           = ["k3s"]
  organization = ["EZ Homelab"]
  country      = ["US"]
  locality     = ["Seattle"]
  province     = ["WA"]
}

resource "vault_pki_secret_backend_intermediate_cert_request" "lab_cert" {
  depends_on   = [vault_mount.pki-lab]
  backend      = vault_mount.pki-lab.path
  type         = "internal"
  common_name  = "Lab intermediate CA"
  key_type     = "ed25519"
  ou           = "lab intermediate"
  organization = "EZ Homelab"
  country      = "US"
  province     = "WA"
  locality     = "Seattle"
}

resource "vault_pki_secret_backend_intermediate_set_signed" "lab_signed_cert" {
  count = var.signed_cert_file == "" ? 0 : 1

  depends_on  = [vault_mount.pki-lab]
  backend     = vault_mount.pki-lab.path
  certificate = file("${var.signed_cert_file}")
}

resource "vault_policy" "ingress_issuer_policy" {
  name = "ingress_issuer_policy"

  policy = <<EOF
path "pki/+/lab/+/sign/lab-ingress-role" {
  capabilities = ["create", "update"]
}
EOF
}

resource "vault_policy" "internal_issuer_policy" {
  name = "internal_issuer_policy"

  policy = <<EOF
path "pki/+/lab/+/sign/lab-internal-role" {
  capabilities = ["create", "update"]
}
EOF
}
