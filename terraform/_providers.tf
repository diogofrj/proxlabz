provider "proxmox" {
  endpoint  = "https://192.168.31.180:8006/"
  api_token = var.proxmox_api_token
  insecure  = true
  ssh {
    agent    = true
    username = "terraform"
  }
}

variable "proxmox_api_token" {
  type = string
  default = "6215c36b-3cac-4335-b6d4-914420003088"
}

