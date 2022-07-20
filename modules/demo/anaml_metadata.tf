# Required for ui integration tests
resource "anaml-operations_label_restriction" "local" {
  text = "Local"
}
# Required for ui integration tests
resource "anaml-operations_label_restriction" "development" {
  text = "Development"
}
resource "anaml-operations_label_restriction" "behaviour" {
  text = "Behaviour"
}
resource "anaml-operations_label_restriction" "crossbrand" {
  text = "Cross Brand"
}
resource "anaml-operations_label_restriction" "customer" {
  text = "Customer"
}
resource "anaml-operations_label_restriction" "dashboard" {
  text = "Dashboard"
}
resource "anaml-operations_label_restriction" "decisioning" {
  text = "Decisioning"
}
resource "anaml-operations_label_restriction" "demographics" {
  text = "Demographics"
}
resource "anaml-operations_label_restriction" "engagement" {
  text = "Engagement"
}
resource "anaml-operations_label_restriction" "experience" {
  text = "Experience"
}
resource "anaml-operations_label_restriction" "machinelearning" {
  text = "Machine Learning"
}
resource "anaml-operations_label_restriction" "pii" {
  text   = "PII"
  emoji  = "🛑"
  colour = "#52D1FB"
}
resource "anaml-operations_label_restriction" "product" {
  text = "Product"
}
resource "anaml-operations_label_restriction" "referencedata" {
  text = "Reference Data"
}
resource "anaml-operations_label_restriction" "spend" {
  text = "Spend"
}
resource "anaml-operations_label_restriction" "supermarket" {
  text = "Supermarket"
}
resource "anaml-operations_label_restriction" "targeted" {
  text = "Targeted"
}
resource "anaml-operations_label_restriction" "telco" {
  text = "Telco"
}

resource "anaml-operations_attribute_restriction" "country" {
  key         = "Country"
  description = "Applicable country for terraformed resources"
  enum {
    choice {
      value          = "Australia"
      display_emoji  = "🇦🇺"
      display_colour = "#00008B"
    }
    choice {
      value = "NZ"
    }
    choice {
      value = "UK"
    }
  }
  applies_to = ["entity", "feature", "feature_set", "feature_store", "feature_template", "source", "table"]
}

resource "anaml-operations_attribute_restriction" "source_system" {
  key         = "Source System"
  description = "Original source system for the input data"
  freetext {}
  applies_to = ["feature", "feature_set", "feature_template", "source", "table"]
}

resource "anaml-operations_attribute_restriction" "support_contract" {
  key         = "Support Contact"
  description = "Who to contact for support issues"
  freetext {}
  applies_to = ["feature_set", "feature_store"]
}

resource "anaml-operations_attribute_restriction" "criticality" {
  key         = "Criticality"
  description = "Standard criticality level"
  enum {
    choice {
      value = "Low"
    }
    choice {
      value = "Medium"
    }
    choice {
      value = "High"
    }
  }
  applies_to = ["feature_set", "feature_store"]
}

resource "anaml-operations_attribute_restriction" "quality_ratings" {
  key         = "Quality Ratings"
  description = "Rating for input data quality based on descriptions in wiki."
  enum {
    choice {
      value          = "Bronze"
      display_emoji  = "🥉"
      display_colour = "#AD8A56"
    }
    choice {
      value          = "Silver"
      display_emoji  = "🥈"
      display_colour = "#D7D7D7"
    }
    choice {
      value          = "Gold"
      display_emoji  = "🥇"
      display_colour = "#C9B037"
    }
  }
  applies_to = ["feature", "feature_template", "table"]
}
