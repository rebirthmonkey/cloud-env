variable "certificates" {
  type = any
  default = {}
}
resource "tencentcloud_ssl_free_certificate" "certificates" {
  for_each = var.certificates
  dv_auth_method    = try(each.value.dv_auth_method, "DNS_AUTO") # "DNS_AUTO"
  domain            = each.value.domain # "example.com"
  package_type      = try(each.value.package_type, 83) # "2"
  contact_email     = try(each.value.contact_email, "test@example.com") # "test@example.com"
  contact_phone     = try(each.value.contact_phone, "13800138000") # "18352458901"
  validity_period   = try(each.value.validity_period, 12) # 12
  csr_encrypt_algo  = try(each.value.csr_encrypt_algo, "RSA") # "RSA"
  csr_key_parameter = try(each.value.csr_key_parameter, "2048") # "2048"
  csr_key_password  = try(each.value.csr_key_password, null) # "csr_pwd"
  alias             = each.value.alias # "example_free_cert"
}

output "ids" {
  value = { for k, c in tencentcloud_ssl_free_certificate.certificates: k => c.id}
}