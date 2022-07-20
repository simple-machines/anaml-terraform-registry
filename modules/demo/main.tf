terraform {
  required_providers {
    anaml = {
      source                = "simple-machines/anaml"
      configuration_aliases = [anaml.model_predict]
    }
    anaml-operations = {
      source = "simple-machines/anaml-operations"
    }
  }
}

