terraform {
  required_providers {
    coder = {
      source = "coder/coder"
    }
    docker = {
      source  = "kreuzwerker/docker"
    }
  }
}

provider "coder" {
}

provider "docker" {
  host = local.docker_host[data.coder_parameter.docker_host.value].host
}

data "coder_workspace" "me" {
  
}

locals {
  docker_host = {
    "octavia" = {
      "name"="Octavia (serv-octavia.cfouche.fr)"
      "host"="tcp://100.64.0.7:2375"
      "arch"="amd64"
      "icon"="https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/ovh.png"
    }
    "ivara" = {
      "name"="Ivara (serv-ivara.cfouche.fr)"
      "host"="tcp://100.64.0.1:2375"
      "arch"="arm64"
      "icon"="https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/oracle.png"
    }
    "nezha" = {
      "name"="Nezha (serv-nezha.cfouche.fr)"
      "host"="tcp://100.64.0.2:2375"
      "arch"="arm64"
      "icon"="https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/oracle.png"
    }
  }
  os = {
    "debian" = {
      "tag" = "debian"
      "name" = "Debian"
      "icon" = "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/debian.png"
    },
    "ubuntu" = {
      "tag" = "ubuntu"
      "name" = "Ubuntu"
      "icon" = "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/ubuntu.png"
    },
    "fedora" = {
      "tag" = "fedora"
      "name" = "Fedora"
      "icon" = "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/fedora.png"
    }
  }
  ide = {
    "vscode" = {
      "name" = "Visual Studio Code"
      "icon" = "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/vscode.png"
    },
    "fleet" = {
      "name" = "Fleet"
      "icon" = "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/jetbrains-fleet.png"
    }
  }

}

data "coder_parameter" "docker_host" {
    name = "host_machine" 
    default = "octavia"
    description = "The host machine to use for the workspace"
    display_name = "Host machine"
    ephemeral = false
    icon = "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/docker.png"
    mutable = false
    order = 1
    type = "string"
    option {
      name = local.docker_host["octavia"]["name"]
      value = "octavia"
      description = "Dédié OVH 4C/8T 32Go RAM amd64"
      icon = local.docker_host["octavia"]["icon"]
    }
    option {
      name = local.docker_host["ivara"]["name"]
      value = "ivara"
      description = "VM Oracle 4C/4T 24Go RAM arm64"
      icon = local.docker_host["ivara"]["icon"]
    }
    option {
      name = local.docker_host["nezha"]["name"]
      value = "nezha"
      description = "VM Oracle 4C/4T 24Go RAM arm64"
      icon = local.docker_host["nezha"]["icon"]
    }
}

data "coder_parameter" "os" {
    name = "os" 
    default = "debian"
    description = "The operating system to use for the workspace"
    display_name = "Operating system"
    ephemeral = false
    icon = "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/tux.png"
    mutable = false
    order = 2
    type = "string"
    option {
      name = local.os["debian"]["name"]
      value = "debian"
      icon = local.os["debian"]["icon"]
    }
    option {
      name = local.os["ubuntu"]["name"]
      value = "ubuntu"
      icon = local.os["ubuntu"]["icon"]
    }
    option {
      name = local.os["fedora"]["name"]
      value = "fedora"
      icon = local.os["fedora"]["icon"]
    }  
}

data "coder_parameter" "ide" {
    name = "ide" 
    default = jsonencode(["vscode","fleet"])
    description = "The IDE to use for the workspace"
    display_name = "IDE"
    ephemeral = false
    icon = "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/nextcloud-news.png"
    mutable = true
    order = 3
    type = "list(string)"

}

data "coder_parameter" "tailscale_url" {
    name = "tailscale_url" 
    default = "https://controlplane.tailscale.com"
    description = "Base URL of a control server (leave blank for no tailscale)))"
    display_name = "Tailscale URL"
    ephemeral = false
    icon = "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/tailscale.png"
    mutable = true
    order = 4
    type = "string"
}

data "coder_parameter" "tailscale_authkey" {
    name = "tailscale_authkey" 
    default = ""
    description = "The authkey to use for the workspace (leave blank for no tailscale)"
    display_name = "Tailscale Authkey"
    ephemeral = false
    icon = "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/tailscale.png"
    mutable = true
    order = 5
    type = "string"
}

data "docker_registry_image" "base" {
  name = "cf3005/ctdc-base:${data.coder_parameter.os.value}"
}

