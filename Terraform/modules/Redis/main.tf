
resource "null_resource" "Redis" {
  provisioner "local-exec" {
    command = "sleep 50  && PWD='../' ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ../Ansible/inventory ../Ansible/playbooks/Deploy.yaml --private-key sshkey/private_key.pem"
  }
}

