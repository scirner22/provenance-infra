resource "aws_route53_zone" "private_zone" {
  name = "internal.treestaker.com"

  vpc {
    vpc_id = aws_vpc.main.id
  }
}

resource "aws_route53_zone" "public_zone" {
  name = "treestaker.com"
}

resource "aws_route53_record" "public_node_1" {
  zone_id = aws_route53_zone.public_zone.zone_id
  name    = "node1.treestaker.com"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.ip_a.public_ip]
}

resource "aws_route53_record" "public_node_2" {
  zone_id = aws_route53_zone.public_zone.zone_id
  name    = "node2.treestaker.com"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.ip_b.public_ip]
}

resource "aws_route53_record" "public_node_3" {
  zone_id = aws_route53_zone.public_zone.zone_id
  name    = "node3.treestaker.com"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.ip_c.public_ip]
}
