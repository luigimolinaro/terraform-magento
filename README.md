# terraform-magento2

Create AWS autoscaling Magento2 platform
Change only _config.tf (Access-Key and SSH Public Key)

#####################################################
### Define Cloud provider
#####################################################

provider "aws" {
  region     = "La tua Region"
  access_key = "ACCESS-KEY"
  secret_key = "SECRET-KEY"
}

####################################################################
### SSH Keys
###################################################################

resource "aws_key_pair" "publicaccesskey" {
  key_name = "LuigiMolinaroProd"
  public_key   = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDlv4Ly2HhfeXobFTRYBSxBMZ30jclfw9nzbuX2oqT5ZEwc5VI6CItME8ulAfhlqr7Jnm+AC1L2nF0gXowoO2Fe/d2dsni89bFbg0p9ky32AtsyzXF2poDmJ4iTW38U6c+qQO247Uroa6GMYaZJyQQ2V8ECy68uB6W9SbqGJFWfnWm8Pjmy2Mxr3oH61+dbZuNNzZJJwBMpclqTl34Z3ZJdoDyDOR9c+khjvv+Na2Ebf7hG12dO8KxGaDgP6ChOmGX1OuQLL0VW1IXxPFj57g2HeFDiJBFuIpnemmcnLHUnm4cEfKoniuem36g4OZN8WApkG/GCUrQ1lApNTXmI54Ap luigi.molinaro@gmail.com"
}
