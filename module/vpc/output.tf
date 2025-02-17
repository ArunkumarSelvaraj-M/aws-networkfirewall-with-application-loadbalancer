output "vpc_id" {
  description = "The VPC ID"
  value       = aws_vpc.main.id
}

output "firewall_subnet_1a_id" {
  description = "The ID of the firewall subnet in us-east-1a"
  value       = aws_subnet.firewall-1a.id
}

output "public_subnet_1a_id" {
  description = "The ID of the public subnet in us-east-1a"
  value       = aws_subnet.public-1a.id
}

output "private_subnet_1a_id" {
  description = "The ID of the private subnet in us-east-1a"
  value       = aws_subnet.private-1a.id
}

output "firewall_subnet_1b_id" {
  description = "The ID of the firewall subnet in us-east-1b"
  value       = aws_subnet.firewall-1b.id
}

output "public_subnet_1b_id" {
  description = "The ID of the public subnet in us-east-1b"
  value       = aws_subnet.public-1b.id
}

output "private_subnet_1b_id" {
  description = "The ID of the private subnet in us-east-1b"
  value       = aws_subnet.private-1b.id
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

output "nat_gateway_1a_id" {
  description = "The ID of the NAT Gateway in us-east-1a"
  value       = aws_nat_gateway.ngw-1a.id
}

output "nat_gateway_1b_id" {
  description = "The ID of the NAT Gateway in us-east-1b"
  value       = aws_nat_gateway.ngw-1b.id
}

output "network_firewall_rule_group_id" {
  description = "The ID of the network firewall rule group"
  value       = aws_networkfirewall_rule_group.nfrg.id
}

output "network_firewall_firewall_policy_id" {
  description = "The ID of the network firewall policy"
  value       = aws_networkfirewall_firewall_policy.nfp.id
}

output "firewall_1a_id" {
  description = "The ID of the network firewall in us-east-1a"
  value       = aws_networkfirewall_firewall.firewall-1a.id
}

output "firewall_1b_id" {
  description = "The ID of the network firewall in us-east-1b"
  value       = aws_networkfirewall_firewall.firewall-1b.id
}

output "gwlb_endpoint_1a_id" {
  description = "The ID of the gateway load balancer endpoint in us-east-1a"
  value       = data.aws_vpc_endpoint.gwlb-1a.id
}

output "gwlb_endpoint_1b_id" {
  description = "The ID of the gateway load balancer endpoint in us-east-1b"
  value       = data.aws_vpc_endpoint.gwlb-1b.id
}

output "internet_route_table_id" {
  description = "The ID of the internet route table"
  value       = aws_route_table.internet.id
}

output "firewall_route_table_id" {
  description = "The ID of the firewall route table"
  value       = aws_route_table.firewall.id
}

output "public_route_table_1a_id" {
  description = "The ID of the public route table in us-east-1a"
  value       = aws_route_table.public-1a.id
}

output "public_route_table_1b_id" {
  description = "The ID of the public route table in us-east-1b"
  value       = aws_route_table.public-1b.id
}

output "private_route_table_1a_id" {
  description = "The ID of the private route table in us-east-1a"
  value       = aws_route_table.private-1a.id
}

output "private_route_table_1b_id" {
  description = "The ID of the private route table in us-east-1b"
  value       = aws_route_table.private-1b.id
}
