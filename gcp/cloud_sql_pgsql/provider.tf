terraform {
  cloud {
    organization = "Andromeda101"

    workspaces {
      name = "gcp-andromeda-slvr"
    }
  }
}

provider "google" {
  credentials = file("gcp-credentials.json")
  project = var.project_id
  region      = var.region
}