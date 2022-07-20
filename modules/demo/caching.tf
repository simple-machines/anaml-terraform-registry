resource "anaml-operations_caching" "table-cache" {
  name        = "table-cache"
  description = "Caching for Customer Tables"
  cluster     = var.cluster_id
  prefix_url  = var.caching_prefix_url

  spec {
    table  = anaml_table.bills.id
    entity = anaml_entity.customer.id
  }

  spec {
    table  = anaml_table.bills.id
    entity = anaml_entity.phone_plan.id
  }

  spec {
    table  = anaml_table.customer.id
    entity = anaml_entity.customer.id
  }

  spec {
    table  = anaml_table.data_usage.id
    entity = anaml_entity.phone_plan.id
  }

  spec {
    table  = anaml_table.plans.id
    entity = anaml_entity.phone_plan.id
  }

  spec {
    table  = anaml_table.transactions.id
    entity = anaml_entity.customer.id
  }

  spec {
    table  = anaml_table.transactions.id
    entity = anaml_entity.store.id
  }

  spec {
    table  = anaml_table.transactions_enriched.id
    entity = anaml_entity.customer.id
  }

  spec {
    table  = anaml_table.transactions_enriched.id
    entity = anaml_entity.store.id
  }

  daily_schedule {
    # 12pm UTC = 10pm AEST
    start_time_of_day = "01:00:00"
  }
}
