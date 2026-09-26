variable "tenancy_ocid" {
  description = "OCID of the tenancy. Policies are always written at tenancy level."
  type        = string
}

variable "parent_compartment_id" {
  description = "OCID of the compartment under which the landing-zone compartments are created (usually the tenancy root)."
  type        = string
}

variable "name_prefix" {
  description = "Prefix applied to compartment, group and policy display names."
  type        = string
}

variable "compartments" {
  description = "Landing-zone compartments keyed by role, for example { network = \"...\", app = \"...\", security = \"...\" }."
  type        = map(string)
}

variable "groups" {
  description = "Groups to create with the compartment scope each one administers. Scope must be a key of var.compartments or \"tenancy\"."
  type = map(object({
    description = string
    scope       = string
  }))
  default = {}
}

variable "freeform_tags" {
  description = "Freeform tags applied to compartments."
  type        = map(string)
  default     = {}
}
