# aws-networkfirewall-with-application-loadbalancer

This repository contains Terraform configurations to create a VPC, EC2 instances, and an Application Load Balancer (ALB) in AWS.

## Resources Used
1. VPC (Virtual Private Cloud)
    - **Purpose:** The VPC serves as the isolated network environment where all resources (subnets, security groups, instances, etc.) reside. It defines the IP address range (CIDR block) for the resources in your network.
    - **Configuration:** vpc_name and vpc_cidr define the VPC name and its CIDR block, respectively.
2. Subnets
    - **Purpose:** Subnets are used to divide the VPC into smaller, manageable blocks for different types of resources (public, private).
        - **Firewall Subnet:** Specifically for the network firewall, which controls traffic between the internal network and the internet, ensuring security by filtering incoming and outgoing traffic.
        - **Public Subnet:** Used for resources that need direct access to the internet, such as EC2 instances and load balancers.
        - **Private Subnet:** For resources that do not need direct internet access, like backend databases or internal services.
    - **Configuration:** The public_subnet and private_subnet are defined with specific CIDR blocks to separate the resources into public and private spaces across two availability zones (us-east-1a, us-east-1b).
3. Internet Gateway
    - **Purpose:** The Internet Gateway allows communication between instances in the VPC and the internet. It is essential for public-facing resources like EC2 instances to access the internet.
    - **Configuration:** Attached to the VPC for internet access.
4. NAT Gateway
    - **Purpose:** The NAT Gateway enables outbound internet access for instances in private subnets while keeping them isolated from incoming internet traffic. This is particularly useful for instances that need to download software updates or access external APIs but should not be directly exposed to the internet.
    - **Configuration:** The NAT Gateway is associated with an Elastic IP to provide a stable IP for outbound traffic.
5. Route Tables
    - **Purpose:** Route tables determine where network traffic from your subnet should go.
        - **Public Route Table:** Routes internet-bound traffic from public subnets to the Internet Gateway.
        - **Private Route Table:** Routes traffic from private subnets to the NAT Gateway for outbound internet access.
    - **Configuration:** Routes are set up to ensure proper traffic flow between public/private subnets, the internet, and the NAT gateway.
6. Network Firewall
    - **Purpose:** A firewall helps control incoming and outgoing network traffic based on predefined security rules.
    - **Configuration:** The firewall is configured with security rules to manage and restrict access, ensuring only allowed traffic can reach the instances in the VPC. The rules can be defined for protocols and port numbers (like HTTP, SSH).
7. Elastic IP (EIP)
    - **Purpose:** An Elastic IP is used to assign a static IP address to the NAT Gateway, enabling reliable outbound internet access from private subnets.
    - **Configuration:** The EIP is associated with the NAT Gateway for consistent access to the internet.
8. Application Load Balancer (ALB)
    - **Purpose:** The ALB is used to distribute incoming traffic across multiple EC2 instances to ensure high availability and fault tolerance. It provides layer 7 (HTTP/HTTPS) load balancing and health checks.
    - **Configuration:** The ALB is configured with security groups, subnets, and instance IDs, balancing traffic between web servers (Nginx and Apache) running on EC2 instances.
9. Security Groups
    - **Purpose:** Security groups act as virtual firewalls for EC2 instances, controlling inbound and outbound traffic.
    - Configuration:
        - **allow_http:** Allows HTTP traffic (port 80) to EC2 instances.
        - **allow_ssh:** Allows SSH traffic (port 22) to EC2 instances for administrative access.
10. EC2 Instances (Nginx & Apache)
    - **Purpose:** EC2 instances are used to host web servers (Nginx and Apache) for testing the load balancer and web server configuration.
    - **Configuration:** Two EC2 instances are created, one running Nginx and the other running Apache2, to simulate web traffic and test the health check mechanisms configured on the ALB.
11. Health Check Configuration
    - **Purpose:** Health checks are configured to ensure that the ALB only routes traffic to healthy instances. If an instance becomes unhealthy (e.g., the web server is down), the ALB stops routing traffic to it and redirects traffic to other healthy instances.
    - **Configuration:** The health check monitors the web server's response on a specific path (e.g., /health), ensuring that instances are up and functioning properly.

## Inputs

