# Practica 2, Consul en VM

## Vagrant

```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|


  config.vm.define :clienteUbuntu do |clienteUbuntu|
    clienteUbuntu.vm.box = "bento/ubuntu-22.04"
    clienteUbuntu.vm.network :private_network, ip: "192.168.100.2"
    clienteUbuntu.vm.hostname = "clienteUbuntu"
  end

  config.vm.define :servidorUbuntu do |servidorUbuntu|
    servidorUbuntu.vm.box = "bento/ubuntu-22.04"
    servidorUbuntu.vm.network :private_network, ip: "192.168.100.3"
    servidorUbuntu.vm.hostname = "servidorUbuntu"
  end
end
```

## Comandos

En la VM servidor ejecutar:

```bash
# https://developer.hashicorp.com/consul/install
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install consul
```

```bash
consul -v
```

```bash
consul agent -ui -dev -bind=192.168.100.3 -client=0.0.0.0 -data-dir=.
```

Consul debería ejecutarse en [http://192.168.100.3:8500/ui/dc1/services](http://192.168.100.3:8500/ui/dc1/services)

Abrir otro terminal conectado a la VM servidor y ejecutar:

```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - && apt install nodejs -y
node -v
npm -v
```

```bash
git clone https://github.com/omondragon/consulService
cd consulService/app
npm install consul
npm install express
```

Abrir un 3 terminales conectados a la VM servidor y ejecutar:

```bash
# Termina 1
cd consulService/app
node index.js 3000
```

```bash
# Termina 2
cd consulService/app
node index.js 3001
```

```bash
# Termina 3
cd consulService/app
node index.js 3002
```

En una terminal del host ejecutar:

```bash
curl http://192.168.100.3:8500/v1/agent/services
```

---

Ejecutar los siguientes comandos desde un terminal conectado a la VM servidor:

```bash
dig @127.0.0.1 -p 8600 mymicroservice.service.consul
```

```bash
dig @127.0.0.1 -p 8600 mymicroservice.service.consul SRV
```

```bash
curl http://localhost:8500/v1/catalog/service/mymicroservice
```

```bash
curl 'http://localhost:8500/v1/health/service/mymicroservice?passing'
```

