locals {
  default_node     = "opx-pc"
}

locals {
  internet_cidrs_v4 = ["0.0.0.0/1", "128.0.0.0/1"]
  internet_cidrs_v6 = ["::/1", "8000::/1"]
}