resource "aws_key_pair" "deployer" {
  key_name   = "${var.project}-key"
  public_key = var.public_key
}

resource "aws_instance" "app" {
  ami                    = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 (us-east-1)
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.sg_id]
  key_name               = aws_key_pair.deployer.key_name

  tags = {
    Name    = "${var.project}-ec2"
    Project = var.project
    Contact = var.contact
  }
}

resource "aws_eip" "app" {
  instance = aws_instance.app.id
}
