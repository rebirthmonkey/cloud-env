resource "null_resource" "publish_to_ccn" {
  provisioner "local-exec" {
    command = <<EOT
      tccli vpc NotifyRoutes \
        --cli-unfold-argument \
        --region ${var.region} \
        --RouteTableId ${var.route_table_id} \
        --RouteItemIds ${var.route_item_id}
    EOT
  }

  triggers = {
    route_table_id = var.route_table_id
    route_item_id  = var.route_item_id
    region         = var.region
  }
}

