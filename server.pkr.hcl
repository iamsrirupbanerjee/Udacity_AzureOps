# server.pkr.hcl

variable "client_id" {
  type = string
  default = env("ARM_CLIENT_ID")
}

variable "client_secret" {
  type = string
  default = env("ARM_CLIENT_SECRET")
}

variable "subscription_id" {
  type = string
  default = env("ARM_SUBSCRIPTION_ID")
}

variable "tenant_id" {
  type = string
  default = env("ARM_TENANT_ID")
}

# Azure ARM Builder
source "azure-arm" "ubuntu" {
  client_id                  = var.client_id
  client_secret              = var.client_secret
  subscription_id             = var.subscription_id
  tenant_id                   = var.tenant_id
  os_type                     = "Linux"
  image_publisher             = "Canonical"
  image_offer                 = "UbuntuServer"
  image_sku                   = "18.04-LTS"
  managed_image_resource_group_name = "rg-packer-image"
  managed_image_name          = "udacity-packager-image-v1"
  location                    = "northeurope"
  vm_size                     = "Standard_B1s"
}

# Build block
build {
  sources = ["source.azure-arm.ubuntu"]

  provisioner "shell" {
    inline = [
      "echo 'Hello, World!' > index.html",
      "nohup busybox httpd -f -p 80 &"
    ]
    inline_shebang = "/bin/sh -x"
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
  }
}