terraform {
  required_version = ">= 1.3.0"
  required_providers {
    sops = {
      source = "carlpett/sops"
      version = "0.7.2"
    }
  }
}
