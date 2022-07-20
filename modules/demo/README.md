# Anaml Demo Terraform module

This Terraform module creates demo Anaml resources for entities, tables,
features, feature sets, and feature stores, intended to build upon generated
demo data. The module is intended to be suitable for deployment both to local
and remote instances of Anaml, and as such it doesn't include configuration for
clusters, sources, or destinations, which may be expected to vary depending on
where the module is deployed.

The module is imported by the Terraform manifest for GCP as well as by a
separate Terraform manifest for local development.

<!-- BEGIN_TF_DOCS -->
# Anaml Demo Terraform module

This Terraform module creates demo Anaml resources for entities, tables, features, feature sets, and feature stores, intended to build upon generated demo data. The module is intended to be suitable for deployment both to local and remote instances of Anaml, and as such it doesn't include configuration for clusters, sources, or destinations, which may be expected to vary depending on where the module is deployed.

The module is imported by the Terraform manifest for GCP as well as by a separate Terraform manifest for local development.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_anaml"></a> [anaml](#provider\_anaml) | n/a |
| <a name="provider_anaml.model_predict"></a> [anaml.model\_predict](#provider\_anaml.model\_predict) | n/a |
| <a name="provider_anaml-operations"></a> [anaml-operations](#provider\_anaml-operations) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [anaml-operations_attribute_restriction.country](https://registry.terraform.io/providers/simple-machines/anaml-operations/latest/docs/resources/attribute_restriction) | resource |
| [anaml-operations_attribute_restriction.criticality](https://registry.terraform.io/providers/simple-machines/anaml-operations/latest/docs/resources/attribute_restriction) | resource |
| [anaml-operations_attribute_restriction.quality_ratings](https://registry.terraform.io/providers/simple-machines/anaml-operations/latest/docs/resources/attribute_restriction) | resource |
| [anaml-operations_attribute_restriction.source_system](https://registry.terraform.io/providers/simple-machines/anaml-operations/latest/docs/resources/attribute_restriction) | resource |
| [anaml-operations_attribute_restriction.support_contract](https://registry.terraform.io/providers/simple-machines/anaml-operations/latest/docs/resources/attribute_restriction) | resource |
| [anaml-operations_branch_protection.official](https://registry.terraform.io/providers/simple-machines/anaml-operations/latest/docs/resources/branch_protection) | resource |
| [anaml-operations_caching.table-cache](https://registry.terraform.io/providers/simple-machines/anaml-operations/latest/docs/resources/caching) | resource |
| [anaml-operations_feature_store.bi_report_std_customer](https://registry.terraform.io/providers/simple-machines/anaml-operations/latest/docs/resources/feature_store) | resource |
| [anaml-operations_feature_store.customer_churn_model_v1](https://registry.terraform.io/providers/simple-machines/anaml-operations/latest/docs/resources/feature_store) | resource |
| [anaml-operations_feature_store.sports_marketing_campaign](https://registry.terraform.io/providers/simple-machines/anaml-operations/latest/docs/resources/feature_store) | resource |
| [anaml-operations_feature_store.vegetarian_model_scoring](https://registry.terraform.io/providers/simple-machines/anaml-operations/latest/docs/resources/feature_store) | resource |
| [anaml-operations_feature_store.vegetarian_model_training](https://registry.terraform.io/providers/simple-machines/anaml-operations/latest/docs/resources/feature_store) | resource |
| [anaml-operations_label_restriction.behaviour](https://registry.terraform.io/providers/simple-machines/anaml-operations/latest/docs/resources/label_restriction) | resource |
| [anaml-operations_label_restriction.crossbrand](https://registry.terraform.io/providers/simple-machines/anaml-operations/latest/docs/resources/label_restriction) | resource |
| [anaml-operations_label_restriction.customer](https://registry.terraform.io/providers/simple-machines/anaml-operations/latest/docs/resources/label_restriction) | resource |
| [anaml-operations_label_restriction.dashboard](https://registry.terraform.io/providers/simple-machines/anaml-operations/latest/docs/resources/label_restriction) | resource |
| [anaml-operations_label_restriction.decisioning](https://registry.terraform.io/providers/simple-machines/anaml-operations/latest/docs/resources/label_restriction) | resource |
| [anaml-operations_label_restriction.demographics](https://registry.terraform.io/providers/simple-machines/anaml-operations/latest/docs/resources/label_restriction) | resource |
| [anaml-operations_label_restriction.development](https://registry.terraform.io/providers/simple-machines/anaml-operations/latest/docs/resources/label_restriction) | resource |
| [anaml-operations_label_restriction.engagement](https://registry.terraform.io/providers/simple-machines/anaml-operations/latest/docs/resources/label_restriction) | resource |
| [anaml-operations_label_restriction.experience](https://registry.terraform.io/providers/simple-machines/anaml-operations/latest/docs/resources/label_restriction) | resource |
| [anaml-operations_label_restriction.local](https://registry.terraform.io/providers/simple-machines/anaml-operations/latest/docs/resources/label_restriction) | resource |
| [anaml-operations_label_restriction.machinelearning](https://registry.terraform.io/providers/simple-machines/anaml-operations/latest/docs/resources/label_restriction) | resource |
| [anaml-operations_label_restriction.pii](https://registry.terraform.io/providers/simple-machines/anaml-operations/latest/docs/resources/label_restriction) | resource |
| [anaml-operations_label_restriction.product](https://registry.terraform.io/providers/simple-machines/anaml-operations/latest/docs/resources/label_restriction) | resource |
| [anaml-operations_label_restriction.referencedata](https://registry.terraform.io/providers/simple-machines/anaml-operations/latest/docs/resources/label_restriction) | resource |
| [anaml-operations_label_restriction.spend](https://registry.terraform.io/providers/simple-machines/anaml-operations/latest/docs/resources/label_restriction) | resource |
| [anaml-operations_label_restriction.supermarket](https://registry.terraform.io/providers/simple-machines/anaml-operations/latest/docs/resources/label_restriction) | resource |
| [anaml-operations_label_restriction.targeted](https://registry.terraform.io/providers/simple-machines/anaml-operations/latest/docs/resources/label_restriction) | resource |
| [anaml-operations_label_restriction.telco](https://registry.terraform.io/providers/simple-machines/anaml-operations/latest/docs/resources/label_restriction) | resource |
| [anaml-operations_monitoring.table-monitor](https://registry.terraform.io/providers/simple-machines/anaml-operations/latest/docs/resources/monitoring) | resource |
| [anaml-operations_user.freddie_strong](https://registry.terraform.io/providers/simple-machines/anaml-operations/latest/docs/resources/user) | resource |
| [anaml-operations_user.genevieve_steele](https://registry.terraform.io/providers/simple-machines/anaml-operations/latest/docs/resources/user) | resource |
| [anaml-operations_user.gideon_york](https://registry.terraform.io/providers/simple-machines/anaml-operations/latest/docs/resources/user) | resource |
| [anaml-operations_user.jacob_carlisle](https://registry.terraform.io/providers/simple-machines/anaml-operations/latest/docs/resources/user) | resource |
| [anaml-operations_user.shawn_bloodworth](https://registry.terraform.io/providers/simple-machines/anaml-operations/latest/docs/resources/user) | resource |
| [anaml-operations_user.sonny_bowman](https://registry.terraform.io/providers/simple-machines/anaml-operations/latest/docs/resources/user) | resource |
| [anaml-operations_user.test_user](https://registry.terraform.io/providers/simple-machines/anaml-operations/latest/docs/resources/user) | resource |
| [anaml-operations_user_group.all_users](https://registry.terraform.io/providers/simple-machines/anaml-operations/latest/docs/resources/user_group) | resource |
| [anaml-operations_user_group.analysts](https://registry.terraform.io/providers/simple-machines/anaml-operations/latest/docs/resources/user_group) | resource |
| [anaml-operations_user_group.engineering](https://registry.terraform.io/providers/simple-machines/anaml-operations/latest/docs/resources/user_group) | resource |
| [anaml_entity.customer](https://registry.terraform.io/providers/simple-machines/anaml/latest/docs/resources/entity) | resource |
| [anaml_entity.household](https://registry.terraform.io/providers/simple-machines/anaml/latest/docs/resources/entity) | resource |
| [anaml_entity.phone_plan](https://registry.terraform.io/providers/simple-machines/anaml/latest/docs/resources/entity) | resource |
| [anaml_entity.store](https://registry.terraform.io/providers/simple-machines/anaml/latest/docs/resources/entity) | resource |
| [anaml_entity.tower](https://registry.terraform.io/providers/simple-machines/anaml/latest/docs/resources/entity) | resource |
| [anaml_entity.town](https://registry.terraform.io/providers/simple-machines/anaml/latest/docs/resources/entity) | resource |
| [anaml_entity_mapping.plan_to_customer](https://registry.terraform.io/providers/simple-machines/anaml/latest/docs/resources/entity_mapping) | resource |
| [anaml_feature.bill_amount_average](https://registry.terraform.io/providers/simple-machines/anaml/latest/docs/resources/feature) | resource |
| [anaml_feature.bill_percentage_change](https://registry.terraform.io/providers/simple-machines/anaml/latest/docs/resources/feature) | resource |
| [anaml_feature.cooked_meats_spend_sum_28_days](https://registry.terraform.io/providers/simple-machines/anaml/latest/docs/resources/feature) | resource |
| [anaml_feature.customer_age](https://registry.terraform.io/providers/simple-machines/anaml/latest/docs/resources/feature) | resource |
| [anaml_feature.data_loss_last_30_days](https://registry.terraform.io/providers/simple-machines/anaml/latest/docs/resources/feature) | resource |
| [anaml_feature.data_usage_daily_maximum_last_30_days](https://registry.terraform.io/providers/simple-machines/anaml/latest/docs/resources/feature) | resource |
| [anaml_feature.fruitveg_spend_sum_28_days](https://registry.terraform.io/providers/simple-machines/anaml/latest/docs/resources/feature) | resource |
| [anaml_feature.items_bought_last_n_days](https://registry.terraform.io/providers/simple-machines/anaml/latest/docs/resources/feature) | resource |
| [anaml_feature.items_lower_socio_economic_count_30_days](https://registry.terraform.io/providers/simple-machines/anaml/latest/docs/resources/feature) | resource |
| [anaml_feature.meat_spend_sum_28_days](https://registry.terraform.io/providers/simple-machines/anaml/latest/docs/resources/feature) | resource |
| [anaml_feature.plan_age](https://registry.terraform.io/providers/simple-machines/anaml/latest/docs/resources/feature) | resource |
| [anaml_feature.plan_customer](https://registry.terraform.io/providers/simple-machines/anaml/latest/docs/resources/feature) | resource |
| [anaml_feature.plan_size](https://registry.terraform.io/providers/simple-machines/anaml/latest/docs/resources/feature) | resource |
| [anaml_feature.seafood_spend_sum_28_days](https://registry.terraform.io/providers/simple-machines/anaml/latest/docs/resources/feature) | resource |
| [anaml_feature.shopping_basket_big_spender_last_30_days](https://registry.terraform.io/providers/simple-machines/anaml/latest/docs/resources/feature) | resource |
| [anaml_feature.shopping_basket_max_spend_30_days](https://registry.terraform.io/providers/simple-machines/anaml/latest/docs/resources/feature) | resource |
| [anaml_feature.sport_data_usage_last_n_days](https://registry.terraform.io/providers/simple-machines/anaml/latest/docs/resources/feature) | resource |
| [anaml_feature.sport_data_usage_last_n_days_by_customer](https://registry.terraform.io/providers/simple-machines/anaml/latest/docs/resources/feature) | resource |
| [anaml_feature.visit_count](https://registry.terraform.io/providers/simple-machines/anaml/latest/docs/resources/feature) | resource |
| [anaml_feature.visted_any_last_14_days](https://registry.terraform.io/providers/simple-machines/anaml/latest/docs/resources/feature) | resource |
| [anaml_feature_set.bi_report_std_customer](https://registry.terraform.io/providers/simple-machines/anaml/latest/docs/resources/feature_set) | resource |
| [anaml_feature_set.customer_churn_model_v1](https://registry.terraform.io/providers/simple-machines/anaml/latest/docs/resources/feature_set) | resource |
| [anaml_feature_set.sports_marketing_campaign](https://registry.terraform.io/providers/simple-machines/anaml/latest/docs/resources/feature_set) | resource |
| [anaml_feature_set.vegetarian_model](https://registry.terraform.io/providers/simple-machines/anaml/latest/docs/resources/feature_set) | resource |
| [anaml_feature_template.items_bought_last_n_days](https://registry.terraform.io/providers/simple-machines/anaml/latest/docs/resources/feature_template) | resource |
| [anaml_feature_template.sport_data_usage_last_n_days](https://registry.terraform.io/providers/simple-machines/anaml/latest/docs/resources/feature_template) | resource |
| [anaml_table.bills](https://registry.terraform.io/providers/simple-machines/anaml/latest/docs/resources/table) | resource |
| [anaml_table.brands](https://registry.terraform.io/providers/simple-machines/anaml/latest/docs/resources/table) | resource |
| [anaml_table.customer](https://registry.terraform.io/providers/simple-machines/anaml/latest/docs/resources/table) | resource |
| [anaml_table.data_usage](https://registry.terraform.io/providers/simple-machines/anaml/latest/docs/resources/table) | resource |
| [anaml_table.labels](https://registry.terraform.io/providers/simple-machines/anaml/latest/docs/resources/table) | resource |
| [anaml_table.plan_to_customer_pivot](https://registry.terraform.io/providers/simple-machines/anaml/latest/docs/resources/table) | resource |
| [anaml_table.plans](https://registry.terraform.io/providers/simple-machines/anaml/latest/docs/resources/table) | resource |
| [anaml_table.sku](https://registry.terraform.io/providers/simple-machines/anaml/latest/docs/resources/table) | resource |
| [anaml_table.sku_enriched](https://registry.terraform.io/providers/simple-machines/anaml/latest/docs/resources/table) | resource |
| [anaml_table.sku_hierarchy](https://registry.terraform.io/providers/simple-machines/anaml/latest/docs/resources/table) | resource |
| [anaml_table.towers](https://registry.terraform.io/providers/simple-machines/anaml/latest/docs/resources/table) | resource |
| [anaml_table.towns](https://registry.terraform.io/providers/simple-machines/anaml/latest/docs/resources/table) | resource |
| [anaml_table.transactions](https://registry.terraform.io/providers/simple-machines/anaml/latest/docs/resources/table) | resource |
| [anaml_table.transactions_enriched](https://registry.terraform.io/providers/simple-machines/anaml/latest/docs/resources/table) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_caching_prefix_url"></a> [caching\_prefix\_url](#input\_caching\_prefix\_url) | Destination for caching results. e.g gs://anaml-dev-warehouse/vapour-cache | `string` | n/a | yes |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | The ID of the Anaml cluster to run feature stores and previews on. | `number` | n/a | yes |
| <a name="input_destination_id"></a> [destination\_id](#input\_destination\_id) | The ID of the Anaml destination to write stores to. | `number` | n/a | yes |
| <a name="input_destination_type"></a> [destination\_type](#input\_destination\_type) | The type of the destination: local\|gcs | `string` | n/a | yes |
| <a name="input_online_feature_store_id"></a> [online\_feature\_store\_id](#input\_online\_feature\_store\_id) | The ID of the Anaml Online Feature Store destination to write to. | `number` | n/a | yes |
| <a name="input_source_id"></a> [source\_id](#input\_source\_id) | The ID of the Anaml source to run retrieve table datas from. | `number` | n/a | yes |
| <a name="input_source_type"></a> [source\_type](#input\_source\_type) | The type of the source: local\|gcs | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_customer_entity_id"></a> [customer\_entity\_id](#output\_customer\_entity\_id) | n/a |
| <a name="output_plan_entity_id"></a> [plan\_entity\_id](#output\_plan\_entity\_id) | n/a |
<!-- END_TF_DOCS -->