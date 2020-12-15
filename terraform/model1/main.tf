provider "hcloud" {
	token = var.kae_hcloud_token
}

resource "hcloud_ssh_key" "kubeone" {
  name       = "kubeone-${var.kae_cluster_name}"
  public_key = file(var.kae_ssh_public_key_file)
}

resource "hcloud_network" "net" {
  name     = var.kae_cluster_name
  ip_range = var.kae_ip_range
}

resource "hcloud_network_subnet" "kubeone" {
  network_id   = hcloud_network.net.id
  type         = "server"
  network_zone = var.kae_network_zone
  ip_range     = var.kae_ip_range
}

resource "hcloud_server_network" "control_plane" {
  count     = 1
  server_id = element(hcloud_server.control_plane.*.id, count.index)
  subnet_id = hcloud_network_subnet.kubeone.id
}

resource "hcloud_server" "control_plane" {
  count       = var.kae_control_plane_replicas
  name        = "${var.kae_cluster_name}-master-${count.index + 1}"
  server_type = var.kae_control_plane_type
  image       = var.kae_image
  location    = var.kae_datacenter



  ssh_keys = [
    hcloud_ssh_key.kubeone.id,
  ]

  labels = {
    "kubeone_cluster_name" = var.kae_cluster_name
    "role"                 = "api"
  }
}

resource "hcloud_volume" "storages" {
  name       = "${var.kae_cluster_name}-storage-${count.index + 1}"
  size       = 150
  count      = var.kae_control_plane_replicas
  location   = var.kae_datacenter
}

resource "hcloud_volume_attachment" "main" {
  count     = var.kae_control_plane_replicas
  volume_id = element(hcloud_volume.storages.*.id, count.index)
  server_id = element(hcloud_server.control_plane.*.id, count.index)
}
