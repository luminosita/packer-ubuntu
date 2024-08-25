terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
    }
  }
}

data "digitalocean_image" "server_snapshot" {
    name = var.vm_server_base_image
}

data "digitalocean_image" "agent_snapshot" {
    name = var.vm_agent_base_image
}

data "digitalocean_ssh_key" "gianni" {
    name = var.do_ssh_key_name
}

resource "digitalocean_droplet" "k3s-server" {
    name            = var.vm_server_name

    image           = data.digitalocean_image.server_snapshot.id
    region          = var.do_region
    size            = var.do_size
    ssh_keys        = [ data.digitalocean_ssh_key.gianni.id ]

    connection {
        host = self.ipv4_address
        user = "root"
        type = "ssh"
        private_key = file(var.pvt_key)
        timeout = "2m"
    }

    provisioner "remote-exec" {
        inline = [
            "echo \"Kralju\"",
        ]
    }
}

resource "digitalocean_droplet" "k3s-agent" {
    name            = "${var.vm_agent_name}-${count.index+1}"

    count           = 2

    image           = data.digitalocean_image.agent_snapshot.id
    region          = var.do_region
    size            = var.do_size
    ssh_keys        = [ data.digitalocean_ssh_key.gianni.id ]

    connection {
        host = self.ipv4_address
        user = "root"
        type = "ssh"
        private_key = file(var.pvt_key)
        timeout = "2m"
    }

    provisioner "remote-exec" {
        inline = [
            "echo \"Kralju\"",
        ]
    }
}

# resource "null_resource" "test" {
#   # Changes to any instance of the cluster requires re-provisioning
#   triggers = {
#     cluster_instance_ids = join(",", aws_instance.cluster[*].id)
#   }

#   # Bootstrap script can run on any instance of the cluster
#   # So we just choose the first in this case
#   connection {
#     host = element(aws_instance.cluster[*].public_ip, 0)
#   }

#   provisioner "remote-exec" {
#     # Bootstrap script called with private_ip of each node in the cluster
#     inline = [
#       "bootstrap-cluster.sh ${join(" ",
#       aws_instance.cluster[*].private_ip)}",
#     ]
#   }
# }