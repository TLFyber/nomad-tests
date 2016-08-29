# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<SCRIPT
# Update apt and get dependencies
sudo apt-get update
sudo apt-get install -y unzip curl wget vim

# Download Nomad
echo Fetching Nomad...
cd /tmp/
curl -sSL https://releases.hashicorp.com/nomad/0.4.0/nomad_0.4.0_linux_amd64.zip -o nomad.zip

echo Installing Nomad...
unzip nomad.zip
sudo chmod +x nomad
sudo mv nomad /usr/bin/nomad

sudo mkdir -p /etc/nomad.d
sudo chmod a+w /etc/nomad.d

SCRIPT

Vagrant.configure(2) do |config|
  config.vm.box = "puphpet/ubuntu1404-x64"
  config.vm.provision "shell", inline: $script, privileged: false
  config.vm.provision "docker" # Just install it
  # config.vm.provision "file", source: "nomad-agent", destination: "/tmp/nomad-agent"
  # config.vm.provision "shell", inline: "docker build -t nomad-agent /tmp/nomad-agent"
  config.vm.provision "shell", inline: "apt-get install -y python-pip"
  config.vm.provision "shell", inline: "pip install supervisor"

  server_ip = "192.168.50.2"

  config.vm.define "nomad-server" do |server|
    config.vm.provision "file", source: "supervisor-server.conf", destination: "/tmp/supervisor.conf"
    config.vm.provision "shell", inline: "supervisord -c /tmp/supervisor.conf", privileged: false
    server.vm.hostname = "nomad-server"
    server.vm.network "private_network", ip: server_ip
    server.vm.provision "file", source: "nomad-server.conf", destination: "/tmp/nomad-server.conf"
  end

  # see https://github.com/hashicorp/nomad/issues/1080 for reasons why sharing /tmp is needed
  # client_base_cmd = "docker run -v '/tmp:/tmp' --volume='/var/run/docker.sock:/var/run/docker.sock' -d nomad-agent -servers=192.168.50.2 -data-dir=/tmp/nomad-client -log-level=debug"
  # client_base_cmd = "nomad agent -client -servers=192.168.50.2 -data-dir=/tmp/nomad-client-data -log-level=debug"

  1.upto(3) do |count|
    config.vm.define "nomad-client-#{count}" do |server|
      config.vm.provision "shell", inline: "sudo usermod -a -G docker vagrant"
      config.vm.provision "file", source: "supervisor-client.conf", destination: "/tmp/supervisor.conf"
      config.vm.provision "shell", inline: "supervisord -c /tmp/supervisor.conf", privileged: false
      config.vm.provision "file", source: "drainable-app", destination: "/tmp/drainable-app"
      config.vm.provision "shell", inline: "docker build -t library/drainable-app /tmp/drainable-app"

      server.vm.hostname = "nomad-client-#{count}"
      server.vm.network "private_network", ip: "192.168.50.#{count + 2}"
      # server.vm.provision "shell", inline: "#{client_base_cmd} -node-class=web"
    end
  end

  config.vm.define "load-balancer" do |server|
    config.vm.provision "file", source: "supervisor-client.conf", destination: "/tmp/supervisor.conf"
    config.vm.provision "shell", inline: "supervisord -c /tmp/supervisor.conf", privileged: false
    server.vm.hostname = "nomad-client-4"
    server.vm.network "private_network", ip: "192.168.50.6"
    # server.vm.provision "shell", inline: "#{client_base_cmd} -node-class=load-balancer"
  end

  # Increase memory for Parallels Desktop
  config.vm.provider "parallels" do |p, o|
    p.memory = "1024"
  end

  # Increase memory for Virtualbox
  config.vm.provider "virtualbox" do |vb|
        vb.memory = "1024"
  end

  # Increase memory for VMware
  ["vmware_fusion", "vmware_workstation"].each do |p|
    config.vm.provider p do |v|
      v.vmx["memsize"] = "1024"
    end
  end
end
