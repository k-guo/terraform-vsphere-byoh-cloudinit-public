output "instance_ip_address" {
  description = "The default IP address of each virtual machine deployed, indexed by name."

  value = "${zipmap(
    flatten(tolist(
      vsphere_virtual_machine.this.*.name
    )),
    flatten(tolist(
      vsphere_virtual_machine.this.*.default_ip_address
    )),
  )}"
}
