provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

resource vsphere_virtual_machine "this" {
  count = var.machine_count

  name             = "${var.hostname_prefix}-${count.index+1}"
  resource_pool_id = (var.cluster_name != "" ? data.vsphere_compute_cluster.this[count.index].resource_pool_id : data.vsphere_host.this[count.index].resource_pool_id)
  datastore_id     = data.vsphere_datastore.this.id
  firmware         = data.vsphere_virtual_machine.template.firmware

  num_cpus = 2
  memory   = 2048
  guest_id = data.vsphere_virtual_machine.template.guest_id

  network_interface {
    network_id   = data.vsphere_network.this.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }
  wait_for_guest_net_timeout = "${var.wait_for_guest_net_timeout}"

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
  }

  extra_config = {
    "guestinfo.userdata"          = base64encode(templatefile("${path.module}/templates/userdata.yaml",
      {
        username         = var.username
        encrypted_passwd = var.encrypted_passwd
        ssh_public_key   = file(var.ssh_public_key)
        packages         = jsonencode(var.packages)
        hostname         = "${var.hostname_prefix}-${count.index+1}"
        ip_address       = var.ip_address
        tkg_cluster_name = var.tkg_cluster_name

      }
    ))
    "guestinfo.userdata.encoding" = "base64"
    "guestinfo.metadata"          = base64encode(templatefile("${path.module}/templates/metadata.yaml",
      {
        dhcp        = var.dhcp
        hostname    = "${var.hostname_prefix}-${count.index+1}"
        ip_address  = var.ip_address
        netmask     = var.netmask
        nameservers = jsonencode(var.nameservers)
        gateway     = var.gateway
      }
    ))
    "guestinfo.metadata.encoding" = "base64"
  }
}