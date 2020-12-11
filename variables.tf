variable "virtual_machines" {
  default = [
    {
      dns        = "test1.test.cloud"
      index      = "01"
      address_ip = "0.0.0.1"
    }
  ]
}
variable "vmhosts" {
  type    = list(string)
  default = ["vmwebdemo1", "vmwebdemo2"]
}
