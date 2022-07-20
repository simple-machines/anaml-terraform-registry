resource "anaml_feature" "plan_customer" {
  name        = "plan_customer"
  description = "Customer for a plan"
  # labels      = ["Pivot Feature"]
  attribute {
    key   = "Country"
    value = "Australia"
  }
  table       = anaml_table.plans.id
  select      = "customer"
  aggregation = "last"
}

resource "anaml_table" "plan_to_customer_pivot" {
  name        = "plan_to_customer_pivot"
  description = "Plan data usage at customer level"
  # labels         = ["Pivot"]
  entity_mapping = anaml_entity_mapping.plan_to_customer.id

  extra_features = [
    anaml_feature.sport_data_usage_last_n_days["7"].id,
    anaml_feature.sport_data_usage_last_n_days["28"].id,
    anaml_feature.data_loss_last_30_days.id
  ]
}

resource "anaml_feature" "sport_data_usage_last_n_days_by_customer" {
  for_each    = toset(["7", "28"])
  name        = "sport_data_usage_last_${each.key}_days_by_customer"
  description = "Total amount of data used for view sport videos."
  attribute {
    key   = "Country"
    value = "Australia"
  }
  table       = anaml_table.plan_to_customer_pivot.id
  select      = "sport_data_usage_last_${each.key}_days"
  aggregation = "sum"
}


# resource "anaml_feature" "num_plans" {
#   name        = "num_plans"
#   description = "How many plans a customer has"
#   table       = anaml_table.customer_plan_information.id
#   select      = "1"
#   aggregation = "count"
# }

# resource "anaml_feature" "count_roaming_enabled" {
#   name        = "count_roaming_enabled"
#   description = "Whether roaming is enabled"
#   table       = anaml_table.customer_plan_information.id
#   select      = "roaming_enabled"
#   filter      = "roaming_enabled"
#   aggregation = "count"
# }

# resource "anaml_feature" "count_free_sport_enabled" {
#   name        = "count_free_sport_enabled"
#   description = "Whether free sport is enabled"
#   table       = anaml_table.customer_plan_information.id
#   select      = "free_sport_enabled"
#   filter      = "free_sport_enabled"
#   aggregation = "count"
# }

# resource "anaml_feature" "count_free_music_enabled" {
#   name        = "count_free_music_enabled"
#   description = "Whether free music is enabled"
#   table       = anaml_table.customer_plan_information.id
#   select      = "free_music_enabled"
#   filter      = "free_music_enabled"
#   aggregation = "count"
# }

# resource "anaml_feature" "count_business_plans" {
#   name        = "count_business_plans"
#   description = "Whether free music is enabled"
#   table       = anaml_table.customer_plan_information.id
#   select      = "is_business_plan"
#   filter      = "is_business_plan"
#   aggregation = "count"
# }

# resource "anaml_feature_template" "customer_total_data_usage" {
#   name        = "customer_total_plan_data_usage_n_days"
#   description = "Total data usage for all of a customer's plans over the last n days"
#   table       = anaml_table.data_usage.id
#   select      = "megabytes"
#   aggregation = "sum"
# }

# resource "anaml_feature" "customer_total_data_usage" {
#   for_each    = toset(["7", "14", "28"])
#   name        = "customer_total_plan_data_usage_${each.key}_days"
#   description = "Total data usage for all of a customer's plans over the last ${each.key} days"
#   table       = anaml_table.customer_plan_information.id
#   select      = "sum_total_plan_data_usage_${each.key}_days"
#   aggregation = "sum"
#   template    = anaml_feature_template.customer_total_data_usage.id
# }

# resource "anaml_feature_template" "customer_count_slow_data_usage" {
#   name        = "customer_count_slow_data_usage"
#   description = "Total data usage for all of a customer's plans over the last n days"
#   table       = anaml_table.data_usage.id
#   select      = "megabytes"
#   aggregation = "sum"
# }

# resource "anaml_feature" "customer_count_slow_data_usage" {
#   for_each    = toset(["7", "14", "28"])
#   name        = "customer_count_slow_data_usage_${each.key}_days"
#   description = "Total number of slow data usage events for all of a customer's plans over the last ${each.key} days"
#   table       = anaml_table.customer_plan_information.id
#   select      = "count_slow_data_usage_${each.key}_days"
#   aggregation = "sum"
#   template    = anaml_feature_template.customer_count_slow_data_usage.id
# }

# resource "anaml_feature_template" "customer_count_data_loss" {
#   name        = "customer_count_data_loss"
#   description = "Total data usage for all of a customer's plans over the last n days"
#   table       = anaml_table.data_usage.id
#   select      = "megabytes"
#   aggregation = "sum"
# }

# resource "anaml_feature" "customer_count_data_loss" {
#   for_each    = toset(["7", "14", "28"])
#   name        = "customer_count_data_loss_${each.key}_days"
#   description = "Total number of slow data usage events for all of a customer's plans over the last ${each.key} days"
#   table       = anaml_table.customer_plan_information.id
#   select      = "count_data_loss_${each.key}_days"
#   aggregation = "sum"
#   template    = anaml_feature_template.customer_count_data_loss.id
# }

# resource "anaml_feature_template" "customer_count_data_loss_plus_1" {
#   name        = "customer_count_data_loss_plus_1"
#   description = "Total data usage for all of a customer's plans over the last n days"
#   over        = []
#   select      = "_ + 1"
#   entity      = anaml_entity.customer.id
# }

# resource "anaml_feature" "customer_count_data_loss_plus_1" {
#   for_each    = toset(["7", "14", "28"])
#   name        = "customer_count_data_loss_plus_1_${each.key}_days"
#   description = "Total number of slow data usage events for all of a customer's plans over the last ${each.key} days"
#   over        = [anaml_feature.customer_count_data_loss[each.key].id]
#   select      = "customer_count_data_loss_${each.key}_days + 1"
#   entity      = anaml_entity.customer.id
#   template    = anaml_feature_template.customer_count_data_loss.id
# }
