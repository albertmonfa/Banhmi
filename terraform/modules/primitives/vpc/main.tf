resource "aws_vpc" "main" {
  cidr_block           = "${var.cidr}"
  instance_tenancy     = "${var.instance_tenancy}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_dns_support   = "${var.enable_dns_support}"
  tags                 = "${merge(
                                   var.tags, map("Name", format("%s-vpc", var.name)),
                                   var.tags, map("Z_name", format("%s-vpc", var.name)),
                                   var.tags, map("Z_type", "VPC")
                                 )}"
}

resource "aws_default_network_acl" "default" {
  default_network_acl_id = "${aws_vpc.main.default_network_acl_id}"
  egress {
    protocol   = "all"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  ingress {
    protocol   = "all"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  tags             = "${merge(
                               var.tags, map("Name", format("%s-nacl-%s", var.name, element(var.azs, count.index))),
                               var.tags, map("Z_name", format("%s-nacl-%s", var.name, element(var.azs, count.index))),
                               var.tags, map("Z_type", "NetworkACL")
                             )}"
  count = "${var.enable_nacl_strict ? 0 : 1}"
}

resource "aws_default_network_acl" "default-strict" {
  default_network_acl_id = "${aws_vpc.main.default_network_acl_id}"
  egress {
    protocol   = "all"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  ingress {
    protocol   = "all"
    rule_no    = 100
    action     = "allow"
    cidr_block = "${var.cidr}"
    from_port  = 0
    to_port    = 0
  }
  tags             = "${merge(
                               var.tags, map("Name", format("%s-nacl-%s", var.name, element(var.azs, count.index))),
                               var.tags, map("Z_name", format("%s-nacl-%s", var.name, element(var.azs, count.index))),
                               var.tags, map("Z_type", "NetworkACL")
                             )}"
  count = "${var.enable_nacl_strict ? 1 : 0}"
}

resource "aws_default_security_group" "default" {
  vpc_id = "${aws_vpc.main.id}"
  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags             = "${merge(
                               var.tags, map("Name", format("%s-sgroup-%s", var.name, element(var.azs, count.index))),
                               var.tags, map("Z_name", format("%s-sgroup-%s", var.name, element(var.azs, count.index))),
                               var.tags, map("Z_type", "SecurityGroup")
                             )}"
}

resource "aws_default_route_table" "default" {
  default_route_table_id = "${aws_vpc.main.default_route_table_id}"
  tags             = "${merge(
                               var.tags, map("Name", format("%s-default-rt", var.name)),
                               var.tags, map("Z_name", format("%s-default-rt", var.name)),
                               var.tags, map("Z_type", "RoutingTable")
                             )}"
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"
  tags   = "${merge(
                     var.tags, map("Name", format("%s-igw", var.name)),
                     var.tags, map("Z_name", format("%s-igw", var.name)),
                     var.tags, map("Z_type", "InternetGateway")
                   )}"
}

resource "aws_route_table" "public" {
  vpc_id           = "${aws_vpc.main.id}"
  propagating_vgws = ["${var.public_propagating_vgws}"]
  tags             = "${merge(
                               var.tags, map("Name", format("%s-pub-rt", var.name)),
                               var.tags, map("Z_name", format("%s-pub-rt", var.name)),
                               var.tags, map("Z_type", "RoutingTable")
                             )}"
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.main.id}"
}

resource "aws_route" "private_nat_gateway" {
  route_table_id         = "${element(aws_route_table.private.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.natgw.*.id, count.index)}"
  count                  = "${var.enable_nat_gateway ? length(var.azs) : 0}"
}

resource "aws_route_table" "private" {
  vpc_id           = "${aws_vpc.main.id}"
  propagating_vgws = ["${var.private_propagating_vgws}"]
  count            = "${length(var.azs)}"
  tags             = "${merge(
                                var.tags, map("Name", format("%s-priv-rt-%s", var.name, element(var.azs, count.index))),
                                var.tags, map("Z_name", format("%s-priv-rt-%s", var.name, element(var.azs, count.index))),
                                var.tags, map("Z_type", "RoutingTable")
                             )}"
}

resource "aws_subnet" "private" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.private_subnets[count.index]}"
  availability_zone = "${element(var.azs, count.index)}"
  count             = "${length(var.private_subnets)}"
  tags              = "${merge(
                                var.tags, map("Name", format("%s-priv-subnet-%s", var.name, element(var.azs, count.index))),
                                var.tags, map("Z_name", format("%s-priv-subnet-%s", var.name, element(var.azs, count.index))),
                                var.tags, map("Z_type", "Subnet")
                              )}"
}

