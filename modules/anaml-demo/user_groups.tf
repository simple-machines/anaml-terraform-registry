resource "anaml-operations_user_group" "engineering" {
  name        = "Data Engineering"
  description = <<-EOT
  This group contains members from **Technology Data Engineering** team. They can run monitoring and feature generator jobs.

  * To access this group raise a [request in DRS](https://example.com)
  EOT
  members {
    user_id = anaml-operations_user.freddie_strong.id
  }
  members {
    user_id = anaml-operations_user.gideon_york.id
  }
  roles = [
    "run_monitoring",
    "run_featuregen"
  ]
}

resource "anaml-operations_user_group" "analysts" {
  name        = "Data Analysts"
  description = <<-EOT
  Data Analysts approve all new features in the `official` branch for business validity.

  * To access this group talk to [John Doe](https://example.com)
  EOT
  members {
    user_id = anaml-operations_user.jacob_carlisle.id
  }
  members {
    user_id = anaml-operations_user.genevieve_steele.id
  }
  roles = ["author"]
}

resource "anaml-operations_user_group" "all_users" {
  name        = "All Users"
  description = <<-EOT
  All Users of Anaml sync'd from Active Directory via OAuth.

  * To access this group talk to [John Doe](https://example.com)
  EOT
  members {
    # Admin user created on system setup
    user_id = 1
  }
  members {
    user_id = anaml-operations_user.jacob_carlisle.id
  }
  members {
    user_id = anaml-operations_user.genevieve_steele.id
  }
  roles = []
}
