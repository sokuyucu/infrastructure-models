variable "kae_hcloud_token" {
  default = "CtBzaPYXitI4nOi6W2kb1RVQjLeX1r9ZW77AtdHDhpZHLmyE1Wy0DyY944GSA6LB"
}

variable "kae_cluster_name" {
  default = "cluster-name-temp"
}

variable "kae_worker_os" {
  description = "OS to run on worker machines"

  # valid choices are:
  # * ubuntu
  # * centos
  # * coreos
  default = "ubuntu"
}

variable "kae_ssh_public_key_file" {
  description = "SSH public key file for kae"
  default     = "~/.ssh/test.pub"
}

variable "kae_ssh_port" {
  description = "SSH port to be used to provision instances"
  default     = 22
}

variable "kae_ssh_username" {
  description = "SSH user, used only in output"
  default     = "root"
}

variable "kae_ssh_private_key_file" {
  description = "SSH private key file used to access instances"
  default     = ""
}

variable "kae_ssh_agent_socket" {
  description = "SSH Agent socket, default to grab from $SSH_AUTH_SOCK"
  default     = "env:SSH_AUTH_SOCK"
}

# Provider specific settings

variable "kae_control_plane_type" {
  default = "cx31"
}

variable "kae_control_plane_replicas" {
  default = 3
}

variable "kae_worker_type" {
  default = "cx31"
}

variable "kae_workers_replicas" {
  default = 2
}

variable "kae_lb_type" {
  default = "lb11"
}

variable "kae_datacenter" {
  default = "nbg1"
}

variable "kae_image" {
  default = "ubuntu-18.04"
}

variable "kae_ip_range" {
  default     = "10.10.10.0/24"
  description = "ip range to use for private network"
}

variable "kae_network_zone" {
  default     = "eu-central"
  description = "network zone to use for private network"
}
