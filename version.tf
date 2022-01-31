terraform {
  required_version = ">=v1.1.2"

  required_providers {
    intersight = {
      source  = "CiscoDevNet/intersight"
      version = ">=1.0.21"
    }
  }
}
