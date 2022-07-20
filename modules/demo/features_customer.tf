
resource "anaml_feature" "customer_age" {
  name        = "customer_age"
  description = "Age of a customer as of the `feature_date`.\n\nExpressed in fractional years."
  labels      = ["Demographics", "PII"]
  attribute {
    key   = "Source System"
    value = "GDH"
  }
  table       = anaml_table.customer.id
  select      = "datediff(feature_date(), date_of_birth) / 365.2425"
  aggregation = "last"
}

# resource "anaml_feature" "customer_household" {
#   name        = "customer_household"
#   description = "Most recent household information for a customer"
#   table       = anaml_table.customer.id
#   select      = "household"
#   aggregation = "last"
# }
