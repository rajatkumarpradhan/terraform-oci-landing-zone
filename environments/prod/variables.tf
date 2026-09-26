variable "tenancy_ocid" {
  description = "OCID of the tenancy (user OCI config or CI secret)."
  type        = string
}

variable "compartment_id" {
  description = "OCID of the parent compartment for the landing zone (often the tenancy root)."
  type        = string
}

variable "alert_email" {
  description = "Email address for budget alerts."
  type        = string
}
