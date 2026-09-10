module "vpc" {
  source                = "../../modules/vpc"
  environment           = var.environment
  vpc_cidr              = "10.1.0.0/16"
  public_subnet_cidr    = "10.1.1.0/24"
  private_subnet_cidr_1 = "10.1.2.0/24"
  private_subnet_cidr_2 = "10.1.3.0/24"
}

module "s3" {
  source      = "../../modules/s3"
  bucket_name = "francisco-guardado-${var.environment}-app-files"
  environment = var.environment
}

module "iam" {
  source        = "../../modules/iam"
  environment   = var.environment
  s3_bucket_arn = module.s3.bucket_arn
}

module "ec2" {
  source                = "../../modules/ec2"
  environment           = var.environment
  vpc_id                = module.vpc.vpc_id
  public_subnet_id      = module.vpc.public_subnet_id
  instance_type         = "t2.micro"
  instance_profile_name = module.iam.instance_profile_name
  ssh_allowed_cidr      = ["0.0.0.0/0"]
}

module "rds" {
  source                = "../../modules/rds"
  environment           = var.environment
  vpc_id                = module.vpc.vpc_id
  private_subnet_ids    = module.vpc.private_subnet_ids
  ec2_security_group_id = module.ec2.security_group_id
  db_name               = var.db_name
  db_username           = var.db_username
  db_password           = var.db_password
  instance_class        = "db.t3.micro"
  allocated_storage     = 20
  skip_final_snapshot   = true
}
