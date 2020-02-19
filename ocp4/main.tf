# This terraform can be used to configure Avi for load balancing Openshift 4.2 nodes.

provider "avi" {
avi_controller = "${var.avi_controller}"
avi_username = "${var.avi_username}"
avi_password = "${var.avi_password}"
avi_version = "${var.avi_api_version}"
}

data "avi_tenant" "default_tenant" {
  name = "${var.tenant_name}"
}

data "avi_network" "master_pool_placement_net" {
  name = "${var.master_pool_placement_net}"
}

data "avi_network" "infra_pool_placement_net" {
  name = "${var.infra_pool_placement_net}"
}

data "avi_network" "vs_placement_net" {
  name = "${var.vs_placement_net}"
}

data "avi_cloud" "default_cloud" {
  name = "${var.cloud_name}"
}

data "avi_healthmonitor" "system_tcp" {
  name = "System-TCP"
}

data "avi_applicationprofile" "system_l4" {
  name = "System-L4-Application"
}

data "avi_networkprofile" "system-tcp-proxy" {
  name = "System-TCP-Proxy"
}

resource "avi_pool" "api_server_pool" {
  name                  = "${var.api_server_pool_name}"
  health_monitor_refs   = ["${data.avi_healthmonitor.system_tcp.id}"]
  tenant_ref            = "${data.avi_tenant.default_tenant.id}"
  cloud_ref             = "${data.avi_cloud.default_cloud.id}"
  lb_algorithm          = "LB_ALGORITHM_LEAST_CONNECTIONS"
  lb_algorithm_hash     = "LB_ALGORITHM_CONSISTENT_HASH_SOURCE_IP_ADDRESS"
  default_server_port   = 6443
  use_service_port      = false
  inline_health_monitor = true

  servers {
    ip {
      type = "V4"
      addr = "${var.master_server_1}"
    }
    discovered_networks {
      network_ref = "${data.avi_network.master_pool_placement_net.id}"
    }
  }
  servers {
    ip {
      type = "V4"
      addr = "${var.master_server_2}"
    }
    discovered_networks {
      network_ref = "${data.avi_network.master_pool_placement_net.id}"
    }
  }
  servers {
    ip {
      type = "V4"
      addr = "${var.master_server_3}"
    }
    discovered_networks {
      network_ref = "${data.avi_network.master_pool_placement_net.id}"
    }
  }
  servers {
    ip {
      type = "V4"
      addr = "${var.bootstrap_server}"
    }
    discovered_networks {
      network_ref = "${data.avi_network.master_pool_placement_net.id}"
    }
  }
}

resource "avi_pool" "machineconfig_server_pool" {
  name                  = "${var.machineconfig_server_pool_name}"
  health_monitor_refs   = ["${data.avi_healthmonitor.system_tcp.id}"]
  tenant_ref            = "${data.avi_tenant.default_tenant.id}"
  cloud_ref             = "${data.avi_cloud.default_cloud.id}"
  lb_algorithm          = "LB_ALGORITHM_LEAST_CONNECTIONS"
  lb_algorithm_hash     = "LB_ALGORITHM_CONSISTENT_HASH_SOURCE_IP_ADDRESS"
  default_server_port   = 22623
  use_service_port      = false
  inline_health_monitor = true

  servers {
    ip {
      type = "V4"
      addr = "${var.master_server_1}"
    }
    discovered_networks {
      network_ref = "${data.avi_network.master_pool_placement_net.id}"
    }
  }
  servers {
    ip {
      type = "V4"
      addr = "${var.master_server_2}"
    }
    discovered_networks {
      network_ref = "${data.avi_network.master_pool_placement_net.id}"
    }
  }
  servers {
    ip {
      type = "V4"
      addr = "${var.master_server_3}"
    }
    discovered_networks {
      network_ref = "${data.avi_network.master_pool_placement_net.id}"
    }
  }
  servers {
    ip {
      type = "V4"
      addr = "${var.bootstrap_server}"
    }
    discovered_networks {
      network_ref = "${data.avi_network.master_pool_placement_net.id}"
    }
  }
}

resource "avi_pool" "http_server_pool" {
  name                  = "${var.http_server_pool_name}"
  tenant_ref            = "${data.avi_tenant.default_tenant.id}"
  cloud_ref             = "${data.avi_cloud.default_cloud.id}"
  lb_algorithm          = "LB_ALGORITHM_LEAST_CONNECTIONS"
  lb_algorithm_hash     = "LB_ALGORITHM_CONSISTENT_HASH_SOURCE_IP_ADDRESS"
  default_server_port   = 80
  use_service_port      = false
  inline_health_monitor = true

  servers {
    ip {
      type = "V4"
      addr = "${var.infra_server_1}"
    }
    discovered_networks {
      network_ref = "${data.avi_network.infra_pool_placement_net.id}"
    }
  }
  servers {
    ip {
      type = "V4"
      addr = "${var.infra_server_2}"
    }
    discovered_networks {
      network_ref = "${data.avi_network.infra_pool_placement_net.id}"
    }
  }
  servers {
    ip {
      type = "V4"
      addr = "${var.infra_server_3}"
    }
    discovered_networks {
      network_ref = "${data.avi_network.infra_pool_placement_net.id}"
    }
  }
}

