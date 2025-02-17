resource "aws_key_pair" "deployer" {
  key_name   = "terraform-key"
  public_key = local.public_key
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "nginx" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = local.instance_type
  subnet_id              = local.public_subnet_id[0]
  key_name               = aws_key_pair.deployer.key_name
  user_data              = file("${path.root}/nginx.sh")
  vpc_security_group_ids = [aws_security_group.allow_http.id, aws_security_group.allow_ssh.id]
  tags = {
    Name = "nginx-server"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("${path.root}/key.pem")
    host        = self.public_ip
  }

  provisioner "file" {
    source      = "${path.root}/nginx-config/site-available/default" # Path to the local file
    destination = "/tmp/default"                                     # Path on the remote EC2 instance
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv /tmp/default /etc/nginx/sites-available/default"
    ]
  }


}

resource "aws_instance" "apache" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = local.instance_type
  subnet_id              = local.public_subnet_id[1]
  key_name               = aws_key_pair.deployer.key_name
  user_data              = file("${path.root}/apache.sh")
  vpc_security_group_ids = [aws_security_group.allow_http.id, aws_security_group.allow_ssh.id]
  tags = {
    Name = "apache-server"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("${path.root}/key.pem")
    host        = self.public_ip
  }

  provisioner "file" {
    source      = "${path.root}/apache-config/" # Path to the local file
    destination = "/home/ubuntu/apache/"        # Ensure consistency in paths
  }

  provisioner "remote-exec" {
    inline = [
      "sudo cp /home/ubuntu/apache/site-available/000-default.conf /etc/apache2/sites-available/000-default.conf",
      "sudo cp /home/ubuntu/apache/apache2.conf /etc/apache2/apache2.conf"
    ]
  }

}


resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic"
  vpc_id      = local.vpc_id

  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic"
  vpc_id      = local.vpc_id

  ingress {
    description = "ssh from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.ssh_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}
