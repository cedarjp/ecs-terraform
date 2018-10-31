variable "name" {}
variable "domain_name" {}
variable "region" {}
variable "image_id" {}
variable "instance_type" {}
variable "public_key" {}

# github
variable "github_owner" {}
variable "github_branch" {}
variable "github_repository" {}

# codepipeline
variable "codepipeline_s3_bucket_name" {}

# codebuild
variable "codebuild_s3_bucket_name" {}

# task_defintion
variable "task_uwsgi_memory" {}
variable "task_nginx_memory" {}
variable "task_django_setting_module" {}

# vpc
variable "vpc_cidr_block" {}
variable "vpc_dns_hostnames" {}
variable "vpc_dns_support" {}
variable "vpc_instance_tenancy" {}

# subnet
variable "subnet_cidrs" {
  type = "list"
}

variable "subnet_zones" {
  type = "list"
}

# route_table
variable "rt_cidr_blok" {}

# alb
variable "alb_idle_timeout" {}

variable "alb_internal" {}
variable "alb_deletion_protection" {}
variable "alb_log_s3_bucket_name" {}

# rds
variable "db_instance_type" {}

variable "db_username" {}
variable "db_name" {}
variable "db_engine" {}
variable "db_engine_version" {}
variable "db_family" {}
variable "db_allocated_storage" {}
variable "db_storage_type" {}
variable "db_port" {}
variable "db_multi_az" {}
variable "db_backup_retention" {}
variable "db_monitoring_interval" {}

# launch_configuration
variable "lc_public_ip" {}

variable "lc_enable_monitoring" {}
variable "lc_ebs_optimized" {}
variable "lc_device_name" {}
variable "lc_volume_type" {}
variable "lc_volume_size" {}
variable "lc_delete_on_termination" {}
variable "lc_create_before_destroy" {}

# acm_certificate
variable "acm_validation_method" {}

# autoscaling_group
variable "asg_max_size" {}

variable "asg_min_size" {}
variable "asg_desired_capacity" {}
variable "asg_health_check_grace_period" {}
variable "asg_health_check_type" {}
variable "asg_create_before_destroy" {}

# codebuild
variable "cb_build_timeout" {}
