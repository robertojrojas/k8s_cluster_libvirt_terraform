
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key_pem" {
  content  = "${tls_private_key.ssh_key.private_key_pem}"
  filename = "${path.module}/private_key.pem"
  file_permission = "0400"
}

resource "local_file" "public_key" {
  content  = "${tls_private_key.ssh_key.public_key_openssh}"
  filename = "${path.module}/public_key.pub"
}
output "private_key" {
  value = tls_private_key.ssh_key.private_key_pem
  sensitive=true
}

output "public_key" {
  value = tls_private_key.ssh_key.public_key_openssh
  sensitive=true
}
