output "budget_id" {
  description = "OCID of the monthly budget."
  value       = oci_budget_budget.this.id
}

output "alert_rule_ids" {
  description = "OCIDs of the forecast and actual alert rules."
  value       = [oci_budget_alert_rule.forecast_breach.id, oci_budget_alert_rule.actual_breach.id]
}

output "budget_amount" {
  description = "Configured monthly budget amount."
  value       = oci_budget_budget.this.amount
}

output "forecast_alert_threshold" {
  description = "Forecast threshold percentage that triggers the alert."
  value       = oci_budget_alert_rule.forecast_breach.threshold
}
