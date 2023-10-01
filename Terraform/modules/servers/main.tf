resource "hcloud_server" "redis" {
  count = 3
  name         = "redis-${count.index}"
  image        = var.image_name
  server_type  = "cx21"
  ssh_keys = [data.hcloud_ssh_key.key1.id,data.hcloud_ssh_key.key2.id,data.hcloud_ssh_key.key3.id]
  location = var.location
}


resource "hcloud_server" "monitoring" {
  count = 2
  name         = "monitoring-${count.index}"
  image        = var.image_name
  server_type  = "cx21"
  ssh_keys = [data.hcloud_ssh_key.key1.id,data.hcloud_ssh_key.key2.id,data.hcloud_ssh_key.key3.id]
  location = var.location
}




data "hcloud_ssh_key" "key1"  {
  name = "kang"

}

data "hcloud_ssh_key" "key2"  {
  name = "Kangkey"
}

data "hcloud_ssh_key" "key3" {
  name = "ssh_key_bastion"
}


resource "local_file" "inventory" {
  content = templatefile("${path.module}/inventory.tpl",
    {
      redis_ips = hcloud_server.redis.*.ipv4_address
      monitoring_ips = hcloud_server.monitoring.*.ipv4_address
    }
  )
  filename = "${path.module}/../../inventory.yaml"
}


resource "local_file" "etcd-hosts" {
  content  = templatefile("${path.module}/etchost.tpl",
    {
      redis_ips = hcloud_server.redis.*.ipv4_address
      monitoring_ips = hcloud_server.monitoring.*.ipv4_address
    }
  )
  filename = "${path.module}/../../../Ansible/roles/Install_Redis/files/etchost.yaml"
}







