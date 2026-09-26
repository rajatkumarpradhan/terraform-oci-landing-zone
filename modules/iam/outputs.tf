output "compartment_ids" {
  description = "Compartment OCIDs keyed by role."
  value       = { for k, c in oci_identity_compartment.this : k => c.id }
}

output "group_ids" {
  description = "Group OCIDs keyed by role."
  value       = { for k, g in oci_identity_group.this : k => g.id }
}

output "policy_ids" {
  description = "Policy OCIDs keyed by group."
  value       = { for k, p in oci_identity_policy.this : k => p.id }
}

output "instance_dynamic_group_id" {
  description = "OCID of the dynamic group covering landing-zone compute instances."
  value       = oci_identity_dynamic_group.instances.id
}
