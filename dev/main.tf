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