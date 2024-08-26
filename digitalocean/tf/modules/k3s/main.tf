terraform {
    required_providers {
        digitalocean = {
            source = "digitalocean/digitalocean"
        }

        null = {
            source = "hashicorp/null"
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

data "local_file" "k3s_token" {
  filename = var.k3s_server_token_file
}

resource "digitalocean_droplet" "k3s-server" {
    name            = var.vm_server_name

    image           = data.digitalocean_image.server_snapshot.id
    region          = var.do_region
    size            = var.do_size
    ssh_keys        = [ data.digitalocean_ssh_key.gianni.id ]
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

    provisioner "file" {
        content = templatefile("templates/k3s-env.tpl", {
            "K3S_TOKEN" = trimspace(data.local_file.k3s_token.content),
            "K3S_IP" = digitalocean_droplet.k3s-server.ipv4_address_private,
        }) 
        
        destination = "/etc/systemd/system/k3s-agent.service.env"
    }

    provisioner "remote-exec" {
        inline = [
            "systemctl enable k3s-agent",
            "systemctl start k3s-agent",
        ]
    }
}

# variable "ips" {
#     type = list(string)
#     default = ["165.232.74.25", "165.232.76.152"]
# }

# resource "null_resource" "test" {
#     count = 2

#     connection {
#         host = var.ips[count.index]
#         user = "root"
#         type = "ssh"
#         private_key = file(var.pvt_key)
#         timeout = "2m"  
#     }

#     provisioner "file" {
#         content = templatefile("templates/k3s-env.tpl", {
#             "K3S_TOKEN" = strip(data.local_file.k3s_token.content),
#             "K3S_IP" = var.ips[count.index],
#         }) 
        
#         destination = "/etc/systemd/system/k3s-agent.service.env"
#     }

#     provisioner "remote-exec" {
#         inline = [
#             # "systemctl enable k3s-agent",
#             # "systemctl start k3s-agent",
#         ]
#     }
# }