resource "aws_subnet" "database" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.database_subnets[count.index]}"
  availability_zone = "${element(var.azs, count.index)}"
  count             = "${length(var.database_subnets)}"
  tags              = "${merge(
                                 var.tags, map("Name", format("%s-db-subnet-%s", var.name, element(var.azs, count.index))),
                                 var.tags, map("Z_name", format("%s-db-subnet-%s", var.name, element(var.azs, count.index))),
                                 var.tags, map("Z_type", "Subnet")
                              )}"
}

resource "aws_db_subnet_group" "database" {
  name        = "${var.name}-rds-subnet-group"
  description = "Database subnet groups for ${var.name}"
  subnet_ids  = ["${aws_subnet.database.*.id}"]
  tags        = "${merge(
                           var.tags, map("Name", format("%s-db-subnet-group", var.name)),
                           var.tags, map("Z_name", format("%s-db-subnet-group", var.name)),
                           var.tags, map("Z_type", "DBSubnetGroup")
                        )}"
  count       = "${length(var.database_subnets) > 0 ? 1 : 0}"
}

resource "aws_subnet" "elasticache" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.elasticache_subnets[count.index]}"
  availability_zone = "${element(var.azs, count.index)}"
  count             = "${length(var.elasticache_subnets)}"
  tags              = "${merge(
                                 var.tags, map("Name", format("%s-subnet-elasticache-%s", var.name, element(var.azs, count.index))),
                                 var.tags, map("Z_name", format("%s-subnet-elasticache-%s", var.name, element(var.azs, count.index))),
                                 var.tags, map("Z_type", "ECSubnetGroup")
                              )}"
}

resource "aws_elasticache_subnet_group" "elasticache" {
  name        = "${var.name}-elasticache-subnet-group"
  description = "Elasticache subnet groups for ${var.name}"
  subnet_ids  = ["${aws_subnet.elasticache.*.id}"]
  count       = "${length(var.elasticache_subnets) > 0 ? 1 : 0}"
}

resource "aws_subnet" "public" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.public_subnets[count.index]}"
  availability_zone = "${element(var.azs, count.index)}"
  count             = "${length(var.public_subnets)}"
  tags              = "${merge(
                                 var.tags, map("Name", format("%s-pub-subnet-%s", var.name, element(var.azs, count.index))),
                                 var.tags, map("Z_name", format("%s-pub-subnet-%s", var.name, element(var.azs, count.index))),
                                 var.tags, map("Z_type", "Subnet")
                              )}"

  map_public_ip_on_launch = "${var.map_public_ip_on_launch}"
}

resource "aws_eip" "nateip" {
  vpc   = true
  count = "${var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : length(var.azs)) : 0}"
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = "${element(aws_eip.nateip.*.id, (var.single_nat_gateway ? 0 : count.index))}"
  subnet_id     = "${element(aws_subnet.public.*.id, (var.single_nat_gateway ? 0 : count.index))}"
  count         = "${var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : length(var.azs)) : 0}"

  depends_on = ["aws_internet_gateway.main"]
}

data "aws_vpc_endpoint_service" "s3" {
  service = "s3"
}

resource "aws_vpc_endpoint" "ep" {
  vpc_id       = "${aws_vpc.main.id}"
  service_name = "${data.aws_vpc_endpoint_service.s3.service_name}"
  count        = "${var.enable_s3_endpoint}"
}

resource "aws_vpc_endpoint_route_table_association" "private_s3" {
  count           = "${var.enable_s3_endpoint ? length(var.private_subnets) : 0}"
  vpc_endpoint_id = "${aws_vpc_endpoint.ep.id}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}

resource "aws_vpc_endpoint_route_table_association" "public_s3" {
  count           = "${var.enable_s3_endpoint ? length(var.public_subnets) : 0}"
  vpc_endpoint_id = "${aws_vpc_endpoint.ep.id}"
  route_table_id  = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "private" {
  count          = "${length(var.private_subnets)}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}

resource "aws_route_table_association" "database" {
  count          = "${length(var.database_subnets)}"
  subnet_id      = "${element(aws_subnet.database.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}

resource "aws_route_table_association" "elasticache" {
  count          = "${length(var.elasticache_subnets)}"
  subnet_id      = "${element(aws_subnet.elasticache.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}

resource "aws_route_table_association" "public" {
  count          = "${length(var.public_subnets)}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}
