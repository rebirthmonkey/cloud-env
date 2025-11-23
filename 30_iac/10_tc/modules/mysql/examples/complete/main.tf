provider "tencentcloud" {
  region  = var.region
}

resource "tencentcloud_vpc" "main" {
  name       = "test-vpc"
  cidr_block = "10.0.0.0/16"
  tags = {
    "createBy" = "terraform"
  }
}

resource "tencentcloud_subnet" "subnet" {
  availability_zone = "ap-guangzhou-2"
  name              = "test-subnet"
  vpc_id            = tencentcloud_vpc.main.id
  cidr_block        = "10.0.20.0/28"
  is_multicast      = false
  tags = {
    "createBy" = "terraform"
  }
}

module "mysql" {
  source = "../../"

  # MySQL instance 
  instance_name = "simple-mysql"
  mem_size = 10
  volume_size = 50
  root_password = "your_password"
  availability_zone = "ap-guangzhou-2"
  internet_service = 0
  vpc_id = tencentcloud_vpc.main.id
  subnet_id = tencentcloud_subnet.subnet.id

  tags = {
    type = "test"
  }

  # MySQL account
  account = [
    {
      account_name = "test"
      account_password = "1234567"
      account_description = "test account for module"
      account_host = "10.0.0.1"
    }
  ]

  # MySQL backup policy
  backup_model = "physical"
  backup_time = "02:00-06:00"
  retention_period = 7

  # MySQL privilege
  create_mysql_privilege = true
  mysql_privilege = [
    {
      account_name = "test"
      global = ["SELECT"]
      database = [
        {
          database_name = "your_database"
          privileges = ["INSERT", "UPDATE"]
        }
      ]
      table = [
        {
          database_name = "your_database"
          table_name = "your_table"
          privileges = ["UPDATE", "DELETE"]
        }
      ]
      column = [
        {
          database_name = "your_database"
          table_name = "your_table"
          column_name = "test_column"
          privileges = ["DELETE"]
        }
      ]
    }
  ]
}