| **Module**         | **Variable**             | **Description**                                                             | **Type**            | **Value/Example**                                                      |
|--------------------|--------------------------|-----------------------------------------------------------------------------|---------------------|-------------------------------------------------------------------------|
| `vpc`              | `vpc_name`               | The name of the VPC.                                                        | `string`            | `my-vpc`                                                                |
|                    | `vpc_cidr`               | The CIDR block for the VPC.                                                 | `string`            | `10.0.0.0/24`                                                           |
|                    | `az_zone`                | The Availability Zones for the VPC.                                          | `list(string)`      | `["us-east-1a", "us-east-1b"]`                                          |
|                    | `firewall_subnet`        | Subnet CIDR blocks for the firewall.                                         | `list(string)`      | `["10.0.0.0/27", "10.0.0.96/27"]`                                       |
|                    | `public_subnet`          | Subnet CIDR blocks for the public subnet.                                    | `list(string)`      | `["10.0.0.32/27", "10.0.0.128/27"]`                                     |
|                    | `private_subnet`         | Subnet CIDR blocks for the private subnet.                                   | `list(string)`      | `["10.0.0.64/27", "10.0.0.160/27"]`                                    |
|                    | `firewall_rule_group_type` | The type of firewall rule group (stateful or stateless).                     | `string`            | `STATEFUL`                                                              |
|                    | `firewall_rule_group_port` | Ports for the firewall rule group.                                          | `list(number)`      | `[80, 22]`                                                              |
|                    | `firewall_name`          | The name of the firewall.                                                   | `string`            | `firewall`                                                              |
|                    | `endpoint_filter_value`  | The filter values for endpoint.                                              | `list(string)`      | `["firewall-1a (us-east-1a)", "firewall-1b (us-east-1b)"]`               |
| `instance`         | `public_key`             | The SSH public key to access the instances.                                  | `string`            | `"ssh-rsa AAAAB3Nza... arunkumar@arunkumar-VivoBook-ASUSLaptop-X509JA-X509JA"` |
|                    | `instance_type`          | The type of EC2 instance to create.                                          | `string`            | `t3.micro`                                                              |
|                    | `public_subnet_id`       | The subnet IDs for the public subnets where instances will be deployed.      | `list(string)`      | `[module.vpc.public_subnet_1a, module.vpc.public_subnet_1b]`            |
|                    | `vpc_id`                 | The ID of the VPC.                                                          | `string`            | `module.vpc.vpc_id`                                                     |
|                    | `allow_ssh_cidr`         | CIDR block to allow SSH access.                                             | `string`            | `0.0.0.0/0`                                                             |
| `ALB`               | `load_balancer_name`     | The name of the Application Load Balancer.                                  | `string`            | `test-lb`                                                               |
|                    | `load_balancer_type`     | The type of Load Balancer (application or network).                         | `string`            | `application`                                                           |
|                    | `vpc_id`                 | The ID of the VPC for the ALB.                                              | `string`            | `module.vpc.vpc_id`                                                     |
|                    | `subnet_ids`             | Subnet IDs for the ALB.                                                     | `list(string)`      | `[module.vpc.public_subnet_1a, module.vpc.public_subnet_1b]`            |
|                    | `security_groups_ids`    | Security group IDs for the instances.                                       | `list(string)`      | `[module.instance.allow_http, module.instance.allow_ssh]`               |
|                    | `instance_ids`           | The EC2 instance IDs to associate with the ALB.                             | `list(string)`      | `[module.instance.nginx-instance-id, module.instance.apache-instance-id]` |
|                    | `port`                   | The port to route traffic to on the ALB.                                    | `number`            | `80`                                                                    |

## Outputs

| **Module**         | **Output**               | **Description**                                                             | **Type**            | **Value/Example**                                                      |
|--------------------|--------------------------|-----------------------------------------------------------------------------|---------------------|-------------------------------------------------------------------------|
| `vpc`              | `vpc_id`                 | The ID of the created VPC.                                                  | `string`            | `vpc-abc12345`                                                          |
|                    | `public_subnet_1a`       | The ID of the public subnet in Availability Zone 1a.                         | `string`            | `subnet-xyz12345`                                                       |
|                    | `public_subnet_1b`       | The ID of the public subnet in Availability Zone 1b.                         | `string`            | `subnet-xyz67890`                                                       |
|                    | `private_subnet_1a`      | The ID of the private subnet in Availability Zone 1a.                        | `string`            | `subnet-abc12345`                                                       |
|                    | `private_subnet_1b`      | The ID of the private subnet in Availability Zone 1b.                        | `string`            | `subnet-abc67890`                                                       |
| `instance`         | `instance_ids`           | The IDs of the created EC2 instances.                                        | `list(string)`      | `[i-0abc12345, i-0def67890]`                                            |
|                    | `nginx-instance-id`      | The ID of the created Nginx EC2 instance.                                    | `string`            | `i-0abc12345`                                                          |
|                    | `apache-instance-id`     | The ID of the created Apache EC2 instance.                                   | `string`            | `i-0def67890`                                                          |
|                    | `allow_http`             | The security group ID allowing HTTP access.                                  | `string`            | `sg-123abc45`                                                           |
|                    | `allow_ssh`              | The security group ID allowing SSH access.                                  | `string`            | `sg-678def90`                                                           |
| `ALB`               | `alb_dns_name`           | The DNS name of the Application Load Balancer.                               | `string`            | `test-lb-1234567890.us-east-1.elb.amazonaws.com`                         |
|                    | `alb_arn`                | The ARN of the created ALB.                                                 | `string`            | `arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/app/test-lb/abcd1234` |
|                    | `load_balancer_id`       | The ID of the created Application Load Balancer.                             | `string`            | `app/test-lb/abcd1234`                                                  |


## Modules

1. **vpc**: Creates the VPC, subnets, and firewall configurations.
2. **instance**: Creates EC2 instances and provides configuration for SSH and public access.
3. **ALB**: Sets up an Application Load Balancer and links it with the EC2 instances.

## Usage

To use this infrastructure configuration, initialize and apply the Terraform configuration:

```bash
terraform init
terraform apply
