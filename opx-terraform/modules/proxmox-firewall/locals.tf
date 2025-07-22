
locals {
  manage_vm = var.vm_id != null
}

# Prevents duplicate creation when the module is reused per-VM.
locals { make_aliases = var.create_aliases }