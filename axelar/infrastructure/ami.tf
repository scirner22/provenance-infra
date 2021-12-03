# data "aws_ami" "sentinel" {
# 	most_recent = true
# 	name_regex = "^pio-testnet-1-sentinel-*"
# 	owners = ["self"]
# 
# 	filter {
# 		name = "name"
# 		values = ["pio-testnet-1-sentinel-*"]
# 	}
# 
# 	filter {
# 		name = "root-device-type"
# 		values = ["ebs"]
# 	}
# 
# 	filter {
# 		name = "virtualization-type"
# 		values = ["hvm"]
# 	}
# }
