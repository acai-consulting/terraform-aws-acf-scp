output "cf_template_map" {
  value = {
    "scp_management.yaml.tftpl" = replace(data.template_file.scp_management.rendered, "$$$", "$$")
  }
}
