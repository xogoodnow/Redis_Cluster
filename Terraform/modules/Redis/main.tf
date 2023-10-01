
resource "null_resource" "Redis" {
  provisioner "local-exec" {
    command = "sleep 111  && PWD='../' ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory.yaml ../Ansible/playbooks/Setup.yaml --private-key sshkey/private_key.pem"
  }
}

