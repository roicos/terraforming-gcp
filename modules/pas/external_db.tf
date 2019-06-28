locals {
  external_db_count = "${var.external_database ? 1 : 0}"
}

# Databases

resource "google_sql_database" "uaa" {
  name       = "uaa"
  instance   = "${var.sql_instance}"
  depends_on = ["google_sql_user.pas"]

  num = "${local.external_db_count}"
}

resource "google_sql_database" "ccdb" {
  name       = "ccdb"
  instance   = "${var.sql_instance}"
  depends_on = ["google_sql_database.uaa"]

  num = "${local.external_db_count}"
}

resource "google_sql_database" "notifications" {
  name       = "notifications"
  instance   = "${var.sql_instance}"
  depends_on = ["google_sql_database.ccdb"]

  num = "${local.external_db_count}"
}

resource "google_sql_database" "autoscale" {
  name       = "autoscale"
  instance   = "${var.sql_instance}"
  depends_on = ["google_sql_database.notifications"]

  num = "${local.external_db_count}"
}

resource "google_sql_database" "app_usage_service" {
  name       = "app_usage_service"
  instance   = "${var.sql_instance}"
  depends_on = ["google_sql_database.autoscale"]

  num = "${local.external_db_count}"
}

resource "google_sql_database" "console" {
  name       = "console"
  instance   = "${var.sql_instance}"
  depends_on = ["google_sql_database.app_usage_service"]

  num = "${local.external_db_count}"
}

resource "google_sql_database" "diego" {
  name       = "diego"
  instance   = "${var.sql_instance}"
  depends_on = ["google_sql_database.console"]

  num = "${local.external_db_count}"
}

resource "google_sql_database" "routing" {
  name       = "routing"
  instance   = "${var.sql_instance}"
  depends_on = ["google_sql_database.diego"]

  num = "${local.external_db_count}"
}

resource "google_sql_database" "account" {
  name       = "account"
  instance   = "${var.sql_instance}"
  depends_on = ["google_sql_database.routing"]

  num = "${local.external_db_count}"
}

resource "google_sql_database" "networkpolicyserver" {
  name       = "networkpolicyserver"
  instance   = "${var.sql_instance}"
  depends_on = ["google_sql_database.account"]

  num = "${local.external_db_count}"
}

resource "google_sql_database" "nfsvolume" {
  name       = "nfsvolume"
  instance   = "${var.sql_instance}"
  depends_on = ["google_sql_database.networkpolicyserver"]

  num = "${local.external_db_count}"
}

resource "google_sql_database" "silk" {
  name       = "silk"
  instance   = "${var.sql_instance}"
  depends_on = ["google_sql_database.nfsvolume"]

  num = "${local.external_db_count}"
}

resource "google_sql_database" "locket" {
  name       = "locket"
  instance   = "${var.sql_instance}"
  depends_on = ["google_sql_database.silk"]

  num = "${local.external_db_count}"
}

resource "google_sql_database" "credhub" {
  name       = "credhub"
  instance   = "${var.sql_instance}"
  depends_on = ["google_sql_database.locket"]

  num = "${local.external_db_count}"
}

# Users

resource "random_id" "pas_db_username" {
  byte_length = 8

  num = "${local.external_db_count}"
}

resource "random_id" "pas_db_password" {
  byte_length = 32

  num = "${local.external_db_count}"
}

resource "google_sql_user" "pas" {
  name     = "${random_id.pas_db_username.b64}"
  password = "${random_id.pas_db_password.b64}"
  instance = "${var.sql_instance}"
  host     = "${var.pas_sql_db_host}"

  num = "${local.external_db_count}"
}
