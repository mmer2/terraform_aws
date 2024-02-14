output "lb_dns_name" {
  value       = module.loadbalancing.lb_dns_name
  description = "LB DNS name."
}

output "instance" {
  value = { for i in module.compute.instance : i.tags.Name => join(":", [i.public_ip, module.compute.tg_port[0]]) }

}

output "kubeconfig" {
  value = [ for i in module.compute.instance: "export KUBECONFIG=../k3s-${i.tags.Name}.yaml"]
}
