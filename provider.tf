provider "qumulo" {
    host = "myqumuloclusterhost"
    password = "mypassword"
    port = 8000
    username = "myusername"
}

terraform {
  required_providers {
    qumulo = {
      source = "Qumulo/qumulo"
      version = ">= 0.1.1"    
    }
  }
}

