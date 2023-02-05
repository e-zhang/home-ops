variable "signed_cert_file" {
  description = "root signed cert file"
  type        = string
  default     = ""
}

variable "k8s_svc" {
  description = "k8s services that need certs"
  type        = list(string)
  default = [
    "vault",
    "contour",
    "envoy",
  ]
}

variable "k8s_ns" {
  description = "k8s namespaces that need certs"
  type        = list(string)
  default = [
    "vault",
    "projectcontour",
  ]
}