resource "docker_image" "main" {
  name = "coder-${data.coder_workspace.me.owner}-${lower(data.coder_workspace.me.name)}"
  keep_locally = true
  build {
    context = "./build"
    dockerfile = "${data.coder_parameter.os.value}.Dockerfile"
    build_args = {
      FLEET : contains(jsondecode(data.coder_parameter.ide.value), "fleet") ? "true" : "false"
      VSCODE : contains(jsondecode(data.coder_parameter.ide.value), "vscode") ? "true" : "false"
    }
    pull_parent = true
  }
  triggers = {
    base_image = data.docker_registry_image.base.sha256_digest
    ide_fleet = contains(jsondecode(data.coder_parameter.ide.value), "fleet") ? "true" : "false"
    ide_vscode = contains(jsondecode(data.coder_parameter.ide.value), "vscode") ? "true" : "false"
  } 
}

resource "coder_metadata" "docker_image" {
  resource_id = docker_image.main.id
  hide = false
  item {
    key   = "DOCKER IMAGE"
    value = docker_image.main.name
  }
  item {
    key = "WORKSPACE ID"
    value = data.coder_workspace.me.id
  }
  item {
    key = "TAILSCALE DOMAIN"
    value = "coder-${data.coder_workspace.me.owner}-${lower(data.coder_workspace.me.name)}.coder.internal"
  }
  item {
    key = "OS"
    value = local.os[data.coder_parameter.os.value].name
  }
}

resource "coder_agent" "main" {
  arch           = local.docker_host[data.coder_parameter.docker_host.value].arch
  os             = "linux"
  display_apps {
    port_forwarding_helper = true
    ssh_helper = true
    vscode = true
    vscode_insiders = false
    web_terminal = true
  }
  env = {
    GIT_AUTHOR_NAME = "${data.coder_workspace.me.owner}"
    GIT_COMMITTER_NAME = "${data.coder_workspace.me.owner}"
    GIT_AUTHOR_EMAIL = "${data.coder_workspace.me.owner_email}"
    GIT_COMMITTER_EMAIL = "${data.coder_workspace.me.owner_email}"
  }
  metadata {
    display_name = "CPU Usage"
    key          = "0_cpu_usage"
    script       = "coder stat cpu"
    interval     = 10
    timeout      = 1
  }

  metadata {
    display_name = "RAM Usage"
    key          = "1_ram_usage"
    script       = "coder stat mem"
    interval     = 10
    timeout      = 1
  }

  metadata {
    display_name = "CPU Usage (Host)"
    key          = "4_cpu_usage_host"
    script       = "coder stat cpu --host"
    interval     = 10
    timeout      = 1
  }

  metadata {
    display_name = "Memory Usage (Host)"
    key          = "5_mem_usage_host"
    script       = "coder stat mem --host"
    interval     = 10
    timeout      = 1
  }
}

resource "coder_app" "vscode" {
  count = contains(jsondecode(data.coder_parameter.ide.value), "vscode") ? 1 : 0
  agent_id = coder_agent.main.id
  slug = "vscode"
  display_name = "Visual Studio Code Server"
  external = false
  icon = "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/vscode.png"
  url = "http://localhost:8080"
}

resource "coder_app" "fleet" {
  count = contains(jsondecode(data.coder_parameter.ide.value), "fleet") ? 1 : 0
  agent_id = coder_agent.main.id
  slug = "fleet"
  display_name = "Fleet"
  icon = "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/jetbrains-fleet.png"
  command = "fleet launch workspace --version 1.22.113 -- --auth=accept-everyone --publish --enableSmartMode --workspacePort 13347; sleep 30;"
}

resource "coder_app" "tailscale" {
  agent_id = coder_agent.main.id
  slug = "tailscale"
  display_name = "Tailscale"
  icon = "https://cdn.jsdelivr.net/gh/walkxcode/dashboard-icons/png/tailscale-light.png"
  command = "${(data.coder_parameter.tailscale_url.value != "") && (data.coder_parameter.tailscale_authkey.value != "") ? "sudo /bin/tailscale up --login-server ${data.coder_parameter.tailscale_url.value} --authkey ${data.coder_parameter.tailscale_authkey.value} --hostname coder-${data.coder_workspace.me.owner}-${lower(data.coder_workspace.me.name)}; echo \"Tailscale started...\\nDomain : coder-${data.coder_workspace.me.owner}-${lower(data.coder_workspace.me.name)}.coder.internal\"; sleep 30;" : "echo \"Tailscale not configured...\\n\"; sleep 30;"}"
}

resource "coder_app" "FTP" {
  agent_id = coder_agent.main.id
  slug = "ftp"
  display_name = "FTP"
  icon = "/icon/folder.svg"
  command = "python3 -m pyftpdlib --directory=/ --port=21 --write -V"
}

