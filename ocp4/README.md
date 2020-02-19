# Automate AVI LB Service in vSphere using Terraform

## 1. Prerequisite
  This post is a continuation of the previous post [on how to use NSX Advance LB (AVI Networks) for Openshift control-plane nodes](https://alvianus.net/posts/2020/02/using-nsx-advance-load-balancer-as-control-plane-nodes-load-balancer-in-openshift-4.2/). In this note, I'm going to create Terraform manifest for automating the creation of load balancer objects in AVI. The manifests can be altered or modified if necessary for another purpose.  The objective is to create a framework for automating the creation of load balancer objects.

  This is created with below software version:
  - Terraform v0.11.12  
  - AVI v18.2.7  

Below are the prerequisite:

**Download Terraform**
Install unzip
```bash
sudo apt-get install wget unzip
```
Download respective version and extract the archive
```bash
export VER="0.11.12"
wget https://releases.hashicorp.com/terraform/${VER}/terraform_${VER}_linux_amd64.zip
unzip terraform_${VER}_linux_amd64.zip
```
Move file fo /usr/local/bin directory
```bash
sudo mv terraform /usr/local/bin/
```

## 2. AVI LB Service
  In this post, I'm going to automate the creation of LB service objects for Openshift Master nodes load balancing:
  - Create a local load balancing service and pool for API Server (TCP 6443)
  - Create a local load balancing service and pool for Machineconfig (TCP 22623)
  - Create a local load balancing service and pool for HTTP (TCP 80)
  - Create a local load balancing service and pool for HTTPS (TCP 443)

  The complete Terraform manifests can be found [in my Github page](https://github.com/ralvianus/nsx-alb-terraform/tree/master/ocp4)

## 3. How to use
  - **Edit the Variable files as necessary**
    My lab variables are below:
    ```
    # AVI Controller Variables
    avi_controller        = "192.168.110.71"
    avi_username          = "<username>"
    avi_password          = "<password>"
    avi_api_version       = "18.2.7"

    # Cloud Variables
    cloud_name            = "Default-Cloud"
    tenant_name           = "admin"

    # General Virtual Service Variables
    vs_subnet_ip          = "192.168.110.0"
    vs_subnet_prefix      = "24"
    vs_placement_net      = "LabNet"

    # API Server VS Variables
    vs_api_server         = "Openshift-API-Server"
    vip_api_server        = "192.168.110.88"
    api_server_pool_name  = "openshift-api-server-pool"
    master_pool_placement_net    = "LabNet"
    bootstrap_server      = "10.11.1.11"
    master_server_1       = "10.11.1.12"
    master_server_2       = "10.11.1.13"
    master_server_3       = "10.11.1.14"

    # Machine Config VS Variables
    vs_machineconfig         = "Openshift-MachineConfig"
    machineconfig_server_pool_name = "openshift-machineconfig-pool"

    # Infra Nodes HTTP VS Variables
    vs_http_server        = "Openshift-Apps-HTTP"
    vip_infra_server      = "192.168.110.89"
    infra_nodes_pool_name = "openshift-apps-server-pool"
    infra_pool_placement_net = "LabNet"
    infra_server_1        = "10.11.1.15"
    infra_server_2        = "10.11.1.16"
    infra_server_3        = "10.11.1.17"
    http_server_pool_name = "openshift-apps-http-pool"

    # Infra Nodes HTTPS VS Variables
    vs_https_server          = "Openshift-Apps-HTTPS"
    https_server_pool_name  = "openshift-apps-https-pool"
    ```

- **Run Terraform to initialize and provision the environment**
    ```bash
    terraform init
    ```
    ```bash
    terraform plan
    ```
    ```bash
    terraform apply -auto-approve
    ```
    ```
    data.avi_healthmonitor.system_tcp: Refreshing state...
    data.avi_network.master_pool_placement_net: Refreshing state...
    data.avi_tenant.default_tenant: Refreshing state...
    data.avi_network.vs_placement_net: Refreshing state...
    data.avi_applicationprofile.system_l4: Refreshing state...
    data.avi_cloud.default_cloud: Refreshing state...
    data.avi_network.infra_pool_placement_net: Refreshing state...
    data.avi_networkprofile.system-tcp-proxy: Refreshing state...
    avi_vsvip.k8s_api_vsvip: Creating...
      cloud_ref:                                                           "" => "https://192.168.110.71/api/cloud/cloud-e9777ee9-2cca-4fad-a1f4-d0b6623cbf29"
      east_west_placement:                                                 "" => "false"
    <output ommited>
    avi_virtualservice.https_server: Creation complete after 3s (ID: https://192.168.110.71/api/virtualservi...e-48896650-630e-4a8a-b287-e220a822267a)
    avi_virtualservice.machineconfig_server: Creation complete after 3s (ID: https://192.168.110.71/api/virtualservi...e-c215d88f-1cb2-4771-8664-bd4d2da69694)
    avi_virtualservice.api_server: Creation complete after 4s (ID: https://192.168.110.71/api/virtualservi...e-981fe4d9-cdd2-4e51-8f7e-7b4937e22993)
    avi_virtualservice.http_server: Creation complete after 4s (ID: https://192.168.110.71/api/virtualservi...e-9817e0e0-8b94-48bf-9db3-073d0f170670)

    Apply complete! Resources: 10 added, 0 changed, 0 destroyed.
    ```

- **Verification**
  ![](https://i.imgur.com/i8ElkMc.png)
