## Creating ssh key
resource "aws_key_pair" "weather-api" {
  key_name   = "weather-api"
  public_key = file("${path.module}/weather-api.pub")
}

## Creating aws instance
resource "aws_instance" "weather-api-app" {
  ami                    = var.ami-id
  instance_type          = var.instance-type
  key_name               = aws_key_pair.weather-api.key_name
  iam_instance_profile   = aws_iam_instance_profile.iam-role-profile.id
  subnet_id              = aws_subnet.weather-api-app-subnet.id
  vpc_security_group_ids = ["${aws_security_group.weather-api-app-sg.id}"]

  user_data = <<-EOF
  #!/bin/bash
  sudo yum -y update
  sudo yum -y install httpd
  sudo yum install docker
  sudo systemctl enable httpd
  sudo systemctl start httpd
  sudo systemctl enable docker.service
  sudo systemctl start docker.service
  EOF

  tags = {
    "Name" = "Weather API Application"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("${path.module}/weather-api")
    host        = self.public_ip
  }

  

  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo yum update",
  #     "sudo yum install -y httpd",
  #     "sudo systemctl enable httpd",
  #     "sudo systemctl start httpd"
  #   ]
  # }

  #   provisioner "remote-exec" {
  #   inline = [
  #     "sudo chmod -R o+rw /var/www/html",
  #     "sudo echo 'Hey this is a script from remote-exec' > /var/www/html/tf.html"
  #   ]
  # }

  # provisioner "file" {
  #   source      = "index.html"
  #   destination = "/var/www/html/index.html"
  # }

}

output "public-ip" {
  value = aws_instance.weather-api-app.public_ip

}