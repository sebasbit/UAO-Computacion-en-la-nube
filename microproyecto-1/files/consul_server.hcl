datacenter = "dc1"
node_name = "agent-server"
data_dir = "/opt/consul"
client_addr = "0.0.0.0"
ui_config{
  enabled = true
}
server = true
bind_addr = "192.168.100.6"
bootstrap_expect=1
enable_script_checks = true
