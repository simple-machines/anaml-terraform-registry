resource "anaml-operations_monitoring" "table-monitor" {
  name        = "table-monitor"
  description = "Monitoring for Customer Tables"
  enabled     = true
  cluster     = var.cluster_id

  tables = [
    anaml_table.bills.id
    , anaml_table.customer.id
    , anaml_table.data_usage.id
    , anaml_table.plans.id
    , anaml_table.towers.id
    , anaml_table.towns.id
    , anaml_table.transactions.id
  ]

  daily_schedule {
    start_time_of_day = "03:00:00"
  }
}
