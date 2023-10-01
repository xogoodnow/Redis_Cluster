output "redis_ips" {
  value = hcloud_server.redis[*].ipv4_address
}

output "monitoring_ips" {
  value = hcloud_server.monitoring[*].ipv4_address
}


