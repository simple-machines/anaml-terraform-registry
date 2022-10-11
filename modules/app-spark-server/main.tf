# Added to allow running multiple independent instances
# We use this for selectors targeting the below label:
# "terraform/deployment-instance" = random_uuid.deployment_instance.result
resource "random_uuid" "deployment_instance" {}
