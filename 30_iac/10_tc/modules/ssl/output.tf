output "ssl_id" {
  value       = tencentcloud_ssl_free_certificate.ssl.*.id
  description = "ssl id"
}

output "certificate_public_key" {
  value       = tencentcloud_ssl_free_certificate.ssl.certificate_public_key
  description = "The public certificate content (PEM)"
}

output "certificate_private_key" {
  value       = tencentcloud_ssl_free_certificate.ssl.certificate_private_key
  description = "The private key (PEM)"
  sensitive   = true
}

