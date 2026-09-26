module "iam" {
  source = "../../modules/iam"

  tenancy_ocid          = var.tenancy_ocid
  parent_compartment_id = var.compartment_id
  name_prefix           = "prod-lz"

  compartments = {
    network  = "Prod landing-zone network resources."
    app      = "Prod landing-zone application resources."
    data     = "Prod landing-zone data resources."
    security = "Prod landing-zone security and logging resources."
  }

  groups = {
    network-admins = {
      description = "Prod network administrators."
      scope       = "network"
    }
    app-admins = {
      description = "Prod application administrators."
      scope       = "app"
    }
    data-admins = {
      description = "Prod data administrators."
      scope       = "data"
    }
    security-auditors = {
      description = "Prod security auditors (inspect-only usage is granted separately)."
      scope       = "security"
    }
  }

  freeform_tags = local.common_tags
}

module "network" {
  source = "../../modules/network"

  compartment_id = module.iam.compartment_ids["network"]
  name_prefix    = "prod-lz"
  vcn_cidr       = "10.20.0.0/16"

  subnets = {
    public = {
      cidr      = "10.20.1.0/24"
      public    = true
      dns_label = "public"
    }
    app = {
      cidr      = "10.20.2.0/24"
      public    = false
      dns_label = "app"
    }
    db = {
      cidr      = "10.20.3.0/24"
      public    = false
      dns_label = "db"
    }
  }

  freeform_tags = local.common_tags
}

module "governance" {
  source = "../../modules/governance"

  compartment_id   = var.compartment_id
  name_prefix      = "prod-lz"
  budget_amount    = 1000
  alert_recipients = [var.alert_email]
  freeform_tags    = local.common_tags
}

locals {
  common_tags = {
    environment = "prod"
    managed-by  = "terraform"
    project     = "oci-landing-zone"
  }
}
