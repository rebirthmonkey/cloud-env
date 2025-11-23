output "gitlab_tls_crt" {
  value     = module.ssl_gitlab_main.certificate_public_key
  sensitive = true
}

output "gitlab_tls_key" {
  value     = module.ssl_gitlab_main.certificate_private_key
  sensitive = true
}

output "gitlab_registry_tls_crt" {
  value     = module.ssl_gitlab_registry.certificate_public_key
  sensitive = true
}

output "gitlab_registry_tls_key" {
  value     = module.ssl_gitlab_registry.certificate_private_key
  sensitive = true
}

