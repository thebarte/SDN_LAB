terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "Terraform_Project_TELE36058"

    workspaces {
      prefix = "SDN_"
    }
  }
}
