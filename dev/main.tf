module "network" {
  source          = "../modules/network"
  vpc_cidr        = "10.0.0.0/16"
  public_subnets  = ["10.0.1.0/24","10.0.2.0/24"]
  private_subnets = ["10.0.11.0/24","10.0.12.0/24"]
  common_tags     = {
    Environment = "dev"
    Project     = "my-project"
    Owner       = "team-name"
  }

  region = "eu-west-1" # Europe ( Ireland )
}

module "security" {
  source      = "../modules/security"
  vpc_id      = module.network.vpc_id
  common_tags = {
    Environment = "dev"
    Project     = "my-project"
    Owner       = "team-name"
  }
  allow_ssh_from = "37.228.236.28/32"
}

module "compute" {
  source            = "../modules/compute"
  region            = "eu-west-1"
  vpc_id            = module.network.vpc_id
  subnet_ids        = module.network.private_subnet_ids
  security_group_ids = [module.security.ec2_sg_id]
  key_name          = "devops-tf-key"
  instance_type     = "t3.micro"
  instance_count    = 1
  common_tags = {
    Environment = "dev"
    Project     = "my-project"
    Owner       = "team-name"
  }
}

module "alb" {
  source              = "../modules/alb"
  region              = "eu-west-1"
  vpc_id              = module.network.vpc_id
  public_subnet_ids   = module.network.public_subnet_ids
  target_instance_ids = module.compute.instance_ids
  alb_name            = "my-app-alb"
  common_tags = {
    Environment = "dev"
    Project     = "my-project"
    Owner       = "team-name"
  }
}

module "rds" {
  source = "../modules/rds"

  db_name  = "mydb"
  username = "admin"
  password = "StrongPassword123!"

  vpc_id     = module.network.vpc_id
  subnet_ids = module.network.private_subnet_ids
}

module "iam" {
  source = "../modules/iam"
  region = "eu-west-1"
  common_tags = {
    Environment = "dev"
    Project     = "my-project"
    Owner       = "team-name"
  }
}

module "cloudwatch" {
  source            = "../modules/cloudwatch"
  region            = "eu-west-1"
  ec2_instance_ids  = module.compute.instance_ids
  alb_arn           = module.alb.alb_arn
  rds_instance_ids  = [module.rds.rds_instance_id]  # make sure your RDS module output is `rds_instance_id`
  common_tags = {
    Environment = "dev"
    Project     = "my-project"
    Owner       = "team-name"
  }
}

module "my_lambda" {
  source      = "../modules/lambda"
  lambda_name = "my-function"
  handler     = "index.handler"
  runtime     = "nodejs18.x"
  role_arn    = module.iam.lambda_role_arn
  s3_bucket   = "myproject-lambda-code-eu-west-1"
  s3_key      = "lambda.zip"
  common_tags = {
    Environment = "dev"
    Project     = "my-project"
    Owner       = "team-name"
  }
}

module "lambda_code_bucket" {
  source      = "../modules/s3"
  bucket_name = "myproject-lambda-code-eu-west-1"  # ✅ unique
  region      = "eu-west-1"
  common_tags = {
    Environment = "dev"
    Project     = "my-project"
    Owner       = "team-name"
  }
}