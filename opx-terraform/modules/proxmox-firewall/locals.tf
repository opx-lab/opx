

locals {
  manage_vm = var.vm_id != null
}

# Prevents duplicate creation when the module is reused per-VM.
locals { make_aliases = var.create_aliases }

locals {
  dns_ipset = {
    "8.8.8.8" = "DNS Server 1"
    "8.8.4.4" = "DNS Server 2"
  }
}