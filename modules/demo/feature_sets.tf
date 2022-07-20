resource "anaml_feature_set" "bi_report_std_customer" {
  name        = "bi_report_std_customer"
  description = "These metrics are consumed by the BI system for management reports and charts.\n\n * **Updated Daily**"
  entity      = anaml_entity.customer.id
  labels      = ["Dashboard"]
  attribute {
    key   = "Support Contact"
    value = "John Snow"
  }
  attribute {
    key   = "Criticality"
    value = "High"
  }
  features = [
    anaml_feature.bill_percentage_change.id,
    anaml_feature.bill_amount_average.id,
    anaml_feature.plan_size.id,
    anaml_feature.plan_age.id,
    anaml_feature.customer_age.id,
  ]
}

resource "anaml_feature_set" "customer_churn_model_v1" {
  name        = "customer_churn_model_v1"
  description = "Features requireds to train and score a machine learning model predicting likelyhood of customer shopping elsewhere."
  labels      = ["Machine Learning"]
  attribute {
    key   = "Support Contact"
    value = "John Snow"
  }
  attribute {
    key   = "Criticality"
    value = "Medium"
  }
  entity = anaml_entity.customer.id
  features = [
    anaml_feature.customer_age.id,
    anaml_feature.items_bought_last_n_days["7"].id,
    anaml_feature.visit_count.id,
    anaml_feature.visted_any_last_14_days.id
  ]
}

resource "anaml_feature_set" "sports_marketing_campaign" {
  name        = "sports_marketing_campaign"
  description = "Attributes for Pega/Unica to support decisioning based marketing campaigns to upsells sports."
  labels      = ["Decisioning"]
  # attribute {
  #   key   = "Support Contact"
  #   value = "John Snow"
  # }
  attribute {
    key   = "Criticality"
    value = "Low"
  }
  entity = anaml_entity.customer.id
  features = [
    anaml_feature.plan_size.id,
    anaml_feature.plan_age.id,
    anaml_feature.customer_age.id,
    anaml_feature.sport_data_usage_last_n_days_by_customer["7"].id,
    anaml_feature.sport_data_usage_last_n_days_by_customer["28"].id,
  ]
}

resource "anaml_feature_set" "vegetarian_model" {
  provider    = anaml.model_predict
  name        = "vegetarian_model"
  description = "Features used to predict if a customer is a vegetarian or not"
  entity      = anaml_entity.customer.id
  labels      = ["Machine Learning"]
  # attribute {
  #   key   = "Support Contact"
  #   value = "John Snow"
  # }
  attribute {
    key   = "Criticality"
    value = "High"
  }
  features = [
    anaml_feature.customer_age.id,
    anaml_feature.visit_count.id,
    anaml_feature.visted_any_last_14_days.id,
    anaml_feature.cooked_meats_spend_sum_28_days.id,
    anaml_feature.fruitveg_spend_sum_28_days.id,
    anaml_feature.meat_spend_sum_28_days.id,
    anaml_feature.seafood_spend_sum_28_days.id
  ]
}
