resource "aws_security_group" "sg" {
  name   = "LoadBalancerAndEC2"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "allow_inbound_http" {
  security_group_id = aws_security_group.sg.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_inbound_https" {
  security_group_id = aws_security_group.sg.id
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}