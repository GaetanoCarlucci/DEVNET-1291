provider "intersight" {
  apikey    = var.apikey
  secretkey = var.secretkey
  endpoint  = var.endpoint
}

module "terraform-intersight-iks" {

  source  = "terraform-cisco-modules/iks/intersight//"
  version = "2.1.2"

# Kubernetes Cluster Profile  Adjust the values as needed.
  cluster = {
    name                = "iksterraformk8scluster"
    action              = "Unassigned"
    wait_for_completion = true
    worker_nodes        = 1
    load_balancers      = 1
    worker_max          = 2
    control_nodes       = 1
    ssh_user            = var.ssh_user
    ssh_public_key      = var.ssh_key
  }


# IP Pool Information (To create new change "use_existing" to 'false' uncomment variables and modify them to meet your needs.)
  ip_pool = {
    use_existing        = false
    name                = "iksterraformpool"
    ip_starting_address = "10.58.21.142"
    ip_pool_size        = "8"
    ip_netmask          = "255.255.255.0"
    ip_gateway          = "10.58.21.254"
    dns_servers         = ["173.37.87.157",""]
  }

# Sysconfig Policy (UI Reference NODE OS Configuration) (To create new change "use_existing" to 'false' uncomment variables and modify them to meet your needs.)
  sysconfig = {
    use_existing = true
    name         = "iksuinodeos"
    # domain_name  = "rich.ciscolabs.com"
    # timezone     = "America/New_York"
    # ntp_servers  = ["10.101.128.15"]
    # dns_servers  = ["10.101.128.15"]
  }

# Kubernetes Network CIDR (To create new change "use_existing" to 'false' uncomment variables and modify them to meet your needs.)
  k8s_network = {
    use_existing = true
    name         = "iksuipoolnw"

    ######### Below are the default settings.  Change if needed. #########
    # pod_cidr     = "100.65.0.0/16"
    # service_cidr = "100.64.0.0/24"
    # cni          = "Calico"
  }

# Version policy (To create new change "useExisting" to 'false' uncomment variables and modify them to meet your needs.)
  versionPolicy = {
    useExisting = true
    policyName     = "iksuik8sver"
    iksVersionName = "1.19.15-iks.3"
  }

# Trusted Registry Policy (To create new change "use_existing" to 'false' and set "create_new' to 'true' uncomment variables and modify them to meet your needs.)
# Set both variables to 'false' if this policy is not needed.
  tr_policy = {
    use_existing = false
    create_new   = false
    name         = "trusted-registry"
  }

# Runtime Policy (To create new change "use_existing" to 'false' and set "create_new' to 'true' uncomment variables and modify them to meet your needs.)
# Set both variables to 'false' if this policy is not needed.
  runtime_policy = {
    use_existing = true
    create_new   = false
    name                 = "iksuicontainer"
    # http_proxy_hostname  = "t"
    # http_proxy_port      = 80
    # http_proxy_protocol  = "http"
    # http_proxy_username  = null
    # http_proxy_password  = null
    # https_proxy_hostname = "t"
    # https_proxy_port     = 8080
    # https_proxy_protocol = "https"
    # https_proxy_username = null
    # https_proxy_password = null
  }

# Infrastructure Configuration Policy (To create new change "use_existing" to 'false' and uncomment variables and modify them to meet your needs.)
  infraConfigPolicy = {
    use_existing = true
    # platformType = "iwe"
    # targetName   = "falcon"
    policyName   = "iksuiinfra2"
    # description  = "Test Policy"
    # interfaces   = ["iwe-guests"]
    # vcTargetName   = optional(string)
    # vcClusterName      = optional(string)
    # vcDatastoreName     = optional(string)
    # vcResourcePoolName = optional(string)
    # vcPassword      = optional(string)
  }

# Addon Profile and Policies (To create new change "createNew" to 'true' and uncomment variables and modify them to meet your needs.)
# This is an Optional item.  Comment or remove to not use.  Multiple addons can be configured.
  addons       = [
    {
    use_existing = true
    createNew = false
    #addonPolicyName = "iksuiaddon"
    addonName            = "iksuiaddon"
    #description       = "SMM Policy"
    #upgradeStrategy  = "AlwaysReinstall"
    #installStrategy  = "InstallOnly"
    #releaseVersion = "1.7.4-cisco4-helm3"
    #overrides = yamlencode({"demoApplication":{"enabled":true}})
    }
    # {
    # createNew = true
    # addonName            = "ccp-monitor"
    # description       = "monitor Policy"
    # # upgradeStrategy  = "AlwaysReinstall"
    # # installStrategy  = "InstallOnly"
    # releaseVersion = "0.2.61-helm3"
    # # overrides = yamlencode({"demoApplication":{"enabled":true}})
    # }
  ]

# Worker Node Instance Type (To create new change "use_existing" to 'false' and uncomment variables and modify them to meet your needs.)
  instance_type = {
    use_existing = true
    name         = "iksuiinst"
    # cpu          = 4
    # memory       = 16386
    # disk_size    = 40
  }

# Organization and Tag Information
  organization = var.organization
  tags         = var.tags
}
 
#Wait for cluster to come up and then outpt the kubeconfig, if successful
output "kube_config" {
	value = module.terraform-intersight-iks.module.cluster_profile.intersight_kubernetes_cluster_profile.kubeprofaction.kube_config[0].kube_config
}
