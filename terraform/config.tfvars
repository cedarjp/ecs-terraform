name = "ecsapp"
domain_name = "ecsapp.example.com"
region = "ap-northeast-1"
public_key = "ssh-rsa *****"

# ecs instance
instance_type = "t2.micro"
image_id = "ami-f3f8098c"

# github
github_owner = "cedarjp"
github_repository = "ecsapp"
github_branch = "master"
# codepipeline
codepipeline_s3_bucket_name = "ecsapp-codepipeline-bucket"
# codebuild
codebuild_s3_bucket_name = "ecsapp-codebuild-bucket"
cb_build_timeout = 5
# task defintion
task_uwsgi_memory = 128
task_nginx_memory = 128
task_django_setting_module = "ecsapp.settings"
# vpc
vpc_cidr_block = "10.0.0.0/16"
vpc_dns_hostnames = "true"
vpc_dns_support = "true"
vpc_instance_tenancy = "default"
# subnet
subnet_cidrs = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
subnet_zones = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
# route_table
rt_cidr_blok = "0.0.0.0/0"
# alb
alb_idle_timeout = 60
alb_internal = "false"
alb_deletion_protection = "false"
alb_log_s3_bucket_name = "ecsapp-alb-bucket"
# rds
db_instance_type = "db.t2.micro"
db_username = "ecsapp"
db_name = "ecsapp"
db_engine = "mysql"
db_engine_version = "5.7.21"
db_family = "mysql5.7"
db_allocated_storage = 20
db_storage_type = "gp2"
db_port = 3306
db_multi_az = "false"
db_backup_retention = 7
db_monitoring_interval = 60
# launch_configuration
lc_public_ip = "true"
lc_enable_monitoring = "true"
lc_ebs_optimized = "false"
lc_device_name = "/dev/xvdcz"
lc_volume_type = "gp2"
lc_volume_size = 22
lc_delete_on_termination = "true"
lc_create_before_destroy = "true"
# acm
acm_validation_method = "DNS"
# autoscaling_group
asg_max_size = 10
asg_min_size = 1
asg_desired_capacity = 1
asg_health_check_grace_period = 0
asg_health_check_type = "EC2"
asg_create_before_destroy = "true"
