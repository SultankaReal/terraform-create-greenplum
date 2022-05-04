#Create greenplum cluster
#Link to terraform documentation - https://registry.tfpla.net/providers/yandex-cloud/yandex/latest/docs/resources/mdb_greenplum_cluster

resource "yandex_mdb_greenplum_cluster" "foo" {
  name               = "test"
  description        = "test greenplum cluster"
  environment        = "PRODUCTION" //PRESTABLE or PRODUCTION
  network_id         = var.default_network_id
  zone               = "ru-central1-b"
  subnet_id          = var.default_subnet_id_zone_b
  assign_public_ip   = true //Sets whether the master hosts should get a public IP address on creation. Changing this parameter for an existing host is not supported at the moment.
  version            = "6.19" //version of the cluster
  master_host_count  = 2 //Number of hosts in master subcluster (1 or 2)
  segment_host_count = 5 //Number of hosts in segment subcluster (from 1 to 32)
  segment_in_host    = 1 //Number of segments on segment host (not more then 1 + RAM/8)
  master_subcluster {
    resources {
      resource_preset_id = "s2.micro"
      disk_size          = 24
      disk_type_id       = "network-ssd"
    }
  }
  segment_subcluster {
    resources {
      resource_preset_id = "s2.micro"
      disk_size          = 24
      disk_type_id       = "network-ssd"
    }
  }

  access {
    web_sql = true //Allows access for SQL queries in the management console
    data_lens = true //Allow access for Yandex DataLens
  }

  user_name     = "admin_user"
  user_password = "your_super_secret_password"
}
