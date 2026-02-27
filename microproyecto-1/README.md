# Microproyecto 1

Lanzar VMs. Se utiliza File, Ansible y Shell para el aprovisionamiento:

```bash
vagrant up
```

Se lanzan 3 VMs con:

- **nodoUno:** `192.168.100.6`. Agente servidor del cluster de Consul
- **nodoDos:** `192.168.100.7`. Agente cliente del cluster de Consul
- **balanceador:** `192.168.100.8`. Balanceador de carga con HAProxy

Iniciar instancias de la aplicación web:

```bash
vagrant ssh nodoUno
start-node-server 3000
```

```bash
vagrant ssh nodoDos
start-node-server 3000
```

Visualizar interfaces de Consul y HAProxy:

- Consul UI: http://192.168.100.6:8500/ui/
- HAProxy stats: http://192.168.100.8:1936
