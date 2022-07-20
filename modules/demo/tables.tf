resource "anaml_table" "towns" {
  name        = "towns"
  description = <<-EOT
  Reference data on regions and postcodes.
  
  * Sourced from Expedia, imported weekly.
  EOT
  labels      = ["Cross Brand", "Reference Data"]
  attribute {
    key   = "Country"
    value = "Australia"
  }
  source {
    source     = var.source_id
    table_name = var.source_type == "hive" || var.source_type == "snowflake" ? "towns" : null
    folder     = var.source_type == "local" || var.source_type == "gcs" ? "towns" : null
  }

  event {
    entities = {
      (anaml_entity.town.id) = "town"
    }
    timestamp_column = "cast(concat_ws('-', year, month, day) as date)"
  }
}

resource "anaml_table" "towers" {
  name        = "towers"
  description = "Cell towers identified by a `tower_id`."
  labels      = ["Telco"]
  attribute {
    key   = "Country"
    value = "Australia"
  }
  source {
    source     = var.source_id
    table_name = var.source_type == "hive" || var.source_type == "snowflake" ? "towers" : null
    folder     = var.source_type == "local" || var.source_type == "gcs" ? "towers" : null
  }
  event {
    entities = {
      (anaml_entity.tower.id) = "tower"
    }
    timestamp_column = "cast(concat_ws('-', year, month, day) as date)"
  }
}

resource "anaml_table" "plans" {
  name        = "plans"
  description = "Information about phone plans"
  labels      = ["Telco"]
  attribute {
    key   = "Country"
    value = "Australia"
  }
  source {
    source     = var.source_id
    table_name = var.source_type == "hive" || var.source_type == "snowflake" ? "plan" : null
    folder     = var.source_type == "local" || var.source_type == "gcs" ? "plan" : null
  }
  event {
    entities = {
      (anaml_entity.phone_plan.id) = "plan"
      (anaml_entity.customer.id)   = "customer"
    }
    timestamp_column = "start_date"
  }
}

resource "anaml_table" "customer" {
  name        = "customers"
  description = "Customer demographic information"
  labels      = ["Cross Brand"]
  attribute {
    key   = "Country"
    value = "Australia"
  }
  source {
    source     = var.source_id
    table_name = var.source_type == "hive" || var.source_type == "snowflake" ? "customers" : null
    folder     = var.source_type == "local" || var.source_type == "gcs" ? "customers" : null
  }
  event {
    entities = {
      (anaml_entity.customer.id) = "customer"
    }
    timestamp_column = "join_date"
  }
}

resource "anaml_table" "data_usage" {
  name        = "data_usage"
  description = "Plan data usage"
  labels      = ["Telco"]
  attribute {
    key   = "Country"
    value = "Australia"
  }
  source {
    source     = var.source_id
    table_name = var.source_type == "hive" || var.source_type == "snowflake" ? "data_usage" : null
    folder     = var.source_type == "local" || var.source_type == "gcs" ? "data-usage" : null
  }
  event {
    entities = {
      (anaml_entity.phone_plan.id) = "plan"
    }
    timestamp_column = "usage_time"
  }
}

resource "anaml_table" "bills" {
  name        = "bills"
  description = "Plan billing usage"
  labels      = ["Telco"]
  attribute {
    key   = "Country"
    value = "Australia"
  }
  source {
    source     = var.source_id
    table_name = var.source_type == "hive" || var.source_type == "snowflake" ? "bills" : null
    folder     = var.source_type == "local" || var.source_type == "gcs" ? "bills" : null
  }
  event {
    entities = {
      (anaml_entity.customer.id)   = "customer"
      (anaml_entity.phone_plan.id) = "plan"
    }
    timestamp_column = "end_billing_period"
  }
}

