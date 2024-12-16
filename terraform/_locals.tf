locals {
  # global configurations
  agent         = 1
  proxmox_node  = "bee"
  onboot        = true
  template_id   = 9001
  template_name = "ubuntu-2404-cloud-nit"

  # Base network configuration
  network = {
    base_ip = "192.168.31.0/24"
    gateway = "192.168.31.1"
    bridge  = "vmbr0"
    netmask = "24"
  }

  # VM base configurations
  vm_defaults = {
    cores     = 3
    memory    = 4096
    disk_size = 105
    tags      = ["k8s"]
    clone = {
      full = true
    }
    disk = {
      datastore_id = "local-lvm"
      file_format  = "qcow2"
      interface    = "scsi0"
      ssd         = true
      backup      = false 
      iothread    = true
      discard     = "on"
      size        = "105"
    }
  }

  # Configurações específicas para Master nodes
  master_nodes = {
    "k8s-master-0" = {
      vmid          = 200
      ip_last_octet = 20
      cores         = 3
      memory        = 4096
      tags          = ["master"]
    }
    "k8s-master-1" = {
      vmid          = 201
      ip_last_octet = 21
      cores         = 3
      memory        = 4096
      tags          = ["master"]
    }
    "k8s-master-2" = {
      vmid          = 202
      ip_last_octet = 22
      cores         = 4
      memory        = 4096
      tags          = ["master"]
    }
  }

  # Configurações específicas para Worker nodes
  worker_nodes = {
    "k8s-worker-0" = {
      vmid          = 300
      ip_last_octet = 30
      cores         = 3
      memory        = 4096
      tags          = ["worker"]
    }
    "k8s-worker-1" = {
      vmid          = 301
      ip_last_octet = 31
      cores         = 3
      memory        = 4096
      tags          = ["worker"]
    }
    "k8s-worker-2" = {
      vmid          = 302
      ip_last_octet = 32
      cores         = 3
      memory        = 4096
      tags          = ["worker"]
    }
  }

  # Combina master_nodes e worker_nodes em um único mapa para uso geral
  vms = merge(local.master_nodes, local.worker_nodes)

  # Cloud-init configurations
  cloud_init = {
    users           = ["ubuntu"]
    password        = "ubuntu"
    ssh_public_key  = file("~/.ssh/id_rsa.pub")
  }
} 