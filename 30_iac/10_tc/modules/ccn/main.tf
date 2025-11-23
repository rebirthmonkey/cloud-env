locals {
  create_ccn         = var.create_ccn
  attach_ccn         = var.attach_ccn
  set_bandwith_limit = var.set_bandwith_limit
}


################################################################################
# CCN
################################################################################
resource "tencentcloud_ccn" "ccn" {
  count                = local.create_ccn ? 1 : 0
  name                 = var.ccn_name
  bandwidth_limit_type = var.bandwidth_limit_type
  charge_type          = var.charge_type
  description          = var.ccn_description != "" ? var.ccn_description : null
  qos                  = var.qos
  tags                 = var.ccn_tags
  route_overlap_flag   = var.route_overlap_flag
}


################################################################################
# CCN Attachment
################################################################################
resource "tencentcloud_ccn_attachment" "attachment" {
  count           = local.attach_ccn ? 1 : 0
  ccn_id          = var.ccn_id != "" ? var.ccn_id : tencentcloud_ccn.ccn[0].id
  instance_type   = var.instance_type
  instance_id     = var.instance_id != "" ? var.instance_id : null
  instance_region = var.instance_region != "" ? var.instance_region : null
  ccn_uin         = var.ccn_uin != "" ? var.ccn_uin : null
  description     = try(var.attachment_description, null)
}


################################################################################
# CCN Bandwidth Limit
################################################################################
resource "tencentcloud_ccn_bandwidth_limit" "limit" {
  count           = local.set_bandwith_limit ? 1 : 0
  ccn_id          = var.ccn_id != "" ? var.ccn_id : tencentcloud_ccn.ccn[0].id
  region          = try(var.src_region, null)
  dst_region      = try(var.dst_region, null)
  bandwidth_limit = try(var.bandwidth_limit, null)
}


################################################################################
# CCN Routes Config
################################################################################
# locals {
#   route_ids = [for route_id in tencentcloud_ccn_attachment.attachment[0].route_ids : route_id]
# }

# resource "tencentcloud_ccn_routes" "config" {
#   for_each = local.config_route ? local.route_ids : []
#   ccn_id   = var.ccn_id != "" ? var.ccn_id : tencentcloud_ccn.ccn[0].id
#   route_id = var.route_id != "" && !var.attach_ccn ? var.route_id : each.value
#   switch   = var.switch
# }
