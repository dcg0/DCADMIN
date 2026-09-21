# Instalación de DCADMIN

## Ruta recomendada: instalador único con Docker

La forma más sencilla para una oficina es utilizar Docker Desktop en Windows o Docker Engine + Docker Compose en Linux. El instalador prepara la carpeta de trabajo, crea credenciales aleatorias para la base de datos, genera el archivo de configuración y levanta DCADMIN con almacenamiento persistente.

Descargue `install-dcadmin.sh` desde este repositorio y ejecútelo en una terminal:

```bash
bash install-dcadmin.sh
```

En Linux, si el archivo ya está descargado localmente, también puede ejecutarlo con:

```bash
chmod +x install-dcadmin.sh
./install-dcadmin.sh
```

Después abra `http://localhost:8080` en el mismo equipo. En la primera ejecución, complete el asistente inicial de Dolibarr y cambie inmediatamente la contraseña administrativa. El instalador no instala Docker por sí solo: esta decisión evita modificar silenciosamente el sistema operativo y permite que el administrador use la versión oficial de Docker Desktop o Docker Engine.

## Requisitos

Se requiere Docker Desktop actualizado en Windows o macOS, o Docker Engine y Docker Compose v2 en Linux. Reserve al menos 2 GB de memoria para los contenedores y espacio suficiente para documentos y respaldos. Para uso en red local, permita el puerto 8080 en el firewall únicamente dentro de la red de confianza.

## Operación diaria

Inicie el sistema desde la carpeta de despliegue con `docker compose up -d` y deténgalo con `docker compose stop`. Para consultar el estado use `docker compose ps` y para revisar incidencias use `docker compose logs --tail=100`. No elimine los volúmenes `dcadmin_db` ni `dcadmin_documents`: contienen la base de datos y los documentos de negocio.

## Respaldo

Realice respaldos periódicos de la base de datos y de la carpeta de documentos. Una práctica mínima es ejecutar `docker compose exec -T mariadb mariadb-dump -u root -p"$MYSQL_ROOT_PASSWORD" dolidb > dolidb-$(date +%F).sql` y copiar también el volumen de documentos. Guarde los respaldos fuera del equipo principal y pruebe una restauración antes de depender de ellos.

## Acceso desde otra computadora

En la misma red, sustituya `localhost` por la dirección IP del equipo que ejecuta Docker, por ejemplo `http://192.168.1.20:8080`. No exponga este puerto directamente a internet sin HTTPS, autenticación fuerte, copias de seguridad y un proxy seguro.

## Solución de problemas

Si el puerto 8080 está ocupado, cambie el lado izquierdo de `8080:80` en `docker-compose.yml`, por ejemplo a `8088:80`, y abra `http://localhost:8088`. Si la base de datos aún está iniciando, espere unos segundos y vuelva a cargar. Si olvidó una contraseña, no borre el volumen: consulte el procedimiento de recuperación de Dolibarr o contacte al administrador del sistema.

## Alcance del portal público

GitHub Pages publica la guía y la página de acceso, pero no ejecuta PHP ni aloja MySQL/MariaDB. La operación real se ejecuta en Docker, un servidor PHP administrado o un servicio SaaS compatible.
