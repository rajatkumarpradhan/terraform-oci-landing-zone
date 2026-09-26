resource "oci_identity_compartment" "this" {
  for_each = var.compartments

  compartment_id = var.parent_compartment_id
  name           = "${var.name_prefix}-${each.key}"
  description    = each.value
  enable_delete  = true
  freeform_tags  = var.freeform_tags
}

resource "oci_identity_group" "this" {
  for_each = var.groups

  compartment_id = var.tenancy_ocid
  name           = "${var.name_prefix}-${each.key}"
  description    = each.value.description
}

# Least privilege: every group manages only its own compartment scope.
# Tenancy-scoped groups are deliberately not created by this module.
resource "oci_identity_policy" "this" {
  for_each = { for k, g in var.groups : k => g if g.scope != "tenancy" }

  compartment_id = var.tenancy_ocid
  name           = "${var.name_prefix}-${each.key}-policy"
  description    = "Grants ${each.key} administration inside the ${each.value.scope} compartment only."
  statements = [
    "Allow group ${oci_identity_group.this[each.key].name} to manage all-resources in compartment ${oci_identity_compartment.this[each.value.scope].name}"
  ]
}

resource "oci_identity_dynamic_group" "instances" {
  compartment_id = var.tenancy_ocid
  name           = "${var.name_prefix}-instances"
  description    = "All compute instances in the landing-zone compartments."
  matching_rule  = "ANY {${join(", ", [for k in keys(var.compartments) : "instance.compartment.id = '${oci_identity_compartment.this[k].id}'"])}}"
}
