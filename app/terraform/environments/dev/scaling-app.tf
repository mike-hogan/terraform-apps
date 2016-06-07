# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

module "scaling-app" {
  source = "../../app-modules/scaling-app"
  environment_name = "mike-dev"

  #should get these values from remote_state
  availability_zones = "us-east-1a"
  subnet_ids = "subnet-9f2211e9"
  private_subnet_ids = "subnet-922615e4"
  vpc_id = "vpc-0dc51e6a"
}
