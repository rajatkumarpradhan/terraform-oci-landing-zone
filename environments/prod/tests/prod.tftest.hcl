mock_provider "oci" {
  mock_data "oci_core_services" {
    defaults = {
      services = [
        {
          id         = "ocid1.service.oc1..alltest"
          cidr_block = "all-example-services-in-oracleservicesnetwork"
          name       = "All Example Services In Oracle Services Network"
        }
      ]
    }
  }
}

variables {
  tenancy_ocid   = "ocid1.tenancy.oc1..test"
  compartment_id = "ocid1.tenancy.oc1..test"
  alert_email    = "alerts@example.com"
}

run "prod_has_four_compartments_and_db_subnet" {
  command = plan

  assert {
    condition     = length(module.iam.compartment_ids) == 4
    error_message = "Prod landing zone must create network, app, data and security compartments."
  }

  assert {
    condition     = module.network.subnet_public_ip_policy["db"] == true
    error_message = "The db subnet must forbid public IPs."
  }

  assert {
    condition     = length(module.network.subnet_ids) == 3
    error_message = "Prod network must expose public, app and db subnets."
  }
}

run "every_admin_group_gets_a_scoped_policy" {
  command = plan

  assert {
    condition     = length(module.iam.policy_ids) == length(module.iam.group_ids)
    error_message = "Every prod admin group must map to exactly one compartment-scoped policy."
  }
}
