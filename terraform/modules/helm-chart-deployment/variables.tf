
variable "kube_config" {
  type      = object({
    client_key = string
    client_certificate = string
    cluster_ca_certificate = string
    host = string
  })
  sensitive = true
}

variable "database_user" {
    type      = string
}

variable "database_password" {
    type      = string
    sensitive = true
}

variable "database_url" {
    type      = string
}

variable "acr_login_server" {
   type = string
}
