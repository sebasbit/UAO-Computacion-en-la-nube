# Microproyecto 2

## 1. Implementación de clúster de Kubernetes en Azure

> En la configuración de grupos de nodos para el agentpool y el grupo personalizado configurar 1 y 2 en el recuento mínimo y máximo. Para el tipo de máquina seleccionar `D2s_v4` y en zona de disponibilidad no marcar ninguna.

> La configuración de Kubernetes para el proyecto está en el archivo [aks-store-quickstart.yaml](./aks-store-quickstart/aks-store-quickstart.yaml).

Crear un clúster de Kubernetes usando AKS, con el nombre `microproyectoAksCluster` y el grupo de recursos `microproyectoAksResourceGroup`. Una vez creado, desde Azure CLI cargar el archivo [aks-store-quickstart.yaml](./aks-store-quickstart/aks-store-quickstart.yaml) y ejecutar:

```bash
az aks get-credentials --resource-group microproyectoAksResourceGroup --name microproyectoAksCluster
kubectl get nodes
kubectl apply -f aks-store-quickstart.yaml
```

Validar los pods y obtener la URL del frontend para acceder a la aplicación:

```bash
kubectl get pods
kubectl get service store-front --watch
```

_(opcional)_ Eliminar los recursos una vez terminado el proyecto y detener o eliminar el clúster:

```bash
kubectl delete -f aks-store-quickstart.yaml
```

## 2. Aplicación de clasificación de imágenes en Azure

> La configuración de Kubernetes para el proyecto está en el archivo [kubermatic-dl-aks.yaml](./app/kubermatic-dl-aks.yaml).

> La imágen de Docker utilizada en el despliegue está en el repositorio de Docker Hub [seb4sbit/kubermatic-dl](https://hub.docker.com/repository/docker/seb4sbit/kubermatic-dl/tags).

Con el clúster de Kubernetes creado en el punto anterior, desde Azure CLI cargar el archivo [kubermatic-dl-aks.yaml](./app/kubermatic-dl-aks.yaml) y ejecutar:

```bash
az aks get-credentials --resource-group microproyectoAksResourceGroup --name microproyectoAksCluster
kubectl get nodes
kubectl apply -f kubermatic-dl-aks.yaml
```

Validar los pods y obtener la URL del frontend para acceder a la aplicación:

```bash
kubectl get pods
kubectl get service kubermatic-dl-service --watch
```

Validar desde consola el funcionamiento del servicio desplegado:

```bash
curl -o horse.jpg https://opensource.com/sites/default/files/uploads/horse.jpg
curl -o dog.jpg https://opensource.com/sites/default/files/uploads/dog.jpg
DL_SERVICE_IP=...
curl -X POST -F img=@horse.jpg "http://$DL_SERVICE_IP/predict"
curl -X POST -F img=@dog.jpg "http://$DL_SERVICE_IP/predict"
```

_(opcional)_ Eliminar los recursos una vez terminado el proyecto y detener o eliminar el clúster:

```bash
kubectl delete -f kubermatic-dl-aks.yaml
```

_(opcional)_ Para crear la imagen de Docker copiar la carpeta `app/` y ejecutar:

```bash
docker build -t kubermatic-dl:latest .
docker tag kubermatic-dl:latest seb4sbit/kubermatic-dl:latest
docker push seb4sbit/kubermatic-dl:latest
```

## 3. Aplicación de su interés en Azure

> La configuración de Kubernetes para el proyecto está en el archivo [atari-aks.yaml](./atari/atari-aks.yaml).

> La imágen de Docker utilizada en el despliegue está en el repositorio de Docker Hub [seb4sbit/atari-game](https://hub.docker.com/repository/docker/seb4sbit/atari-game/tags).

Con el clúster de Kubernetes creado en el punto anterior, desde Azure CLI cargar el archivo [atari-aks.yaml](./atari/atari-aks.yaml) y ejecutar:

```bash
az aks get-credentials --resource-group microproyectoAksResourceGroup --name microproyectoAksCluster
kubectl get nodes
kubectl apply -f atari-aks.yaml
```

Validar los pods y obtener la URL del frontend para acceder a la aplicación:

```bash
kubectl get pods
kubectl get service atari-service --watch
```

_(opcional)_ Eliminar los recursos una vez terminado el proyecto y detener o eliminar el clúster:

```bash
kubectl delete -f atari-aks.yaml
```

_(opcional)_ Para crear la imagen de Docker copiar la carpeta `atari/` y ejecutar:

```bash
docker build -t atari-game:latest .
docker tag atari-game:latest seb4sbit/atari-game:latest
docker push seb4sbit/atari-game:latest
```

## 4. Horizontal Autoescaling en Kubernetes _(extra)_

Levantar una máquina virtual, acceder por SSH, instalar Docker y Minikube y seguir las siguientes instrucciones:

- Para crear la imagen de Docker copiar el contenido de la carpeta `hpa/` y ejecutar:

```bash
docker build -t flask-cpu-stress:v1 .
```

- Iniciar minikube con el plugin metrics-server:

```bash
minikube start
minikube addons enable metrics-server
```
- Aplicar la configuración desde el archivo [k8s-setup.yaml](./hpa/k8s-setup.yaml):

```bash
kubectl apply -f k8s-setup.yaml
kubectl get pods
kubectl get services
kubectl top pods
```

- Ejecutar el comando para observar la información del HAP, enfocarse en el consumo y el número de replicas:

```bash
kubectl get hpa --watch
```

- Desde una terminal nueva en la VM ejecutar el comando para acceder al servicio de minikube desde el host:

```bash
kubectl port-forward --address 0.0.0.0 service/flask-service 30001:80
```

- Finalmente, desde el host ejecutar las pruebas con Artillery con el archivo [artillery.yml](./hpa/artillery.yml):

```bash
artillery run artillery.yml
```

_(opcional)_ Eliminar los recursos una vez terminado el proyecto y detener o eliminar el clúster:

```bash
kubectl delete -f k8s-setup.yaml
minikube stop
```
