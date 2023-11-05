resource "aws_security_group" "Vm2SecurityGroup" {
  name        = "MySecurityGroup"
  description = "Allow TLS inbound traffic"

  ingress {
    description      = "ssh from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "httpd from VPC"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Mynetwork"
  }
}

resource "aws_instance" "MyEC2machine" {
  ami           = "ami-0573324ffc6ebc574"
  instance_type = "t2.micro"
  tags = {
    Name = "virtualmachine2"
  }
 key_name = "vm-1"

 user_data = <<-EOF

      #!/bin/bash
	
	sudo apt update

	sudo apt install -y git ansible

   EOF

}

resource "aws_network_interface_sg_attachment" "sg_attachment1" {
security_group_id = aws_security_group.Vm2SecurityGroup.id
network_interface_id = aws_instance.MyEC2machine.primary_network_interface_id
}


