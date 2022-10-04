variable "anaml_server_port" {
  type    = number
  default = 8080
}

variable "anaml_docs_port" {
  type    = number
  default = 80
}

variable "anaml_ui_port" {
  type    = number
  default = 80
}

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

variable "kubernetes_ingress_tls_secret_name" {
  type    = string
  default = null
}

variable "kubernetes_ingress_tls_hosts" {
  type    = set(string)
  default = null
}

variable "host" {
  type    = string
  default = null
}

variable "kubernetes_ingress_additional_paths" {
  type = list(
    object({
      path = string,
      backend = object({
        service = object({
          name = string
          port = object({
            number = number
          })
        })
      })
    })
  )
  default = []
}
