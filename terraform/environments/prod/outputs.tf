output "server_public_ip" {

  value = module.vps.public_ip
}

output "server_instance_id" {

  value = module.vps.instance_id
}