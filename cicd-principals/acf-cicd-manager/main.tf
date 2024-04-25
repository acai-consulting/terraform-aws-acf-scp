data "template_file" "scp_management" {
  template = file("${path.module}/scp_management.yaml.tftpl")
  vars = {
  }
}
