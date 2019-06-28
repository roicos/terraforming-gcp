variable "aws_access_key" {
  type = "string"
}

variable "aws_secret_key" {
  type = "string"
}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-2"
}

resource "aws_route53_record" "environment_ns_records" {
  zone_id = "Z2WSHC2PDIF8Y4"
  name    = "${var.env_name}"
  type    = "NS"
  ttl     = "300"
  records = ["${module.infra.dns_zone_name_servers[0]}", "${module.infra.dns_zone_name_servers[1]}", "${module.infra.dns_zone_name_servers[2]}", "${module.infra.dns_zone_name_servers[3]}"]
}
