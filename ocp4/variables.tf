# variables required for configuring Avi for Horizon with L4 VS

variable "avi_controller" {
  type    = "string"
  default = ""
}

variable "avi_username" {
  type    = "string"
}

variable "avi_password" {
  type    = "string"
}

variable "avi_api_version" {
  type    = "string"
}

variable "master_pool_placement_net" {
  type    = "string"
}

variable "infra_pool_placement_net" {
  type    = "string"
}

variable "vs_placement_net" {
  type    = "string"
}

variable "cloud_name" {
  type    = "string"
}

variable "tenant_name" {
  type    = "string"
}

variable "api_server_pool_name" {
  type    = "string"
}

variable "machineconfig_server_pool_name" {
  type    = "string"
}

variable "http_server_pool_name" {
  type    = "string"
}

variable "https_server_pool_name" {
  type    = "string"
}

variable "bootstrap_server" {
  type    = "string"
}

variable "master_server_1" {
  type    = "string"
}

variable "master_server_2" {
  type    = "string"
}

variable "master_server_3" {
  type    = "string"
}

variable "infra_server_1" {
  type    = "string"
}

variable "infra_server_2" {
  type    = "string"
}

variable "infra_server_3" {
  type    = "string"
}

variable "vs_api_server" {
  type    = "string"
}

variable "vs_machineconfig" {
  type    = "string"
}

variable "vip_api_server" {
  type    = "string"
}

variable "vip_infra_server" {
  type    = "string"
}

variable "vs_subnet_ip" {
  type    = "string"
}

variable "vs_subnet_prefix" {
  type    = "string"
}

variable "vs_http_server" {
  type    = "string"
}

variable "vs_https_server" {
  type    = "string"
}
