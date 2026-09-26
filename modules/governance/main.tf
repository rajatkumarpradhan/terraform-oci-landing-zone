resource "oci_budget_budget" "this" {
  compartment_id = var.compartment_id
  amount         = var.budget_amount
  reset_period   = "MONTHLY"
  display_name   = "${var.name_prefix}-monthly-budget"
  description    = "Landing-zone monthly spend guardrail."
  target_type    = "COMPARTMENT"
  targets        = [var.compartment_id]
  freeform_tags  = var.freeform_tags
}

resource "oci_budget_alert_rule" "forecast_breach" {
  budget_id      = oci_budget_budget.this.id
  display_name   = "${var.name_prefix}-forecast-alert"
  description    = "Warns when forecasted spend crosses the threshold."
  type           = "FORECAST"
  threshold      = var.alert_threshold_percent
  threshold_type = "PERCENTAGE"
  recipients     = join(",", var.alert_recipients)
  freeform_tags  = var.freeform_tags
}

resource "oci_budget_alert_rule" "actual_breach" {
  budget_id      = oci_budget_budget.this.id
  display_name   = "${var.name_prefix}-actual-alert"
  description    = "Warns when actual spend crosses the threshold."
  type           = "ACTUAL"
  threshold      = var.alert_threshold_percent
  threshold_type = "PERCENTAGE"
  recipients     = join(",", var.alert_recipients)
  freeform_tags  = var.freeform_tags
}
