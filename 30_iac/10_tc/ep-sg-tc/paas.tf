module "tke" {
  source = "../modules/tke"

  create_cam_strategy = false
  create_cluster = true

  # cluster
  cluster_name              = "${local.name}_tke"
  cluster_version           = "1.30.0"
  cluster_level             = "L5"
  container_runtime         = "containerd"
  network_type              = "VPC-CNI" // Cluster network type, GR or VPC-CNI. Default is GR
  vpc_id                    = module.network.vpc_id
  node_security_group_id    = local.default_sg_id
  eni_subnet_ids            = module.pod_network.subnet_id
  cluster_service_cidr      = "192.168.128.0/17"
  cluster_max_service_num   = 32768 # this number must equal to the ip number of cluster_service_cidr
  cluster_max_pod_num       = 64
  cluster_cidr              = ""
  deletion_protection       = false

  cluster_os = "tlinux2.2(tkernel3)x86_64"
  claim_expired_seconds = 300

  # workers
  create_workers_with_cluster = false
  self_managed_node_groups = {
    node_group_1 = {
      name                     = "${local.name}_tke-node-pool_00"
      deletion_protection = false
      max_size                 = 5
      min_size                 = 1
      subnet_ids               = module.node_network.subnet_id
      retry_policy             = "IMMEDIATE_RETRY"
      desired_capacity         = 3
      enable_auto_scale        = true
      multi_zone_subnet_policy = "EQUALITY"
      node_os                  = "ubuntu20.04x86_64"

      docker_graph_path = "/var/lib/docker"
      data_disk = [
        {
          disk_type = "CLOUD_SSD"
          disk_size = 100 # at least to configurate a disk size for data disk
          delete_with_instance = true
          auto_format_and_mount = true
          file_system = "ext4"
          mount_target = "/var/lib/docker"
        }
      ]

      auto_scaling_config = [
        {
          instance_type              = "S5.LARGE8"
          system_disk_type           = "CLOUD_SSD"
          system_disk_size           = 50
          orderly_security_group_ids = [module.security_group.ids["${local.name}_${local.sg_name}"]]
          key_ids                    = null

          internet_charge_type       = null
          internet_max_bandwidth_out = null
          public_ip_assigned         = false
          enhanced_security_service  = true
          enhanced_monitor_service   = true
          host_name                  = "tke-node"
          host_name_style            = "ORIGINAL"
        }
      ]

      labels      = {}
      taints      = []
      node_config = [
        {
          extra_args = concat(["root-dir=/var/lib/kubelet"],
            []
          )
        }
      ]
    }
  }

  # endpoints
  create_endpoint_with_cluster     = false
  cluster_public_access             = false
  cluster_security_group_id = module.security_group.ids["${local.name}_${local.sg_name}"]
  cluster_private_access                = true
  cluster_private_access_subnet_id      = module.node_network.subnet_id[0]

  # logs
  enable_event_persistence = false
  enable_cluster_audit_log = false
  enable_log_agent = false

  # tags
  tags = local.tags

  # pod identity
  enable_pod_identity = true
}

resource "local_file" "kubeconfig" {
  content  = module.tke.intranet_kube_config
  filename = "./.kube/${module.tke.cluster_id}-config"
}
