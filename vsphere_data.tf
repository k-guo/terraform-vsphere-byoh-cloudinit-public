data vsphere_datacenter "this" {
  name = var.datacenter_name
}

data vsphere_compute_cluster "this" {
  count         = var.cluster_name != "" ? var.machine_count : 0
  name          = var.cluster_name
  datacenter_id = data.vsphere_datacenter.this.id
}

data vsphere_host "this" {
  count         = var.host_name != "" ? var.machine_count : 0
  name          = var.host_name
  datacenter_id = data.vsphere_datacenter.this.id
}

data vsphere_datastore "this" {
  name          = var.datastore_name
  datacenter_id = data.vsphere_datacenter.this.id
}

/*
data vsphere_datastore_cluster "this" {
  name          = var.datastore_name
  datacenter_id = data.vsphere_datacenter.this.id
}
*/

data vsphere_network "this" {
  name          = var.vm_network_name
  datacenter_id = data.vsphere_datacenter.this.id
}

data vsphere_virtual_machine "template" {
  name          = var.template_name
  datacenter_id = data.vsphere_datacenter.this.id
}