provider "aws" {
     region = "ap-northeast-2"
  
}

resource "aws_instance" "my-instance" {
  
     ami = "ami-084a56dceed3eb9bb" 
     instance_type = "t3.small"
     vpc_security_group_ids =["sg-0f96243e3300ff6f9"] 
     key_name = "jenkins" 
     tags = {
        Name = "my-instance"
        env = "easycrud"
     }
}