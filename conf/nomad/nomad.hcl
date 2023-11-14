## Nomad Configuration
data_dir   = "/var/data/nomad"
plugin_dir = "/usr/local/libexec/nomad"
bind_addr  = "0.0.0.0"

client {
  enabled = true

  cni_path = "/usr/libexec/cni"
  cni_config_dir = "/etc/cni/net.d"

  ## Let allocs access their own exposed ports
  bridge_network_hairpin_mode = true

  host_volume "ephemeral" {
    path = "/var/data/ephemeral"
    read_only = false
  }

  server_join {
    retry_join = [ "pi-01.local", "pi-02.local", "pi-03.local" ]
    // retry_join = [ "mini-01.local", "util-01.local", "util-02.local" ]
    retry_max = 10
    retry_interval = "15s"
  }
}

plugin "podman" {
  config {
    socket_path = "unix://run/podman/podman.sock"
  }
}

plugin "usb" {
  config {
    enabled = true

    ## Whitelist coldcard devices
    included_vendor_ids = [0xd13e]
    included_product_ids = [0xcc10]

    fingerprint_period = "1m"
  }
}

telemetry {
  collection_interval        = "1s"
  disable_hostname           = true
  prometheus_metrics         = true
  publish_allocation_metrics = true
  publish_node_metrics       = true
}
