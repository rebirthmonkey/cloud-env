terraform {
  required_version = ">= 0.12"

  required_providers {
    tencentcloud = {
      source  = "tencentcloudstack/tencentcloud"
      version = "=1.82.2"
    }
  }

  backend "local" {
    path = "terraform.tfstate"
  }

  # backend "cos" {
  #   region = "ap-singapore"
  #   bucket = "overseasops-tfstate-1308273016"
  #   key    = "ep-sg/terraform.tfstate"
  # }
}

provider "tencentcloud" {
  region = "ap-guangzhou"
}

# provider "tencentcloud" {
#   region = "ap-singapore"
# }
