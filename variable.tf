variable "name" {
  type = string
  #   default = "intel-rg"
}
variable "location" {
  type = string
}

variable "stg_name" {
  type = string

}

variable "account_tier" {
  type = string


}
variable "account_replication_type" {
  type = string

}
variable "vnet_name" {
  type = string
}
variable "vnet_address_space" {
  type = set(string)
}
variable "address_prefixes" {
  type = set(string)

}
variable "nic" {
  type = string

}
variable "vm_name" {
  type = string
}