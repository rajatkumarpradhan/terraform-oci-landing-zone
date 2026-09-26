output "vcn_id" {
  description = "OCID of the VCN."
  value       = oci_core_vcn.this.id
}

output "subnet_ids" {
  description = "Subnet OCIDs keyed by role."
  value       = { for k, s in oci_core_subnet.this : k => s.id }
}

output "internet_gateway_id" {
  description = "OCID of the internet gateway."
  value       = oci_core_internet_gateway.this.id
}

output "nat_gateway_id" {
  description = "OCID of the NAT gateway."
  value       = oci_core_nat_gateway.this.id
}

output "service_gateway_id" {
  description = "OCID of the service gateway."
  value       = oci_core_service_gateway.this.id
}

output "vcn_cidr_blocks" {
  description = "CIDR blocks assigned to the VCN."
  value       = oci_core_vcn.this.cidr_blocks
}

output "subnet_public_ip_policy" {
  description = "Whether public IPs are forbidden, keyed by subnet role. True means private."
  value       = { for k, s in oci_core_subnet.this : k => s.prohibit_public_ip_on_vnic }
}

output "private_security_list_ingress_count" {
  description = "Number of ingress rules on the private security list (expected: 1, VCN-internal only)."
  value       = length(oci_core_security_list.private.ingress_security_rules)
}
