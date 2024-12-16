# Outputs para Masters
output "master_ips" {
  value = {
    for name, vm in proxmox_virtual_environment_vm.master_nodes :
    name => "ssh -o StrictHostKeyChecking=no ${local.cloud_init.users[0]}@192.168.31.${local.master_nodes[name].ip_last_octet}"
  }
}

# Outputs para Workers
output "worker_ips" {
  value = {
    for name, vm in proxmox_virtual_environment_vm.worker_nodes :
    name => "ssh -o StrictHostKeyChecking=no ${local.cloud_init.users[0]}@192.168.31.${local.worker_nodes[name].ip_last_octet}"
  }
}

# Arquivo de hosts para Masters
resource "local_file" "masters_file" {
  content = join("\n", [
    for name, vm in proxmox_virtual_environment_vm.master_nodes :
    "192.168.31.${local.master_nodes[name].ip_last_octet} ${name}"
  ])
  filename = "masters.txt"

  depends_on = [
    proxmox_virtual_environment_vm.master_nodes
  ]
}

# Arquivo de hosts para Workers
resource "local_file" "workers_file" {
  content = join("\n", [
    for name, vm in proxmox_virtual_environment_vm.worker_nodes :
    "192.168.31.${local.worker_nodes[name].ip_last_octet} ${name}"
  ])
  filename = "workers.txt"

  depends_on = [
    proxmox_virtual_environment_vm.worker_nodes
  ]
}

# Arquivo de hosts combinado
resource "local_file" "hosts_file" {
  content = join("\n", concat(
    [for name, vm in proxmox_virtual_environment_vm.master_nodes :
    "192.168.31.${local.master_nodes[name].ip_last_octet} ${name}"],
    [for name, vm in proxmox_virtual_environment_vm.worker_nodes :
    "192.168.31.${local.worker_nodes[name].ip_last_octet} ${name}"]
  ))
  filename = "hosts.txt"

  depends_on = [
    proxmox_virtual_environment_vm.master_nodes,
    proxmox_virtual_environment_vm.worker_nodes
  ]
} 