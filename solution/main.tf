provider "google" {
  credentials = file("account.json")
  project = var.project
  region  = var.region
  zone    = var.zone
}
module "server" {
  source = "./server"
  name                   = var.name
  image                  = var.image
  identity               = var.identity
  zone                   = var.zone
}