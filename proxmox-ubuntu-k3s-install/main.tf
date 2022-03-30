# Variable Declarations - Contains only non-sensitive defaults
variable "pm_api_url" {
  description = "Proxmox URL"
}

variable "pm_user" {
  description = "Proxmox User"
  default     = "root@pam"
}

variable "pm_password" {
  description = "Proxmox Password"
  sensitive   = true
}

variable "pool" {
  description = "Proxmox VM Pool"
}

variable "storage_pool" {
  description = "Proxmox Storage Pool for VMs"
}

variable "storage_type" {
  description = "Storage type - Change to match your storage"
  default     = "nfs"
}

variable "ssh_key" {
  description = "SSH Key to add to VM"
  sensitive   = true
}

variable "proxmox_node" {
  description = "Proxmox nodes"
  type        = list(string)
}

variable "k3s_nodes" {
  description = "K3S nodes"
  type        = list(string)
}

variable "k3s_vmid" {
  description = "K3S VM ids"
  type        = list(string)
}


variable "search_domain" {
  description = "Your domain if available"
  default = null
}

variable "name_server" {
  description = "DNS Server"
}


variable "first_network_bridge" {
  description = "Proxmox bridge for first network"
}

variable "first_network" {
  description = "IPs in 172 network"
  type        = list(string)
}

variable "first_network_gw" {
  description = "Network Gateway"
}

## Uncomment if you want to define a second network
#variable "second_network_bridge" {
#  description = "Proxmox bridge for first network"
#}

## Uncomment if you want to define a second network
#variable "second_network" {
#  description = "IPs in 192 network"
#  type        = list(string)
#}

variable "k3s_memory" {
  description = "VM Memory Size"
  type        = list(string)
  default     = ["6144", "6144", "6144", "24576", "24576", "24576"]
}

variable "k3s_cores" {
  description = "CPU Cores Size"
  type        = list(string)
  default     = ["1", "1", "1", "2", "2", "2"]
}

variable "k3s_sockets" {
  description = "CPU Sockets"
  type        = list(string)
  default     = ["2", "2", "2", "2", "2", "2"]
}


terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.6"
    }
  }
}

provider "proxmox" {
  pm_parallel     = 1
  pm_tls_insecure = true
  pm_api_url      = var.pm_api_url
  pm_password     = var.pm_password
  pm_user         = var.pm_user
}

resource "proxmox_vm_qemu" "k3s-demo" {
  count = length(var.k3s_nodes)

  name                    = var.k3s_nodes[count.index]
  vmid                    = var.k3s_vmid[count.index]
  desc                    = "Created using Terraform and cloudinit"
  target_node             = var.proxmox_node[count.index]
  clone                   = "Ubuntu-20.4.4-new-t"
  full_clone              = true
  agent                   = 1
  os_type                 = "cloud-init"
  cloudinit_cdrom_storage = var.storage_pool
  cores                   = var.k3s_cores[count.index]
  sockets                 = var.k3s_sockets[count.index]
  vcpus                   = 0
  cpu                     = "host"
  memory                  = var.k3s_memory[count.index]
  pool                    = var.pool
  searchdomain            = var.search_domain
  nameserver              = var.name_server
  bootdisk                = "scsi0"
  boot                    = "c"
  scsihw                  = "virtio-scsi-pci"

  # Setup the disk
  disk {
    size    = "100G"
    type    = "scsi"
    storage = var.storage_pool
  }

  # Assign correct bridge
  network {
    model  = "virtio"
    bridge = var.first_network_bridge
  }

  ## Uncomment if you want to define a second network
  #  network {
  #    model  = "virtio"
  #    bridge = var.second_network_bridge
  #  }

  # Setup the ip address using cloud-init.
  # Keep in mind to use the CIDR notation for the ip - (change /16 to /24 or other to fit network)
  ipconfig0 = "ip=${var.first_network[count.index]}/16,gw=${var.first_network_gw}"
  
  # Keep in mind to use the CIDR notation for the ip - (change /16 to /24 or other to fit network)
  ## Uncomment if you have 2 networks
  #ipconfig1 = "ip=${var.second_network[count.index]}/16"

  sshkeys = <<EOF
  ${var.ssh_key}
  EOF

}
