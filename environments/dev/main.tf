module "iam" {
  source = "../../modules/iam"

  tenancy_ocid          = var.tenancy_ocid
  parent_compartment_id = var.compartment_id
  name_prefix           = "dev-lz"

  compartments = {
    network  = "Dev landing-zone network resources."
    app      = "Dev landing-zone application resources."
    security = "Dev landing-zone security and logging resources."
  }

  groups = {
    network-admins = {
      description = "Dev network administrators."
      scope       = "network"
    }
    app-admins = {
      description = "Dev application administrators."
      scope       = "app"
    }
  }

  freeform_tags = local.common_tags
}

module "network" {
  source = "../../modules/network"

  compartment_id = module.iam.compartment_ids["network"]
  name_prefix    = "dev-lz"
  vcn_cidr       = "10.10.0.0/16"

  subnets = {
    public = {
      cidr      = "10.10.1.0/24"
      public    = true
      dns_label = "public"
    }
    app = {
      cidr      = "10.10.2.0/24"
      public    = false
      dns_label = "app"
    }
  }

  # No SSH ingress by default; set allowed_ssh_cidrs in terraform.tfvars to enable.
  freeform_tags = local.common_tags
}

module "governance" {
  source = "../../modules/governance"

  compartment_id   = var.compartment_id
  name_prefix      = "dev-lz"
  budget_amount    = 100
  alert_recipients = [var.alert_email]
  freeform_tags    = local.common_tags
}

locals {
  common_tags = {
    environment = "dev"
    managed-by  = "terraform"
    project     = "oci-landing-zone"
  }
}
