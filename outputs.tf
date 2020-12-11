output "ips" {
  value = module.linuxservers.public_ip_address
}

output "dns" {
  value = module.linuxservers.public_ip_dns_name
}

output "test" {
  value = zipmap(var.vmhosts, module.linuxservers.network_interface_private_ip)
}
