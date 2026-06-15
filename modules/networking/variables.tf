variable "resource_group_name" {
  type = string
  description = "Name of the resource groups where networking resources will live"
}

variable "hub_location" {
  type = string
  default = "germanywestcentral"
  description = "Region for Hub network"
}

variable "spoke_location" {
  type = string
  default = "francecentral"
  description = "Region for Spoke network"
}

variable "hub_network" {
  type = object({
    name = string
    address_space = list(string)
    bastion_cidr = list(string)
  })
  default = {
    name = "vnet-hub-prod-ger"
    address_space = [ "10.0.0.0/16" ]
    bastion_cidr = [ "10.0.1.0/24" ]
  }
}

variable "spoke_network" {
  type = object({
    name = string
    address_space = list(string)
    app_cidr = list(string)
    data_cidr = list(string)
  })
  default = {
    name = "vnet-spke-prod-fra"
    address_space = [ "10.1.0.0/16" ]
    app_cidr = [ "10.1.1.0/24" ]
    data_cidr = [ "10.1.2.0/24" ]
  }
}
