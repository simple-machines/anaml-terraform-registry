
# resource "anaml_table" "household_customer_information" {
#   name           = "household_customer_information"
#   description    = "Household keyed table of customer features"
#   entity_mapping = anaml_entity_mapping.customer_to_household.id

#   extra_features = [
#     anaml_feature.customer_age.id

#     , anaml_feature.num_plans.id
#     , anaml_feature.count_roaming_enabled.id
#     , anaml_feature.count_free_sport_enabled.id
#     , anaml_feature.count_free_music_enabled.id
#     , anaml_feature.count_business_plans.id

#     , anaml_feature.customer_total_data_usage["7"].id
#     , anaml_feature.customer_total_data_usage["14"].id
#     , anaml_feature.customer_total_data_usage["28"].id

#     , anaml_feature.customer_count_slow_data_usage["7"].id
#     , anaml_feature.customer_count_slow_data_usage["14"].id
#     , anaml_feature.customer_count_slow_data_usage["28"].id

#     , anaml_feature.customer_count_data_loss["7"].id
#     , anaml_feature.customer_count_data_loss["14"].id
#     , anaml_feature.customer_count_data_loss["28"].id
#   ]
# }

# resource "anaml_feature" "household_mean_age" {
#   name        = "household_mean_age"
#   description = "The average age of customers in a household."
#   table       = anaml_table.household_customer_information.id
#   select      = "customer_age"
#   aggregation = "avg"
# }

# resource "anaml_feature" "household_size" {
#   name        = "household_size"
#   description = "How many customers share a household."
#   table       = anaml_table.household_customer_information.id
#   select      = "1"
#   aggregation = "count"
# }

# resource "anaml_feature" "household_num_plans" {
#   name        = "household_num_plans"
#   description = "How many plans the customers in a household have"
#   table       = anaml_table.household_customer_information.id
#   select      = "num_plans"
#   aggregation = "sum"
# }

# resource "anaml_feature_template" "household_total_data_usage" {
#   name        = "household_total_plan_data_usage_n_days"
#   description = "Total data usage for all of a household's customers."
#   table       = anaml_table.data_usage.id
#   select      = "megabytes"
#   aggregation = "sum"
# }

# resource "anaml_feature" "household_total_data_usage" {
#   for_each    = toset(["7", "14", "28", "56"])
#   name        = "household_total_data_usage_${each.key}_days"
#   description = "Total data usage for all of a household's customers over the last ${each.key} days"
#   table       = anaml_table.household_customer_information.id
#   select      = "customer_total_plan_data_usage_${each.key}_days"
#   aggregation = "sum"
#   template    = anaml_feature_template.household_total_data_usage.id
# }


# resource "anaml_feature_template" "household_count_slow_data_usage" {
#   name        = "household_count_slow_data_usage"
#   description = "Total number of slow data usage events for all of a household's customers"
#   table       = anaml_table.data_usage.id
#   select      = "megabytes"
#   aggregation = "sum"
# }

# resource "anaml_feature" "household_count_slow_data_usage" {
#   for_each    = toset(["7", "14", "28", "56"])
#   name        = "household_count_slow_data_usage_${each.key}_days"
#   description = "Total number of slow data usage events for all of a household's customers over the last ${each.key} days"
#   table       = anaml_table.household_customer_information.id
#   select      = "customer_count_slow_data_usage_${each.key}_days"
#   aggregation = "sum"
#   template    = anaml_feature_template.household_count_slow_data_usage.id
# }

# resource "anaml_feature_template" "household_count_data_loss" {
#   name        = "household_count_data_loss"
#   description = "Total data usage for all of a household's customers over a window"
#   table       = anaml_table.data_usage.id
#   select      = "megabytes"
#   aggregation = "sum"
# }

# resource "anaml_feature" "household_count_data_loss" {
#   for_each    = toset(["7", "14", "28", "56"])
#   name        = "household_count_data_loss_${each.key}_days"
#   description = "Total data usage for all of a household's customers over the last ${each.key} days"
#   table       = anaml_table.household_customer_information.id
#   select      = "customer_count_data_loss_${each.key}_days"
#   aggregation = "sum"
#   template    = anaml_feature_template.household_count_data_loss.id
# }
