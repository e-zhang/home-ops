pid_file = "/home/pi/work/vault/agent/pidfile"
 
vault {
  address = "https://vault.lab.home:8443"
  ca_cert = "/home/pi/work/lab/ca.crt"
}
 
auto_auth {
 method {
   type = "approle"
   config = {
     role_id_file_path = "/home/pi/work/vault/agent/role-id"
     secret_id_file_path = "/home/pi/work/vault/agent/secret-id"
     remove_secret_id_file_after_reading = false
   }
 }
 
 sink {
   type = "file"
   config = {
     path = "/home/pi/work/vault/agent/.vault-token"
   }
 }
}
 
cache {
  use_auto_auth_token = true
}
 
template {
  contents = <<EOF
{{ with pkiCert "pki/v2023/lab/v2023/issue/pihole-role" "common_name=raspberrypi.home" "alt_names=pi.hole"}}
{{ .Data.Key }}
{{ .Data.Cert }}
{{ end }}
EOF
  destination = "/home/pi/work/vault/certs/pihole.pem"

  exec {
    command = ["service", "lighttpd", "restart"]
  }
}
