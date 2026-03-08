# Práctica de Docker

Todo el código a continuación se ejecuta desde dos máquinas virtuales con las direcciones IP `192.168.100.3` y `192.168.100.2`.

## 1. Contenedor con sitio WEB

> Dockerfile y archivos en `/web`.

Ejecutar un contenedor con la imagen [seb4sbit/ubuntuweb](https://hub.docker.com/repository/docker/seb4sbit/ubuntuweb/general):

```bash
docker run --name webprueba -d -p 9000:80 seb4sbit/ubuntuweb:v2
```

Después, desde el host, acceder desde un navegador a la URL [http://192.168.100.3:9000](http://192.168.100.3:9000/).

## 2. Contenedor para Data Science

> Dockerfile y archivos en `/data_science`.

> Fuente: [Make Your Data Science Life Easy With Docker](https://towardsdatascience.com/make-your-data-science-life-easy-with-docker-c3e1fc0dee59/)

Construir imagen de Docker y ejecutar un contenedor para acceder a un Notebook de Jupyter desde la dirección [http://192.168.100.3:8888](http://192.168.100.3:8888/).

```bash
cd data_science
docker build -t notebook_demo .
docker run --name jupyterserver -d -p 8888:8888 notebook_demo
docker logs jupyterserver
```

Copia el script en `script.py` en el notebook para probar las librerías.

## 3. Volúmenes de Docker

> Archivos en `/docker_volume`.

> Fuente: [Usando Volúmenes En Docker](https://ricardogeek.com/usando-volumenes-en-docker/)

Ejecutar un contenedor con la opción `-v` para crear un volúmen para compartir archivos entre el host y el contenedor y realizar una prueba editando el archivo desde el contenedor y después consultando el contenido desde el host:

```bash
# Docker container
docker run --rm -it -v ./docker_volume:/home/ubuntu/docker_volume ubuntu /bin/bash
echo "Hola mundo a las $(date +"%Y-%m-%d %H:%M:%S")" > /home/ubuntu/docker_volume/hello.txt
```

```bash
# VM
cat docker_volume/hello.txt
```

## 4. ml-jupyter-python3

Clonar el repositorio [https://github.com/asashiho/ml-jupyter-python3.git](https://github.com/asashiho/ml-jupyter-python3.git) y construir la imagen de Docker a partir del Dockerfile. Después ejecutar el comando para iniciar el servidor de Jupyter.

> Comentar la línea `libav-tools \` en el Dockerfile (línea ~16). En el Dockerfile se debe de cambiar en la instlacion de librerías para data science en la linea 31 cambiar `sklearn` por `scikit-learn`.

```bash
cd ml-jupyter-python3
docker build -t ml-jupyter-python3 .
docker run -p 8888:8888 -p 6006:6006 -v ./notebooks:/notebooks -it --rm ml-jupyter-python3
```

Acceder al notebook de Jupyter desde la dirección [http://192.168.100.3:8888](http://192.168.100.3:8888/).

---

## 7. Docker + Flask (extra)

Clonar el repositorio [https://github.com/omondragon/docker-flask-example/tree/master](https://github.com/omondragon/docker-flask-example/tree/master) y construir la magen a partir del Dockerfile. Después ejecutar el comando para iniciar la aplicación de Flask.

```bash
cd docker-flask-example
docker build -t docker-flask-example .
docker run --rm -it -p 5000:5000 docker-flask-example
```

Acceder a la aplicación de Flask desde la dirección [http://192.168.100.3:5000](http://192.168.100.3:5000/).


# Practica de Docker Compose

Todo el código a continuación se ejecuta desde dos máquinas virtuales con las direcciones IP `192.168.100.3` y `192.168.100.2`.

## 1. ¿Cómo Docker Compose facilita el trabajo de implementación frente a Docker básico?

Docker Compose ofrece varias ventajas frente al uso básico de Docker cuando trabajamos con múltiples contenedores al permitirnos gestionar los diferentes contenedores de una aplicación como un grupo y realizar operaciones como levantar, detener o eliminar todos los contenedores a la vez. Además, permite conectar más facilmente los contenedores dentro una red para que puedan comunicarse entre ellos, por ejemplo, una aplicación WEB en un contenedor se puede comunicar con una base de datos en otro contenedor.

Otra ventaja es la posibilidad de escalar el número de contenedores de una misma imagen para responder a la posible demanda de carga de trabajo bajo la que se encuentra una aplicación. Otra alternativa es deplegar varios contenedores basados en una misma imagen o Dockerfile con diferentes configuración, por ejemplo, un contenedor de producción y uno de desarrollo.

## 2. Servidor FTP con Docker Compose

> docker-compose y archivos en `/ftp_server`.

> Verificar que el servicio `vsftpd` este apagado en el host con `sudo service vsftpd stop`.

> Consultar este foro si no se puede isntalar FileZilla en Windows: [FileZilla is being blocked by Windows' Smart App Control](https://forum.filezilla-project.org/viewtopic.php?t=64460).

Crear un `docker-compose.yml` con la configuración del contenedor con FTP y levantar el contenedor con el siguiente comando:

```bash
cd ftp_server
docker compose up -d
```

Desde el host (local no la VM) abrir un cliente FTP como FileZilla y conectarse al contenedor. Después probar la subida y descarga de archivos. Acceder con estas credenciales:

- Usuario: `user`
- Contraseña: `password`
- Servidor: `192.168.100.3`
- Puerto: `21`

En el volúmen `./files` de la VM se almacenan los archivos cargados desde FileZilla al contenedor con FTP.

```bash
ls files/
```

---

## 5. Docker Compose en aplicación (extra)

> docker-compose y archivos en `/composetest`.

> Fuente: [Docker Compose Quickstart](https://docs.docker.com/compose/gettingstarted/).

Seguir la guía [Docker Compose Quickstart](https://docs.docker.com/compose/gettingstarted/) para construir una aplicación de Flask más Redis y el archivos `docker-compose.yml` para manejar ambos contenedores. Después iniciar los contenedores y probar la aplicación en la dirección [http://192.168.100.3:8000](http://192.168.100.3:8000).

```bash
cd composetest
docker compose up -d
```

