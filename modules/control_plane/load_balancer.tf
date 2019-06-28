module "plane-lb" {
  source = "../load_balancer"

  env_name = "${var.env_name}"
  name     = "plane"

  global  = false
  num   = 1
  network = "${var.network}"

  ports                 = ["2222", "443"]
  forwarding_rule_ports = ["2222", "443"]

  lb_name      = "${var.env_name}-control-plane"
  health_check = false
}
