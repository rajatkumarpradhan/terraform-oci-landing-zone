output "vcn_id" {
  value = module.network.vcn_id
}

output "subnet_ids" {
  value = module.network.subnet_ids
}

output "compartment_ids" {
  value = module.iam.compartment_ids
}

output "budget_id" {
  value = module.governance.budget_id
}
