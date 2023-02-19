output "secret_values" {
  value = data.sops_file.secrets
  sensitive = true
}