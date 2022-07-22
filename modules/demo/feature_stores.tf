resource "anaml-operations_feature_store" "bi_report_std_customer" {
  name        = "bi_report_std_customer"
  description = "These metrics are consumed by the BI system for management reports and charts.\n\n * **Updated Daily**"
  labels      = ["Dashboard"]
  # attribute {
  #   key   = "Support Contact"
  #   value = "John Snow"
  # }
  attribute {
    key   = "Criticality"
    value = "High"
  }
  enabled     = true
  feature_set = anaml_feature_set.bi_report_std_customer.id
  cluster     = var.cluster_id

  dynamic "destination" {
    for_each = var.destination_type == "bigquery" || var.destination_type == "snowflake" ? [1] : []
    content {
      destination = var.destination_id
      table {
        name = "bi_report_std_customer"
      }
    }
  }

  dynamic "destination" {
    for_each = var.destination_type == "local" || var.destination_type == "gcs" ? [1] : []
    content {
      destination = var.destination_id
      folder {
        path                 = "bi_report_std_customer"
        partitioning_enabled = true
        save_mode            = "overwrite"
      }
    }
  }

  daily_schedule {
    start_time_of_day = "02:00:00"
  }
}

resource "anaml-operations_feature_store" "customer_churn_model_v1" {
  name        = "customer_churn_model_v1"
  description = "Features requireds to train and score a machine learning model predicting likelyhood of customer leaving the service."
  labels      = ["Machine Learning"]
  # attribute {
  #   key   = "Support Contact"
  #   value = "John Snow"
  # }
  attribute {
    key   = "Criticality"
    value = "Medium"
  }
  enabled     = true
  feature_set = anaml_feature_set.customer_churn_model_v1.id
  cluster     = var.cluster_id

  dynamic "destination" {
    for_each = var.destination_type == "bigquery" || var.destination_type == "snowflake" ? [1] : []
    content {
      destination = var.destination_id
      table {
        name = "customer_churn_model_v1"
      }
    }
  }

  dynamic "destination" {
    for_each = var.destination_type == "local" || var.destination_type == "gcs" ? [1] : []
    content {
      destination = var.destination_id
      folder {
        path                 = "customer_churn_model_v1"
        partitioning_enabled = true
        save_mode            = "overwrite"
      }
    }
  }

  daily_schedule {
    start_time_of_day = "02:20:00"
  }
}

resource "anaml-operations_feature_store" "sports_marketing_campaign" {
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
  enabled     = true
  feature_set = anaml_feature_set.sports_marketing_campaign.id
  cluster     = var.cluster_id

  dynamic "destination" {
    for_each = var.destination_type == "bigquery" || var.destination_type == "snowflake" ? [1] : []
    content {
      destination = var.destination_id
      table {
        name = "sports_marketing_campaign"
      }
    }
  }

  dynamic "destination" {
    for_each = var.destination_type == "local" || var.destination_type == "gcs" ? [1] : []
    content {
      destination = var.destination_id
      folder {
        path                 = "sports_marketing_campaign"
        partitioning_enabled = true
        save_mode            = "overwrite"
      }
    }
  }

  daily_schedule {
    start_time_of_day = "02:40:00"
  }
}

resource "anaml-operations_feature_store" "vegetarian_model_training" {
  name        = "vegetarian_model_training"
  description = "Features required to train a machine learning model predicting whether a customer is a vegetarian."
  labels      = ["Machine Learning"]
  # attribute {
  #   key   = "Support Contact"
  #   value = "John Snow"
  # }
  attribute {
    key   = "Criticality"
    value = "High"
  }
  enabled       = true
  branch_target = "official"
  feature_set   = anaml_feature_set.vegetarian_model.id
  cluster       = var.cluster_id

  dynamic "destination" {
    for_each = var.destination_type == "bigquery" || var.destination_type == "snowflake" ? [1] : []
    content {
      destination = var.destination_id
      table {
        name = "vegetarian_model"
      }
    }
  }

  dynamic "destination" {
    for_each = var.destination_type == "local" || var.destination_type == "gcs" ? [1] : []
    content {
      destination = var.destination_id
      folder {
        path                 = "vegetarian_model"
        partitioning_enabled = true
        save_mode            = "overwrite"
      }
    }
  }
}

resource "anaml-operations_feature_store" "vegetarian_model_scoring" {
  name        = "vegetarian_model_scoring"
  description = "Features required to score a machine learning model predicting whether a customer is a vegetarian."
  labels      = ["Machine Learning"]
  # attribute {
  #   key   = "Support Contact"
  #   value = "John Snow"
  # }
  attribute {
    key   = "Criticality"
    value = "High"
  }
  enabled       = true
  branch_target = "official"
  feature_set   = anaml_feature_set.vegetarian_model.id
  cluster       = var.cluster_id

  destination {
    destination = var.online_feature_store_id
    table {
      name      = "vegetarian_model"
      save_mode = "append"
    }
  }
}
