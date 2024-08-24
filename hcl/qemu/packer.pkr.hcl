packer {
  required_plugins {
    qemu = {
      version = ">= 1.1.0"
      source  = "github.com/hashicorp/qemu"
    }
    
    ansible = {
      version = ">= 1.1.1"
      source = "github.com/hashicorp/ansible"
    }

    digitalocean = {
      version = ">= 1.4.0"
      source  = "github.com/digitalocean/digitalocean"
    }
  } 
}