terraform {
  required_providers {
    pihole = {
      source = "ryanwholey/pihole"
    }
  }
}

provider "pihole" {
  url = "http://raspberrypi.home" # PIHOLE_URL

  # Experimental, requires Pi-hole Web Interface >= 5.11.0
  api_token = var.api_token # PIHOLE_API_TOKEN
}
