provider "aws" {
  region  = var.region
  profile = var.aws_profile
}

module "network" {
  source               = "../../modules/aws/network"
  project_name         = var.project_name
  region               = var.region
  availability_zone    = var.availability_zone
  bastion_host_ami     = length(var.bastion_host_ami) > 0 ? var.bastion_host_ami : null
  ssh_bastion_user     = var.ssh_bastion_user
  ssh_public_key_path  = var.ssh_public_key_path
  ssh_private_key_path = var.ssh_private_key_path
}

module "test_environment" {
  source                           = "../../modules/generic/test_environment"
  upstream_cluster                 = var.upstream_cluster
  downstream_cluster_templates     = var.downstream_cluster_templates
  downstream_cluster_distro_module = var.downstream_cluster_distro_module
  tester_cluster                   = var.tester_cluster
  backend                          = "aws"
  ssh_user                         = var.ssh_user
  ssh_private_key_path             = var.ssh_private_key_path
  network_backend_variables        = module.network.backend_variables
}
