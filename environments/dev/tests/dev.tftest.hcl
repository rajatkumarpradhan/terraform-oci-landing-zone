# Unit tests with a fully mocked OCI provider: no tenancy, credentials or spend.
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

run "private_subnets_never_allow_public_ips" {
  command = plan

  assert {
    condition     = module.network.subnet_public_ip_policy["app"] == true
    error_message = "The app subnet must forbid public IPs."
  }

  assert {
    condition     = module.network.subnet_public_ip_policy["public"] == false
    error_message = "The public subnet is the only one allowed to host public IPs."
  }
}

run "network_isolation_and_scaling_rules" {
  command = plan

  assert {
    condition     = module.network.vcn_cidr_blocks == tolist(["10.10.0.0/16"])
    error_message = "Dev VCN must keep its documented CIDR."
  }

  assert {
    condition     = module.network.private_security_list_ingress_count == 1
    error_message = "Private security list must allow VCN-internal traffic only."
  }
}

run "compartments_and_scoped_policies_created" {
  command = plan

  assert {
    condition     = length(module.iam.compartment_ids) == 3
    error_message = "Dev landing zone must create network, app and security compartments."
  }

  assert {
    condition     = length(module.iam.policy_ids) == 2
    error_message = "Each non-tenancy group must get exactly one compartment-scoped policy."
  }
}

run "budget_guardrails_present" {
  command = plan

  assert {
    condition     = module.governance.budget_amount == 100
    error_message = "Dev monthly budget amount changed unexpectedly."
  }

  assert {
    condition     = module.governance.forecast_alert_threshold == 80
    error_message = "Budget alerts must have at least one recipient."
  }
}
