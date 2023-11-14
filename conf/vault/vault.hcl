## Vault Configuration
ui = true

disable_mlock = true
plugin_directory = "/usr/local/libexec/vault"

api_addr     = "https://{{ GetPrivateIP }}:8200"
cluster_addr = "https://{{ GetPrivateIP }}:8201"

listener "tcp" {
  address     = "127.0.0.1:8200"
  tls_disable = true
}

listener "tcp" {
  address         = "{{ GetPrivateIP }}:8200"
  cluster_address = "{{ GetPrivateIP }}:8201"
  tls_cert_file   = "/var/cert/yk/vault/listener/cert.pem"
  tls_key_file    = "/var/cert/yk/vault/listener/key.pem"
}

storage "raft" {
  path = "/var/lib/vault"
}

telemetry {
  prometheus_retention_time = "30s"
  disable_hostname          = true
}
