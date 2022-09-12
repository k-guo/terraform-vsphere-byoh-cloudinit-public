# vSphere BYOH cloudinit Simple

This repo provides an example of deploying a [Cluster API BYOH host](https://github.com/vmware-tanzu/cluster-api-provider-bringyourownhost) on vSphere using a Ubuntu 20.04 VM machine. 

Cloud-init configuration is provided via the [VMware guestinfo datasource](https://github.com/vmware/cloud-init-vmware-guestinfo). A sample Packer build that has the relevant dependencies pre-installed can be found [here](https://github.com/kalenarndt/packer-vsphere-cloud-init).

## Requirements
- Terraform version >> v1.0.0
- Have a Ubuntu 20.04 VM tempalte ready in the cluster. By default it looks for `packer-linux-ubuntu-server-20-04-lts`

## Usage
1. Rename edge.tfvars.example to edge.tfvars
2. Fill in the required parameters pertaining to your vSphere cluster or hosts
   - Note: multiple VM's (count > 1) is only supported if you set DHCP to true
3. Provision the VM(s) with the configured tfvars file
   `terraform apply -var-file=edge3.tfvars`
4. If everything ran successfully. Terraform output will show the following:
```
Outputs:

instance_ip_address = {
  "edge3-byoh-1" = "172.16.203.115"
  "edge3-byoh-2" = "172.16.203.114"
}
```

## Acknowledgements

 - [Packer vSphere Cloud-Init](https://github.com/kalenarndt/packer-vsphere-cloud-init)
 - [Grant Orchard's Blog](https://grantorchard.com/terraform-vsphere-cloud-init/)
