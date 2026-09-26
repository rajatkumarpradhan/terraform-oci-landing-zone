variable "compartment_id" {
  description = "OCID of the compartment that owns the network resources."
  type        = string
}

variable "vcn_cidr" {
  description = "Primary CIDR block for the VCN."
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.vcn_cidr, 0))
    error_message = "vcn_cidr must be a valid IPv4 CIDR block."
  }
}

variable "name_prefix" {
  description = "Prefix applied to every display name (for example dev-lz or prod-lz)."
  type        = string
}

variable "subnets" {
  description = "Subnet definitions keyed by role. Public subnets get the internet-gateway route; private subnets get NAT + service gateways."
  type = map(object({
    cidr      = string
    public    = bool
    dns_label = string
  }))

  validation {
    condition     = alltrue([for s in var.subnets : can(cidrhost(s.cidr, 0))])
    error_message = "Every subnet cidr must be a valid IPv4 CIDR block."
  }
}

variable "allowed_ssh_cidrs" {
  description = "CIDRs allowed to reach public subnets on port 22. Keep empty to disable SSH ingress entirely."
  type        = list(string)
  default     = []
}

variable "freeform_tags" {
  description = "Freeform tags applied to all network resources."
  type        = map(string)
  default     = {}
}
