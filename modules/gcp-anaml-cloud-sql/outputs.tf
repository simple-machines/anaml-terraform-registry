# Re-export the google_sql_database_instance outputs

output "self_link" {
  value = {
    for k, v in  google_sql_database_instance.anaml_postgres_instance: k => v.self_link
  }
}

output "connection_name" {
  value = {
    for k, v in  google_sql_database_instance.anaml_postgres_instance: k => v.connection_name
  }
}

output "service_account_email_address" {
  value = {
    for k, v in  google_sql_database_instance.anaml_postgres_instance: k => v.service_account_email_address
  }
}

output "ip_address" {
  value = {
    for k, v in  google_sql_database_instance.anaml_postgres_instance: k => v.ip_address[0].ip_address
  }
}

output "ip_address_time_to_retire" {
  value = {
    for k, v in  google_sql_database_instance.anaml_postgres_instance: k => v.ip_address[0].time_to_retire
  }
}

output "ip_address_type" {
  value = {
    for k, v in  google_sql_database_instance.anaml_postgres_instance: k => v.ip_address[0].type
  }
}

output "first_ip_address" {
  value = {
    for k, v in  google_sql_database_instance.anaml_postgres_instance: k => v.first_ip_address
  }
}

output "public_ip_address" {
  value = {
    for k, v in  google_sql_database_instance.anaml_postgres_instance: k => v.public_ip_address
  }
}

output "pricate_ip_address" {
  value = {
    for k, v in  google_sql_database_instance.anaml_postgres_instance: k => v.private_ip_address
  }
}

# output "settings_version" {
#   value = {
#     for k, v in  google_sql_database_instance.anaml_postgres_instance: k => v.settings.version
#   }
# }

output "ca_cert" {
  value = {
    for k, v in  google_sql_database_instance.anaml_postgres_instance: k => v.server_ca_cert[0].cert
  }
}

output "ca_cert_common_name" {
  value = {
    for k, v in  google_sql_database_instance.anaml_postgres_instance: k => v.server_ca_cert[0].common_name
  }
}

output "ca_cert_create_time" {
  value = {
    for k, v in  google_sql_database_instance.anaml_postgres_instance: k => v.server_ca_cert[0].create_time
  }

}

output "ca_cert_expiration_time" {
  value = {
    for k, v in  google_sql_database_instance.anaml_postgres_instance: k => v.server_ca_cert[0].expiration_time
  }
}

output "ca_cert_sha1_fingerprint" {
  value = {
    for k, v in  google_sql_database_instance.anaml_postgres_instance: k => v.server_ca_cert[0].sha1_fingerprint
  }
}