resource "avi_pool" "https_server_pool" {
  name                  = "${var.https_server_pool_name}"
  tenant_ref            = "${data.avi_tenant.default_tenant.id}"
  cloud_ref             = "${data.avi_cloud.default_cloud.id}"
  lb_algorithm          = "LB_ALGORITHM_LEAST_CONNECTIONS"
  lb_algorithm_hash     = "LB_ALGORITHM_CONSISTENT_HASH_SOURCE_IP_ADDRESS"
  default_server_port   = 443
  use_service_port      = false
  inline_health_monitor = true

  servers {
    ip {
      type = "V4"
      addr = "${var.infra_server_1}"
    }
    discovered_networks {
      network_ref = "${data.avi_network.infra_pool_placement_net.id}"
    }
  }
  servers {
    ip {
      type = "V4"
      addr = "${var.infra_server_2}"
    }
    discovered_networks {
      network_ref = "${data.avi_network.infra_pool_placement_net.id}"
    }
  }
  servers {
    ip {
      type = "V4"
      addr = "${var.infra_server_3}"
    }
    discovered_networks {
      network_ref = "${data.avi_network.infra_pool_placement_net.id}"
    }
  }
}

resource "avi_vsvip" "k8s_api_vsvip" {
   name = "k8s-api-vsvipL4"
   cloud_ref = "${data.avi_cloud.default_cloud.id}"
   vip {
      ip_address {
         addr = "${var.vip_api_server}"
         type = "V4"
      }
      placement_networks {
        subnet {
            ip_addr {
               addr = "${var.vs_subnet_ip}"
               type = "V4"
            }
         mask = "${var.vs_subnet_prefix}"
         }
         network_ref = "${data.avi_network.vs_placement_net.id}"
      }
   }
}

resource "avi_vsvip" "k8s_infra_vsvip" {
   name = "k8s-infra-vsvipL4"
   cloud_ref = "${data.avi_cloud.default_cloud.id}"
   vip {
      ip_address {
         addr = "${var.vip_infra_server}"
         type = "V4"
      }
      placement_networks {
        subnet {
            ip_addr {
               addr = "${var.vs_subnet_ip}"
               type = "V4"
            }
         mask = "${var.vs_subnet_prefix}"
         }
         network_ref = "${data.avi_network.vs_placement_net.id}"
      }
   }
}

resource "avi_virtualservice" "api_server" {
   name                     = "${var.vs_api_server}"
   cloud_type               = "CLOUD_VCENTER"
   tenant_ref               = "${data.avi_tenant.default_tenant.id}"
   application_profile_ref  = "${data.avi_applicationprofile.system_l4.id}"
   pool_ref                 = "${avi_pool.api_server_pool.id}"
   network_profile_ref      = "${data.avi_networkprofile.system-tcp-proxy.id}"
   cloud_ref                = "${data.avi_cloud.default_cloud.id}"
   vsvip_ref                = "${avi_vsvip.k8s_api_vsvip.id}"
   services {
      port = 6443
   }
}

resource "avi_virtualservice" "machineconfig_server" {
   name                     = "${var.vs_machineconfig}"
   cloud_type               = "CLOUD_VCENTER"
   tenant_ref               = "${data.avi_tenant.default_tenant.id}"
   application_profile_ref  = "${data.avi_applicationprofile.system_l4.id}"
   pool_ref                 = "${avi_pool.machineconfig_server_pool.id}"
   network_profile_ref      = "${data.avi_networkprofile.system-tcp-proxy.id}"
   cloud_ref                = "${data.avi_cloud.default_cloud.id}"
   vsvip_ref                = "${avi_vsvip.k8s_api_vsvip.id}"
   services {
      port = 22623
   }
}

resource "avi_virtualservice" "http_server" {
   name                     = "${var.vs_http_server}"
   cloud_type               = "CLOUD_VCENTER"
   tenant_ref               = "${data.avi_tenant.default_tenant.id}"
   application_profile_ref  = "${data.avi_applicationprofile.system_l4.id}"
   pool_ref                 = "${avi_pool.http_server_pool.id}"
   network_profile_ref      = "${data.avi_networkprofile.system-tcp-proxy.id}"
   cloud_ref                = "${data.avi_cloud.default_cloud.id}"
   vsvip_ref                = "${avi_vsvip.k8s_infra_vsvip.id}"
   services {
      port = 80
   }
}

resource "avi_virtualservice" "https_server" {
   name                     = "${var.vs_https_server}"
   cloud_type               = "CLOUD_VCENTER"
   tenant_ref               = "${data.avi_tenant.default_tenant.id}"
   application_profile_ref  = "${data.avi_applicationprofile.system_l4.id}"
   pool_ref                 = "${avi_pool.https_server_pool.id}"
   network_profile_ref      = "${data.avi_networkprofile.system-tcp-proxy.id}"
   cloud_ref                = "${data.avi_cloud.default_cloud.id}"
   vsvip_ref                = "${avi_vsvip.k8s_infra_vsvip.id}"
   services {
      port = 443
   }
}
