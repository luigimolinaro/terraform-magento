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
  key_name = "YOURPUBLICKEY"
  public_key   = "YOUR PUBLICKEY"
}
