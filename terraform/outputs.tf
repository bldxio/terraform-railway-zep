# Collect passwords in a map

output "passwords_map" {
  value = { for k, v in module.passwords : k => v.password }
}
