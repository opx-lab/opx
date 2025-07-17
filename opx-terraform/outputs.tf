# output "repository_clone_url" {
#   value = github_repository.opx.http_clone_url
# }

# output "repository_ssh_clone_url" {
#   value = github_repository.opx.ssh_clone_url
# }

# output "vm_names" {
#   description = "Names of all created VMs"
#   value       = [for vm in module.proxmox-vm : vm.name]
# }