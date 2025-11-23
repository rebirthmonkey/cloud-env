module "cvm" {
  source = "../modules/cvm"

  vpc_id = module.network.vpc_id
  subnet_id = module.network.subnet_id[0]
  availability_zone = local.availability_zones[0]
  tags = local.tags

  instance_name = "${local.name}_cvm-mo"
  instance_type = local.instance_type

  image_type = local.image_type
  image_name = local.image_name
  os_name = local.os_name

  system_disk_size = local.system_disk_size
  security_group_ids = [local.default_sg_id]
  password = local.instance_password

  allocate_public_ip = true
  internet_max_bandwidth_out = local.internet_max_bandwidth_out

}

output "cvm_tools" {
    value = module.cvm.public_ips
}
