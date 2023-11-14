## Dropin configuration to enable nomad-server
server {
  enabled          = true
  bootstrap_expect = 3
  
  server_join {
    retry_join = [ "pi-01.local", "pi-02.local", "pi-03.local" ]
    // retry_join = [ "mini-01.local", "util-01.local", "util-02.local" ]
  }
}
