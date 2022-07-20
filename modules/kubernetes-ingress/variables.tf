variable "kubernetes_namespace" {
  type = string
}

variable "kubernetes_ingress_annotations" {
  type    = map(string)
  default = null
}

variable "kubernetes_ingress_name" {
  type    = string
  default = "anaml"
}

variable "host" {
  type    = string
  default = null
}
