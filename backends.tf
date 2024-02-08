terraform {
  cloud {
    organization = "mereoscorp"

    workspaces {
      name = "mtc-dev"
    }
  }
}