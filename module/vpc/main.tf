resource "aws_vpc" "main" {
  cidr_block           = local.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = local.vpc_name
  }
}

/* Subnet us-east-1a */

resource "aws_subnet" "firewall-1a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.firewall_subnet[0]
  availability_zone = local.availability_zone[0]
  tags = {
    Name = "firewall-1a"
  }
}

resource "aws_subnet" "public-1a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.public_subnet[0]
  availability_zone = local.availability_zone[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "public-1a"
  }
}

resource "aws_subnet" "private-1a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.private_subnet[0]
  availability_zone = local.availability_zone[0]
  tags = {
    Name = "private-1a"
  }
}

/* Subnet us-east-1b */

resource "aws_subnet" "firewall-1b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.firewall_subnet[1]
  availability_zone = local.availability_zone[1]
  tags = {
    Name = "firewall-1b"
  }
}

resource "aws_subnet" "public-1b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.public_subnet[1]
  availability_zone = local.availability_zone[1]
  map_public_ip_on_launch = true
  tags = {
    Name = "public-1b"
  }
}

resource "aws_subnet" "private-1b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.private_subnet[1]
  availability_zone = local.availability_zone[1]
  tags = {
    Name = "private-1b"
  }
}

/* Internet gateway */

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw"
  }
}

/* elastic ip with nat gateway us-east-1a public subnet */

resource "aws_eip" "eip-1a" {
  domain = "vpc"
}

resource "aws_nat_gateway" "ngw-1a" {
  allocation_id = aws_eip.eip-1a.allocation_id
  subnet_id     = aws_subnet.public-1a.id
}

/* elastic ip with nat gateway us-east-1b public subnet */

resource "aws_eip" "eip-1b" {
  domain = "vpc"
}

resource "aws_nat_gateway" "ngw-1b" {
  allocation_id = aws_eip.eip-1b.allocation_id
  subnet_id     = aws_subnet.public-1b.id
}

/* network firewall rule group */

resource "aws_networkfirewall_rule_group" "nfrg" {
  capacity = 100
  name     = "${local.firewall_name}-allow-ssh-http"
  type     = local.frg_type
  rule_group {
    rules_source {
      stateful_rule {
        action = "PASS"
        header {
          protocol         = "HTTP"
          source           = "ANY"
          destination      = "ANY"
          source_port      = local.frg_port[0]
          destination_port = local.frg_port[0]
          direction        = "ANY"
        }
        rule_option {
          keyword  = "sid"
          settings = ["1"]
        }
      }
      stateful_rule {
        action = "PASS"
        header {
          protocol         = "SSH"
          source           = "ANY"
          destination      = "ANY"
          source_port      = local.frg_port[1]
          destination_port = local.frg_port[1]
          direction        = "ANY"
        }
        rule_option {
          keyword  = "sid"
          settings = ["2"]
        }
      }
    }
  }
}

/* network firewall policy */

resource "aws_networkfirewall_firewall_policy" "nfp" {
  name = "${local.firewall_name}-policy"

  firewall_policy {
    stateless_default_actions          = ["aws:forward_to_sfe"]
    stateless_fragment_default_actions = ["aws:forward_to_sfe"]
    stateful_rule_group_reference {
      resource_arn = aws_networkfirewall_rule_group.nfrg.arn
    }
  }
}

/* network firewall us-east-1a */

resource "aws_networkfirewall_firewall" "firewall-1a" {
  name                = "${local.firewall_name}-1a"
  firewall_policy_arn = aws_networkfirewall_firewall_policy.nfp.arn
  vpc_id              = aws_vpc.main.id
  subnet_mapping {
    subnet_id = aws_subnet.firewall-1a.id
  }
}

/* network firewall us-east-1b */

resource "aws_networkfirewall_firewall" "firewall-1b" {
  name                = "${local.firewall_name}-1b"
  firewall_policy_arn = aws_networkfirewall_firewall_policy.nfp.arn
  vpc_id              = aws_vpc.main.id
  subnet_mapping {
    subnet_id = aws_subnet.firewall-1b.id
  }
}

/* gateway loadbalancer endpoint us-east-1a */

data "aws_vpc_endpoint" "gwlb-1a" {
  vpc_id = aws_vpc.main.id
  state  = "available"
  filter {
    name   = "tag:Name"
    values = [local.endpoint_filter_value[0]]
  }

  depends_on = [aws_networkfirewall_firewall.firewall-1a]
}




/* gateway loadbalancer endpoint us-east-1b */

data "aws_vpc_endpoint" "gwlb-1b" {
  vpc_id = aws_vpc.main.id
  state  = "available"

  filter {
    name   = "tag:Name"
    values = [local.endpoint_filter_value[1]]
  }

  depends_on = [aws_networkfirewall_firewall.firewall-1b]
}




/* Internet route */

resource "aws_route_table" "internet" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block      = aws_subnet.public-1a.cidr_block #public subnet 1a cidr
    vpc_endpoint_id = data.aws_vpc_endpoint.gwlb-1a.id
  }

  route {
    cidr_block      = aws_subnet.public-1b.cidr_block #public subnet 1a cidr
    vpc_endpoint_id = data.aws_vpc_endpoint.gwlb-1b.id
  }

  tags = {
    Name = "internet"
  }
}

resource "aws_route_table_association" "internet" {
  gateway_id     = aws_internet_gateway.igw.id
  route_table_id = aws_route_table.internet.id
}

/* firewall route */

resource "aws_route_table" "firewall" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "firewall"
  }
}

resource "aws_route_table_association" "firewall-1a" {
  subnet_id      = aws_subnet.firewall-1a.id
  route_table_id = aws_route_table.firewall.id
}

resource "aws_route_table_association" "firewall-1b" {
  subnet_id      = aws_subnet.firewall-1b.id
  route_table_id = aws_route_table.firewall.id
}

/* public-1a route */

resource "aws_route_table" "public-1a" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block      = "0.0.0.0/0"
    vpc_endpoint_id = data.aws_vpc_endpoint.gwlb-1a.id
  }

  tags = {
    Name = "public-1a"
  }
}

resource "aws_route_table_association" "public-1a" {
  subnet_id      = aws_subnet.public-1a.id
  route_table_id = aws_route_table.public-1a.id
}

/* public-1b route */

resource "aws_route_table" "public-1b" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block      = "0.0.0.0/0"
    vpc_endpoint_id = data.aws_vpc_endpoint.gwlb-1b.id
  }

  tags = {
    Name = "public-1b"
  }
}

resource "aws_route_table_association" "public-1b" {
  subnet_id      = aws_subnet.public-1b.id
  route_table_id = aws_route_table.public-1b.id
}

/* private-1a route */

resource "aws_route_table" "private-1a" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw-1a.id
  }

  tags = {
    Name = "private-1a"
  }
}

resource "aws_route_table_association" "private-1a" {
  subnet_id      = aws_subnet.private-1a.id
  route_table_id = aws_route_table.private-1a.id
}

/* private-1b route */

resource "aws_route_table" "private-1b" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw-1b.id
  }

  tags = {
    Name = "private-1b"
  }
}

resource "aws_route_table_association" "private-1b" {
  subnet_id      = aws_subnet.private-1b.id
  route_table_id = aws_route_table.private-1b.id
}