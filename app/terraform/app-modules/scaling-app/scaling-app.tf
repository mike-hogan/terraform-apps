variable "availability_zones" {  }
variable "subnet_ids" {  }
variable "private_subnet_ids" {  }
variable "vpc_id" {  }
variable "environment_name" {  }

resource "aws_iam_role" "instance_role" {
  name = "instance_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "instance_policy" {
  name = "instance_policy"
  role = "${aws_iam_role.instance_role.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

module "scaling-app" {
  source = "../../../../infra/modules/scaling-app"
  key_name = "mike-jobsite-dev"
  application_name = "sample-app"
  ami = "ami-f5f41398"
  iam_instance_profile = "bastion"
  user-data-path = "${path.module}/user_data/boot-app.sh"
  instance_port = "3000"
  health_check_url = "HTTP:3000/"
  instance_type = "t2.small"
  desired_size = "1"

  availability_zones = "${var.availability_zones}"
  subnet_ids = "${var.subnet_ids}"
  private_subnet_ids = "${var.private_subnet_ids}"
  vpc_id = "${var.vpc_id}"
  environment_name = "${var.environment_name}"

}