resource "anaml_table" "transactions" {
  name        = "transactions"
  description = "Supermarket transactions"
  labels      = ["Supermarket"]
  attribute {
    key   = "Country"
    value = "NZ"
  }
  source {
    source     = var.source_id
    table_name = var.source_type == "hive" || var.source_type == "snowflake" ? "transactions" : null
    folder     = var.source_type == "local" || var.source_type == "gcs" ? "transactions" : null
  }
  event {
    entities = {
      (anaml_entity.customer.id) = "customer"
      (anaml_entity.store.id)    = "store"
    }
    timestamp_column = "time"
  }
}


resource "anaml_table" "sku" {
  name        = "sku"
  description = "SKU information"
  labels      = ["Supermarket", "Reference Data"]
  attribute {
    key   = "Country"
    value = "Australia"
  }
  source {
    source     = var.source_id
    table_name = var.source_type == "hive" || var.source_type == "snowflake" ? "sku" : null
    folder     = var.source_type == "local" || var.source_type == "gcs" ? "sku" : null
  }
}

resource "anaml_table" "sku_hierarchy" {
  name        = "sku_hierarchy"
  description = "SKU Hierarchy information"
  labels      = ["Supermarket", "Reference Data"]
  attribute {
    key   = "Country"
    value = "Australia"
  }
  source {
    source     = var.source_id
    table_name = var.source_type == "hive" || var.source_type == "snowflake" ? "sku_hierarchy" : null
    folder     = var.source_type == "local" || var.source_type == "gcs" ? "sku-hierarchy" : null
  }
}


resource "anaml_table" "brands" {
  name        = "brands"
  description = "Brand information"
  labels      = ["Supermarket", "Reference Data"]
  attribute {
    key   = "Country"
    value = "Australia"
  }
  source {
    source     = var.source_id
    table_name = var.source_type == "hive" || var.source_type == "snowflake" ? "brands" : null
    folder     = var.source_type == "local" || var.source_type == "gcs" ? "brands" : null
  }
}

resource "anaml_table" "labels" {
  name        = "labels"
  description = "Actual Customer information for use as labels in model prediction."
  labels      = ["Machine Learning"]
  attribute {
    key   = "Country"
    value = "NZ"
  }
  source {
    source     = var.source_id
    table_name = var.source_type == "hive" || var.source_type == "snowflake" ? "labels" : null
    folder     = var.source_type == "local" || var.source_type == "gcs" ? "labels" : null
  }
}

resource "anaml_table" "sku_enriched" {
  name        = "sku_enriched"
  description = "Enriched sku"
  labels      = ["Supermarket"]
  attribute {
    key   = "Country"
    value = "NZ"
  }
  sources = [
    anaml_table.sku.id
    , anaml_table.sku_hierarchy.id
  ]

  expression = <<-EOT
    select sku,
      cost as sku_cost,
      brand,
      s.hierarchy_leaf,
      sh.leaf.description as sku_description,
      sh.parent,
      shp.leaf.description as parent_description
    from sku s
    inner join sku_hierarchy sh on s.hierarchy_leaf = sh.leaf.leaf
    inner join sku_hierarchy shp on sh.parent = shp.leaf.leaf
  EOT
}

resource "anaml_table" "transactions_enriched" {
  name        = "transactions_enriched"
  description = "Enriched transactions"
  labels      = ["Supermarket"]
  attribute {
    key   = "Country"
    value = "NZ"
  }
  sources = [
    anaml_table.transactions.id
    , anaml_table.sku_enriched.id
    , anaml_table.brands.id
  ]

  event {
    entities = {
      (anaml_entity.customer.id) = "customer"
      (anaml_entity.store.id)    = "store"
    }
    timestamp_column = "time"
  }

  expression = <<-EOT
    SELECT
      transactions.*,
      sku_enriched.sku_cost,
      sku_enriched.hierarchy_leaf,
      sku_enriched.sku_description,
      sku_enriched.parent,
      sku_enriched.parent_description,
      brands.name,
      brands.`socio-economic` as socio_economic
    FROM
      transactions
    JOIN
      sku_enriched
    ON
      transactions.sku = sku_enriched.sku
    JOIN
      brands
    ON
      sku_enriched.brand = brands.brand
  EOT
}
