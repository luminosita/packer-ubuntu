terraform {
    required_providers {
        digitalocean = {
            source = "digitalocean/digitalocean"
        }

        external = {
            source = "hashicorp/external"
        }
            
        local = {
            source = "hashicorp/local"
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

data "external" "k3s-init-info" {
  program = ["/bin/bash", "../scripts/k3s-init-info.sh"]
  query = {
    ip_address  = digitalocean_droplet.k3s_server.ipv4_address,
    private_key = var.pvt_key
  }
}

resource "digitalocean_droplet" "k3s_server" {
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
        scripts = [
            "../scripts/k3s.sh",
            "../scripts/istio.sh",
        ]
    }
}

resource "digitalocean_droplet" "k3s_agent" {
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
        content = templatefile("../templates/k3s-env.tpl", {
            "K3S_TOKEN" = trimspace(data.external.k3s-init-info.result.token),
            "K3S_IP" = digitalocean_droplet.k3s_server.ipv4_address_private,
        }) 
        
        destination = "/etc/systemd/system/k3s-agent.service.env"
    }

    provisioner "remote-exec" {
        scripts = [
            "../scripts/k3s-agent-start.sh",
        ]
    }
}

# resource "local_file" "test_file" {
#     filename = "test.env"

#     //content = data.external.k3s-init-info.result.token

#     content = replace(replace(jsonencode(data.external.k3s-init-info.result), "\"", ""), ":", "=")
# }

# variable "ips" {
#     type = list(string)
#     default = ["167.99.129.234"]
# }

# resource "null_resource" "test" {
#     count = 1

#     connection {
#         host = var.ips[count.index]
#         user = "root"
#         type = "ssh"
#         private_key = file(var.pvt_key)
#         timeout = "2m"  
#     }

#     provisioner "remote-exec" {
#         inline = [
#             # "systemctl enable k3s-agent",
#             # "systemctl start k3s-agent",
#         ]
#     }
# }