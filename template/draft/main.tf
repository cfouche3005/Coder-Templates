terraform {
  required_providers {
    coder = {
      source  = "coder/coder"
      version = "0.5.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.22.0"
    }
  }
}

provider "docker" {
  host = data.coder_parameter.docker_host.value
}

data "coder_workspace" "me" {
}

#data "coder_parameter" "docker_host" {
#  name = "Docker Host"
#  description = "Address of the Docker host ([unix://], [ssh://], [tcp://])"
#  icon = "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/docker.png"
#  mutable = false
#  type = "string"
#  default = "unix:///var/run/docker.sock"
#  validation {
#    regex = "(unix://)|(tcp://)|(ssh://)"
#    error = "Invalid Docker Host !"
#  }
#}

data "docker_registry_image" "docker_image" {
  name = "cf3005/ctdc-base:${var.docker_os}-%{ if var.select_vsc == true }vsc%{ else }no-vsc%{ endif }"
}


# Variable


variable "docker_host_arch" {
  description = "CPU architecture of the Docker host"
  default = "amd64"
  validation {
    condition = contains(["amd64","arm64"], var.docker_host_arch)
    error_message = "Invalid Docker CPU architecture !"
  }
}

variable "docker_os" {
  description = "Which Operating System would you like to use for your workspace?"
  default = "debian"
  validation {
    condition = contains(["debian","fedora","ubuntu"], var.docker_os)
    error_message = "Invalid Docker OS !"
  }
}

variable "select_vsc" {
  type = bool
  description = "Do you want to have Visual Studio Code server installed"
  default = false
}

locals {
  no-vsc = <<EOF
    #!/bin/sh
    #install and start code-server
    #code-server --auth none --port 13337
    EOF
  vsc = <<EOF
    !/bin/sh
    code-server --auth none --port 13337
    EOF
}

resource "coder_agent" "main" {
  arch           = var.docker_host_arch
  os             = "linux"
  startup_script = var.select_vsc ? local.vsc : local.no-vsc

  # These environment variables allow you to make Git commits right away after creating a
  # workspace. Note that they take precedence over configuration defined in ~/.gitconfig!
  # You can remove this block if you'd prefer to configure Git manually or using
  # dotfiles. (see docs/dotfiles.md)
  env = {
    GIT_AUTHOR_NAME = "${data.coder_workspace.me.owner}"
    GIT_COMMITTER_NAME = "${data.coder_workspace.me.owner}"
    GIT_AUTHOR_EMAIL = "${data.coder_workspace.me.owner_email}"
    GIT_COMMITTER_EMAIL = "${data.coder_workspace.me.owner_email}"
  }
}

resource "coder_app" "code-server" {
  count = var.select_vsc ? 1 : 0
  agent_id = coder_agent.main.id
  name     = "code-server"
  url      = "http://localhost:13337"
  icon     = "/icon/code.svg"
}

resource "docker_image" "docker_image" {
  name          = data.docker_registry_image.docker_image.name
  pull_triggers = [data.docker_registry_image.docker_image.sha256_digest]
  keep_locally = true
}

resource "docker_volume" "home_volume" {
  name = "coder-${data.coder_workspace.me.owner}-${lower(data.coder_workspace.me.name)}-home"
}
resource "docker_volume" "usr_volume" {
  name = "coder-${data.coder_workspace.me.owner}-${lower(data.coder_workspace.me.name)}-usr"
}
resource "docker_volume" "var_volume" {
  name = "coder-${data.coder_workspace.me.owner}-${lower(data.coder_workspace.me.name)}-var"
}
resource "docker_volume" "etc_volume" {
  name = "coder-${data.coder_workspace.me.owner}-${lower(data.coder_workspace.me.name)}-etc"
}
resource "docker_volume" "opt_volume" {
  name = "coder-${data.coder_workspace.me.owner}-${lower(data.coder_workspace.me.name)}-opt"
}
resource "docker_volume" "root_volume" {
  name = "coder-${data.coder_workspace.me.owner}-${lower(data.coder_workspace.me.name)}-root"
}

resource "docker_container" "workspace" {
  count = data.coder_workspace.me.start_count
  image = docker_image.docker_image.image_id
  # Uses lower() to avoid Docker restriction on container names.
  name = "coder-${data.coder_workspace.me.owner}-${lower(data.coder_workspace.me.name)}"
  # Hostname makes the shell more user friendly: coder@my-workspace:~$
  hostname = lower(data.coder_workspace.me.name)
  dns      = ["1.1.1.1"]
  # Use the docker gateway if the access URL is 127.0.0.1
  command = [
    "sh", "-c", replace(coder_agent.main.init_script, "localhost", "host.docker.internal")]
  env = ["CODER_AGENT_TOKEN=${coder_agent.main.token}"]
  runtime = "sysbox-runc"
  host {
    host = "host.docker.internal"
    ip   = "host-gateway"
  }
  volumes {
    container_path = "/home/"
    volume_name    = docker_volume.home_volume.name
    read_only      = false
  }
  volumes {
    container_path = "/usr/"
    volume_name    = docker_volume.usr_volume.name
    read_only      = false
  }
  volumes {
    container_path = "/var/"
    volume_name    = docker_volume.var_volume.name
    read_only      = false
  }
  volumes {
    container_path = "/etc/"
    volume_name    = docker_volume.etc_volume.name
    read_only      = false
  }
  volumes {
    container_path = "/opt/"
    volume_name    = docker_volume.opt_volume.name
    read_only      = false
  }
  volumes {
    container_path = "/root/"
    volume_name    = docker_volume.root_volume.name
    read_only      = false
  }
}
