# output "key_data" {
#   value = azapi_resource_action.ssh_public_key_gen.output.publicKey
# }

output "vm_name" {
  value = azurerm_linux_virtual_machine.test_vm.name
}
