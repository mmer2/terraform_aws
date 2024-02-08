#--networking/outputs.tf--
output "vpc_id" {
  value = aws_vpc.mtc-vpc.id
}

output "db_subnet_name" {
  value = aws_db_subnet_group.mtc_rds_subnet_group[*].name

}

output "vpc_sec_group_ids" {
  value = [aws_security_group.mtc_sg["rds"].id]

}

output "public_sg" {
  value = aws_security_group.mtc_sg["public"].id

}

output "public_subnets" {
  value = aws_subnet.mtc-public-subnet.*.id

}