resource "coder_metadata" "workspace_info" {
  count = data.coder_workspace.me.start_count
  resource_id = docker_container.workspace[0].id
  hide = false
  item {
    key = "IDE"
    value = !(contains(jsondecode(data.coder_parameter.ide.value), "fleet")) && !(contains(jsondecode(data.coder_parameter.ide.value), "vscode"))  ? "None" : join(", ", jsondecode(data.coder_parameter.ide.value))
  }
  item {
    key = "HOST"
    value = local.docker_host[data.coder_parameter.docker_host.value].name
  }
  item {
    key = "TAILSCALE URL"
    value = data.coder_parameter.tailscale_url.value == "" ? "None" : data.coder_parameter.tailscale_url.value
  }
  item {
    key = "TAILSCALE AUTHKEY"
    value = data.coder_parameter.tailscale_authkey.value == "" ? "None" : data.coder_parameter.tailscale_authkey.value
    sensitive = true
  }
}

resource "docker_container" "workspace" {
  count = data.coder_workspace.me.start_count
  image = docker_image.main.image_id
  name = "coder-${data.coder_workspace.me.owner}-${lower(data.coder_workspace.me.name)}"
  capabilities {
    add = ["NET_ADMIN","NET_RAW"]
  }
  command = ["sh", "-c", <<EOF
    # Start the Coder agent as the "coder" user
    # once systemd has started up
    sudo -u coder --preserve-env=CODER_AGENT_TOKEN /bin/bash -- <<-'    EOT' &
    while [[ ! $(systemctl is-system-running) =~ ^(running|degraded) ]]
    do
      echo "Waiting for system to start... $(systemctl is-system-running)"
      sleep 2
    done
    ${coder_agent.main.init_script}
    EOT

    exec /sbin/init

    EOF
    ,
  ]
  devices {
    host_path = "/dev/net/tun"
    container_path = "/dev/net/tun"
  }
  dns = ["100.100.100.100"]
  dns_search = ["coder.internal"]
  domainname = "coder-${data.coder_workspace.me.owner}-${lower(data.coder_workspace.me.name)}.internal"
  env = ["CODER_AGENT_TOKEN=${coder_agent.main.token}"]
  host {
    host = "host.docker.internal"
    ip   = "host-gateway"
  }
  hostname = "coder-${data.coder_workspace.me.owner}-${lower(data.coder_workspace.me.name)}"
  user = "0:0"
  runtime = "sysbox-runc"
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



#Volumes Resources

#home_volume
resource "docker_volume" "home_volume" {
  name = "coder-${data.coder_workspace.me.owner}-${lower(data.coder_workspace.me.name)}-home"
}
resource "coder_metadata" "home_volume" {
  resource_id = docker_volume.home_volume.id
  hide = true
  item {
    key   = "home_volume"
    value = docker_volume.home_volume.mountpoint
  }
}
#usr_volume
resource "docker_volume" "usr_volume" {
  name = "coder-${data.coder_workspace.me.owner}-${lower(data.coder_workspace.me.name)}-usr"
}
resource "coder_metadata" "usr_volume" {
  resource_id = docker_volume.usr_volume.id
  hide = true
  item {
    key   = "usr_volume"
    value = docker_volume.usr_volume.mountpoint
  }
}
#var_volume
resource "docker_volume" "var_volume" {
  name = "coder-${data.coder_workspace.me.owner}-${lower(data.coder_workspace.me.name)}-var"
}
resource "coder_metadata" "var_volume" {
  resource_id = docker_volume.var_volume.id
  hide = true
  item {
    key   = "var_volume"
    value = docker_volume.var_volume.mountpoint
  }
}
#etc_volume
resource "docker_volume" "etc_volume" {
  name = "coder-${data.coder_workspace.me.owner}-${lower(data.coder_workspace.me.name)}-etc"
}
resource "coder_metadata" "etc_volume" {
  resource_id = docker_volume.etc_volume.id
  hide = true
  item {
    key   = "etc_volume"
    value = docker_volume.etc_volume.mountpoint
  }
}
#opt_volume
resource "docker_volume" "opt_volume" {
  name = "coder-${data.coder_workspace.me.owner}-${lower(data.coder_workspace.me.name)}-opt"
}
resource "coder_metadata" "opt_volume" {
  resource_id = docker_volume.opt_volume.id
  hide = true
  item {
    key   = "etc_volume"
    value = docker_volume.opt_volume.mountpoint
  }
}
#root_volume
resource "docker_volume" "root_volume" {
  name = "coder-${data.coder_workspace.me.owner}-${lower(data.coder_workspace.me.name)}-root"
}
resource "coder_metadata" "root_volume" {
  resource_id = docker_volume.root_volume.id
  hide = true
  item {
    key   = "root_volume"
    value = docker_volume.root_volume.mountpoint
  }
}