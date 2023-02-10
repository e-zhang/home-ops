variable "services" {
  type        = list(string)
  description = "list of services that need access to secrets"
  default = [
    "homeassistant"
  ]
}
