
# SOPS

data "sops_file" "secrets" {
  input_type  = "json"
  source_file = "${path.module}/../../../corda/.secrets.enc"
}