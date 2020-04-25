## The Azure subscription/account ID
variable "subscriptionID" { 
    type = string 
    description = "Variable for our resource group"
}

## The resource group name that the new vNet will reside in.
variable "resourceGroupName" {
    type = string    
    description = "name of resource group"
}

## The Azure region that the vNet will reside in
variable "location" {    
    type = string    
    description = "location of your resource group"

}
