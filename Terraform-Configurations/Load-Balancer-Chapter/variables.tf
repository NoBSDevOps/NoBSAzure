variable "resourceGroupName" {
  type = string
  description = "Name of existing resource group that you wish to have the load balancer reside in"
}

variable "name" {
  type = string
  description = "Name of load balancer"
}

variable "location" {
  type = string
  description = "Region that the load balancer will reside in"
}
