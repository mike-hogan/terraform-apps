
#launch config
resource "aws_launch_configuration" "launch-config" {
  name = "${var.environment_name}-${var.application_name}"
  image_id = "${var.ami}"
  instance_type = "${var.instance_type}"
  iam_instance_profile = "${var.iam_instance_profile}"
  key_name = "${var.key_name}"
  security_groups = ["${aws_security_group.instance_sg.id}"]
  user_data = "${file("${var.user-data-path}")}"
}

resource "aws_security_group" "elb_sg" {
  name = "elb_sg"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "instance_sg" {
  name = "instance_sg"
  vpc_id = "${var.vpc_id}"

  ingress {
    security_groups = ["${aws_security_group.elb_sg.id}"]
    from_port = "${var.instance_port}"
    to_port = "${var.instance_port}"
    protocol = "tcp"
  }

  # outbound internet access
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# Create a new load balancer
resource "aws_elb" "elb" {
  name = "${var.environment_name}-${var.application_name}"
  security_groups = ["${aws_security_group.elb_sg.id}"]
  subnets = ["${split(",", var.subnet_ids)}"]


  listener {
    instance_port = "${var.instance_port}"
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "${var.health_check_url}"
    interval = 30
  }

}


#autoscaling group
resource "aws_autoscaling_group" "scaling-group" {
  availability_zones = ["${split(",", var.availability_zones)}"]
  vpc_zone_identifier = ["${split(",", var.private_subnet_ids)}"]
  name = "${var.environment_name}-${var.application_name}"
  load_balancers = ["${aws_elb.elb.name}"]
  min_size = "${var.min_size}"
  max_size = "${var.max_size}"
  desired_capacity = "${var.desired_size}"
  health_check_type = "ELB"
  launch_configuration = "${aws_launch_configuration.launch-config.name}"
  health_check_grace_period = "20"
}

#elb

#dns
