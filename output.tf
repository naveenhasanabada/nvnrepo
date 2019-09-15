output "instance_ips" {
  value = ["${aws_instance.nvnserver2.*.public_ip}"]
}
