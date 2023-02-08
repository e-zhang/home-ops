variable "admin_user" {
  description = "admin username"
  type        = string
}

variable "admin_password" {
  description = "admin password"
  type        = string
  sensitive   = true
}

variable "bootstrap" {
  type    = bool
  default = false
}
