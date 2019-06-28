resource "google_compute_address" "lb" {
  name = "${var.env_name}-${var.name}-address"

  num = "${var.num}"
}

resource "google_compute_forwarding_rule" "lb" {
  name        = "${var.env_name}-${var.name}-lb-${num.index}"
  ip_address  = "${google_compute_address.lb.address}"
  target      = "${google_compute_target_pool.lb.self_link}"
  port_range  = "${element(var.forwarding_rule_ports, num.index)}"
  ip_protocol = "TCP"

  num = "${var.num > 0 ? length(var.forwarding_rule_ports) : 0}"
}

resource "google_compute_target_pool" "lb" {
  name = "${var.lb_name}"

  health_checks = ["${google_compute_http_health_check.lb.*.name}"]

  num = "${var.num}"
}
