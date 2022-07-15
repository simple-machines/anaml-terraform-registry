resource "anaml-operations_branch_protection" "official" {
  protection_pattern = "official"
  merge_approval_rules {
    restricted {
      num_required_approvals = 1
      approvers {
        user_group {
          id = anaml-operations_user_group.engineering.id
        }
      }
    }
  }
  merge_approval_rules {
    open {
      num_required_approvals = 2
    }
  }
  push_whitelist {
    user {
      id = anaml-operations_user.sonny_bowman.id
    }
  }
  apply_to_admins       = false
  allow_branch_deletion = false
}
