resource "anaml_feature" "cooked_meats_spend_sum_28_days" {
  name        = "cooked_meats_spend_sum_28_days"
  description = "Sum of spend of products categorized as Cooked Meats over the last 28 days"
  labels      = ["Spend"]
  table       = anaml_table.transactions_enriched.id
  select      = "cost"
  filter      = "hierarchy_leaf = 142"
  aggregation = "sum"
}

resource "anaml_feature" "fruitveg_spend_sum_28_days" {
  name        = "fruitveg_spend_sum_28_days"
  description = "Sum of spend of products categorized as Fruit of Vegetables over the last 28 days"
  labels      = ["Spend"]
  table       = anaml_table.transactions_enriched.id
  select      = "cost"
  filter      = "parent in (11, 111, 112)"
  aggregation = "sum"
}

resource "anaml_feature" "meat_spend_sum_28_days" {
  name        = "meat_spend_sum_28_days"
  description = "Sum of spend of products categorized as Meats over the last 28 days"
  labels      = ["Spend"]
  table       = anaml_table.transactions_enriched.id
  select      = "cost"
  filter      = "parent in (121,122)"
  aggregation = "sum"
}

resource "anaml_feature" "seafood_spend_sum_28_days" {
  name        = "seafood_spend_sum_28_days"
  description = "Sum of spend of products categorized as Seafood over the last 28 days"
  labels      = ["Spend"]
  table       = anaml_table.transactions_enriched.id
  select      = "cost"
  filter      = "parent = 15"
  aggregation = "sum"
}
