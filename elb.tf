##############################################################################################
### Elastic Load Balancer
##############################################################################################
resource "aws_elb" "magento" {
  name = "magento-elb"

  security_groups = [
    aws_security_group.elb.id,
  ]

  availability_zones = data.aws_availability_zones.all.names # ALL --> Multi AZ!

  health_check {
    healthy_threshold   = 2 

    unhealthy_threshold = 10
    timeout             = 5
    interval            = 30
    target              = "TCP:80"
  }

  listener {
    lb_port = 80 # Currently we stick with HTTP. I'll add full SSL later

    lb_protocol       = "http"
    instance_port     = 80
    instance_protocol = "http"
  }

  tags                         = {
    Terraform-Magento  = "staging"
  }


}

