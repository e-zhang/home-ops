provider "vault" {
  address = var.bootstrap ? "http://localhost:8200" : ""
}
