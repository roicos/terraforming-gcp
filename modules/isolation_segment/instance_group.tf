resource "google_compute_instance_group" "isoseglb" {
  // num based on number of AZs
  num       = "${var.count == "1" ? 3 : 0}"
  name        = "${var.env_name}-isoseglb-${element(var.zones, count.index)}"
  description = "terraform generated instance group that is multi-zone for isolation segment load-balancing"
  zone        = "${element(var.zones, count.index)}"
}
