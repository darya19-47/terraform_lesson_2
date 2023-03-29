resource "digitalocean_ssh_key" "my_ssh_key" {
  name = "ssh_key"
  public_key = var.shh_key
  }

  data "digitalocean_sizes" "main" {
  filter {
    key    = "vcpus"
    values = [1]
  }

  filter {
    key    = "ram"
    values = [1024]
  }
filter {
    key    = "disk"
    values = [25]
  }

  sort {
    key       = "price_monthly"
    direction = "asc"
  }
}

data "digitalocean_regions" "available" {
  filter {
    key    = "available"
    values = ["true"]
  }
}

resource "digitalocean_droplet" "first server" {
  image = "ubuntu-20-04-x64"
  name = "Ubuntu"
  region = element(data.digitalocean_regions.available.regions, 0).slug
  size = element(data.digitalocean_sizes.main.sizes, 0).slug
  ssh_keys = [data.digitalocean_ssh_key.rebrain_ssh_key.id, digitalocean_ssh_key.my_ssh_key.id]
  tags = ["devops", var.email]
}

resource "digitalocean_tag" "email" {
  name = var.email
}