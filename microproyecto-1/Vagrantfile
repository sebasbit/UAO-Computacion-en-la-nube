# -*- mode: ruby -*-
# vi: set ft=ruby :

# Ansible para Windows.

$install_ansible = <<-ANSIBLE
sudo apt install software-properties-common -y
sudo add-apt-repository --yes --update ppa:ansible/ansible -y
sudo apt install ansible -y
ANSIBLE

Vagrant.configure("2") do |config|
  if Vagrant.has_plugin? "vagrant-vbguest"
    config.vbguest.no_install = true
    config.vbguest.auto_update = false
    config.vbguest.no_remote = true
  end

  config.vm.define :nodoUno do |nodoUno|
    nodoUno.vm.box = "bento/ubuntu-22.04"
    nodoUno.vm.hostname = "nodoUno"
    nodoUno.vm.network :private_network, ip: "192.168.100.6"

    nodoUno.vm.provision "file", source: "files/server.js", destination: "/tmp/server.js"
    nodoUno.vm.provision "file", source: "files/consul_server.hcl", destination: "/tmp/consul.hcl"
    nodoUno.vm.provision "file", source: "files/consul.service", destination: "/tmp/consul.service"
    nodoUno.vm.provision "shell", inline: $install_ansible
    nodoUno.vm.provision "ansible_local" do |ansible|
      ansible.playbook = "playbooks/server/playbook.yml"
    end
  end

  config.vm.define :nodoDos do |nodoDos|
    nodoDos.vm.box = "bento/ubuntu-22.04"
    nodoDos.vm.hostname = "nodoDos"
    nodoDos.vm.network :private_network, ip: "192.168.100.7"

    nodoDos.vm.provision "file", source: "files/server.js", destination: "/tmp/server.js"
    nodoDos.vm.provision "file", source: "files/consul_client.hcl", destination: "/tmp/consul.hcl"
    nodoDos.vm.provision "file", source: "files/consul.service", destination: "/tmp/consul.service"
    nodoDos.vm.provision "shell", inline: $install_ansible
    nodoDos.vm.provision "ansible_local" do |ansible|
      ansible.playbook = "playbooks/server/playbook.yml"
    end
  end

  config.vm.define :balanceador do |balanceador|
    balanceador.vm.box = "bento/ubuntu-22.04"
    balanceador.vm.hostname = "balanceador"
    balanceador.vm.network :private_network, ip: "192.168.100.8"

    balanceador.vm.provision "file", source: "files/503.http", destination: "/tmp/503.http"
    balanceador.vm.provision "file", source: "files/haproxy.cfg", destination: "/tmp/haproxy.cfg"
    balanceador.vm.provision "shell", inline: $install_ansible
    balanceador.vm.provision "ansible_local" do |ansible|
      ansible.playbook = "playbooks/load_balancer/playbook.yml"
    end
  end
end
