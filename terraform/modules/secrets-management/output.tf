output "secret_values" {
  value     = { for tuple in regexall("(.*)=(.*)", data.sops_file.secrets.raw) : tuple[0] => tuple[1] }
  sensitive = true
}