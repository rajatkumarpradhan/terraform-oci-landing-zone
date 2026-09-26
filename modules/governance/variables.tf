variable "compartment_id" {
  description = "OCID of the compartment the budget watches (usually the tenancy root for tenancy-wide budgets)."
  type        = string
}

variable "name_prefix" {
  description = "Prefix applied to display names."
  type        = string
}

variable "budget_amount" {
  description = "Monthly budget amount in the tenancy's currency."
  type        = number

  validation {
    condition     = var.budget_amount > 0
    error_message = "budget_amount must be positive."
  }
}

variable "alert_recipients" {
  description = "Email addresses that receive budget alerts."
  type        = list(string)

  validation {
    condition     = length(var.alert_recipients) > 0
    error_message = "At least one alert recipient is required."
  }
}

variable "alert_threshold_percent" {
  description = "Percentage of the budget that triggers the alert."
  type        = number
  default     = 80

  validation {
    condition     = var.alert_threshold_percent > 0 && var.alert_threshold_percent <= 100
    error_message = "alert_threshold_percent must be in (0, 100]."
  }
}

variable "freeform_tags" {
  description = "Freeform tags applied to resources."
  type        = map(string)
  default     = {}
}
