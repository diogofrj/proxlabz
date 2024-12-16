
# resource "proxmox_virtual_environment_file" "user_data_cloud_config" {
#   content_type = "vztmpl"
#   datastore_id = "local"
#   node_name    = "bee"

#   source_raw {
#     data = <<-EOF
#     #cloud-config
#     users:
#       - default
#       - name: ubuntu
#         groups:
#           - sudo
#         shell: /bin/bash
#         ssh_authorized_keys:
#           - ${trimspace(local.cloud_init.ssh_public_key)}
#         sudo: ALL=(ALL) NOPASSWD:ALL
#     runcmd:
#         - apt update
#         - apt install -y qemu-guest-agent net-tools
#         - timedatectl set-timezone America/Sao_Paulo
#         - systemctl enable qemu-guest-agent
#         - systemctl start qemu-guest-agent
#         - echo "done" > /tmp/cloud-config.done
#     EOF

#     file_name = "./user-data-cloud-config.yaml"
#   }
# }