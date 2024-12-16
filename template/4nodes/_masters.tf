resource "proxmox_virtual_environment_vm" "master_nodes" {
  for_each = local.master_nodes

  name      = each.key
  node_name = local.proxmox_node
  vm_id     = each.value.vmid
  tags      = concat(local.vm_defaults.tags, each.value.tags)

  # Clone from template
  clone {
    vm_id = local.template_id
    full  = local.vm_defaults.clone.full
  }

  # CPU & Memory
  cpu {
    cores = each.value.cores
    type  = "host"
  }
  memory {
    dedicated = each.value.memory
  }

  # Disk
  disk {
    datastore_id = local.vm_defaults.disk.datastore_id
    file_format  = local.vm_defaults.disk.file_format
    interface    = local.vm_defaults.disk.interface
    size         = local.vm_defaults.disk_size
    ssd         = local.vm_defaults.disk.ssd
    backup      = local.vm_defaults.disk.backup
    iothread    = local.vm_defaults.disk.iothread
    discard     = local.vm_defaults.disk.discard
  }

  # Network
  network_device {
    bridge = local.network.bridge
  }

  # Cloud-init
  initialization {
    ip_config {
      ipv4 {
        address = "192.168.31.${each.value.ip_last_octet}/${local.network.netmask}"
        gateway = local.network.gateway
      }
    }

    user_account {
      username = local.cloud_init.users[0]
      password = local.cloud_init.password
      keys     = [local.cloud_init.ssh_public_key]
    }
  }

  # Start on boot
  on_boot = local.onboot

  lifecycle {
    ignore_changes = [
      initialization,
      network_device,
      operating_system,
      agent
    ]
  }

}
