resource "tencentcloud_ssl_free_certificate" "ssl" {
  dv_auth_method    = "DNS_AUTO"
  domain            = var.domain
  package_type      = "83"
  contact_email     = var.contact_email
  contact_phone     = var.contact_phone
  validity_period   = 3
  csr_encrypt_algo  = "RSA"
  csr_key_parameter = "2048"
  csr_key_password  = "csr_pwd"
  alias             = var.alias

  lifecycle {
    ignore_changes = [
    dv_auth_method,
    contact_email,
    contact_phone,
    csr_encrypt_algo,
    csr_key_parameter,
    csr_key_password,
    alias
     ]
  }
}
