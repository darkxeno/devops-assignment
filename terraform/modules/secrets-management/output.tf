locals {
  secret_lines = split("\n",jsondecode(data.sops_file.secrets.raw).data)
}

output "secret_values" {
  value     = { for line in local.secret_lines : split("=",line)[0] => split("=",line)[1] if(length(split("=",line)) == 2) }
  sensitive = false
}