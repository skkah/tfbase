provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  location = "eastus"
  name     = "rg-ansible-inventory"
}

module "network" {
  source              = "Azure/network/azurerm"
  resource_group_name = azurerm_resource_group.rg.name
  subnet_prefixes     = ["10.0.2.0/24"]
  subnet_names        = ["subnet1"] // list bracket even if you one for value of subnet
}

module "linuxservers" {
  source              = "Azure/compute/azurerm"
  resource_group_name = azurerm_resource_group.rg.name
  vm_os_simple        = "UbuntuServer"
  nb_instances        = 2
  nb_public_ip        = 2
  vm_hostname         = "vmwebdemo" // notice how this registered module tags the VMs with same name as hosts
  public_ip_dns       = var.vmhosts // vmhosts with default = ["vmwebdemo1", "vmwebdemo2"]
  vnet_subnet_id      = module.network.vnet_subnets[0]
}


resource "local_file" "inventory" {
  filename = "inventory"
  content = templatefile("template-inventory.tpl", // Terraform templatefile() can render template files in Junja2 format
    { // from this point on in this file any variable such as vm_dnshost can get instantiated as a value in template file as long as template file call for in a control statement such
      // as in %{ for host, ip in vm_dnshost ~}.
      vm_dnshost = zipmap(var.vmhosts, module.linuxservers.network_interface_private_ip) //vm_dnshost will show up a literal <name of map> = { "vmwebdemo1" = 10.0.2.4, "vmwebdemo2" = 10.0.2.5}
  })
}

output "ips" {
  value = module.linuxservers.public_ip_address
}

output "dns" {
  value = module.linuxservers.public_ip_dns_name
}

output "test" {
  value = zipmap(var.vmhosts, module.linuxservers.network_interface_private_ip)
}
