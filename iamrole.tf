resource "aws_iam_instance_profile" "iam-role-profile" {
  name = "iam-role-profile"
  role = "EC2InstanceRole"
}

