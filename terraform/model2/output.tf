output "kubeone_hosts" {
  description = "Control plane endpoints to SSH to"

  value = {
    control_plane = {
      cluster_name         = var.kae_cluster_name
      cloud_provider       = "hetzner"
      private_address      = hcloud_server_network.control_plane.*.ip
      public_address       = hcloud_server.control_plane.*.ipv4_address
      network_id           = hcloud_network.net.id
      ssh_agent_socket     = var.kae_ssh_agent_socket
      ssh_port             = var.kae_ssh_port
      ssh_private_key_file = var.kae_ssh_private_key_file
      ssh_user             = var.kae_ssh_username
    }
  }
}

output "kubeone_workers" {
  description = "Workers definitions, that will be transformed into MachineDeployment object"

  value = {
    # following outputs will be parsed by kubeone and automatically merged into
    # corresponding (by name) worker definition
    "${var.kae_cluster_name}-worker" = {
      replicas = var.kae_workers_replicas
      volume_id = element(hcloud_volume.storages.*.id, replicas.index)
      providerSpec = {
        sshPublicKeys   = [file(var.kae_ssh_public_key_file)]
        operatingSystem = var.kae_worker_os
        operatingSystemSpec = {
          distUpgradeOnBoot = false
        }
        cloudProviderSpec = {
          # provider specific fields:
          # see example under `cloudProviderSpec` section at:
          # https://github.com/kubermatic/machine-controller/blob/master/examples/hetzner-machinedeployment.yaml
          serverType = var.kae_worker_type
          location   = var.kae_datacenter
          image      = var.kae_image
          networks = [
            hcloud_network.net.id
          ]
          # Datacenter (optional)
          # datacenter = ""
          labels = {
            "${var.kae_cluster_name}-workers" = "worker"
          }
        }
      }
    }
  }
}
