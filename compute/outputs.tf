output "instance" {
  value = aws_instance.mtc_node[*]

}

output "tg_port" {
  value = aws_lb_target_group_attachment.mtc_tg_attach.*.port

}