resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    
    tags {
        Name = "infra-vpc"
    }
}

resource "aws_internet_gateway" "gw" {
    vpc_id = "${aws_vpc.main.id}"

    tags {
        Name = "infra-igw"
    }
}

resource "aws_eip" "nat-ip" {
    vpc      = true
}

resource "aws_nat_gateway" "nat-gw" {
    allocation_id = "${aws_eip.nat-ip.id}"
    subnet_id = "${aws_subnet.infra-public.id}"

    depends_on = ["aws_internet_gateway.gw"]
}

resource "aws_route_table" "routes" {
    vpc_id = "${aws_vpc.main.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.gw.id}"
    }

    tags {
        Name = "infra-route-table"
    }
}

resource "aws_route_table" "private-to-nat" {
    vpc_id = "${aws_vpc.main.id}"
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.nat-gw.id}"
    }
}

resource "aws_route_table_association" "rt_association" {
    subnet_id = "${aws_subnet.infra-public.id}"
    route_table_id = "${aws_route_table.routes.id}"
}

resource "aws_route_table_association" "private-subnet-rt" {
    subnet_id = "${aws_subnet.infra-private.id}"
    route_table_id = "${aws_route_table.private-to-nat.id}"
}

resource "aws_subnet" "infra-public" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"

    tags {
        Name = "infra-public"
    }
}

resource "aws_subnet" "infra-private" {
    vpc_id = "${aws_vpc.main.id}"
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1a"

    tags {
        Name = "infra-private"
    }
}
