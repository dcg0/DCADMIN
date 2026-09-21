#!/usr/bin/env bash
set -Eeuo pipefail

APP_DIR="${DCADMIN_DIR:-$HOME/dcadmin}"
PORT="${DCADMIN_PORT:-8080}"
DB_PASSWORD="${DCADMIN_DB_PASSWORD:-$(openssl rand -hex 24 2>/dev/null || head -c 24 /dev/urandom | od -An -tx1 | tr -d ' \n')}"
ROOT_PASSWORD="${DCADMIN_ROOT_PASSWORD:-$(openssl rand -hex 24 2>/dev/null || head -c 24 /dev/urandom | od -An -tx1 | tr -d ' \n')}"

fail(){ echo "ERROR: $*" >&2; exit 1; }
command -v docker >/dev/null 2>&1 || fail "Docker no está instalado. Instala Docker Desktop o Docker Engine y vuelve a ejecutar este archivo."
docker compose version >/dev/null 2>&1 || fail "Docker Compose v2 no está disponible. Actualiza Docker Desktop o instala el plugin docker compose."
mkdir -p "$APP_DIR/documents" "$APP_DIR/custom" "$APP_DIR/db"
cat > "$APP_DIR/.env" <<EOF
DCADMIN_PORT=$PORT
MYSQL_DATABASE=dolidb
MYSQL_USER=dolibarr
MYSQL_PASSWORD=$DB_PASSWORD
MYSQL_ROOT_PASSWORD=$ROOT_PASSWORD
EOF
cat > "$APP_DIR/docker-compose.yml" <<'YAML'
services:
  mariadb:
    image: mariadb:11.4
    restart: unless-stopped
    command: --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
    environment:
      MYSQL_DATABASE: ${MYSQL_DATABASE}
      MYSQL_USER: ${MYSQL_USER}
      MYSQL_PASSWORD: ${MYSQL_PASSWORD}
      MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
    volumes:
      - ./db:/var/lib/mysql
    healthcheck:
      test: ["CMD-SHELL", "mariadb-admin ping -h localhost -u root -p$${MYSQL_ROOT_PASSWORD} --silent"]
      interval: 10s
      timeout: 5s
      retries: 20
  dcadmin:
    image: dolibarr/dolibarr:latest
    restart: unless-stopped
    depends_on:
      mariadb:
        condition: service_healthy
    environment:
      DOLI_DB_HOST: mariadb
      DOLI_DB_NAME: ${MYSQL_DATABASE}
      DOLI_DB_USER: ${MYSQL_USER}
      DOLI_DB_PASSWORD: ${MYSQL_PASSWORD}
      DOLI_URL_ROOT: http://localhost:${DCADMIN_PORT}
    ports:
      - "${DCADMIN_PORT}:80"
    volumes:
      - ./documents:/var/www/documents
      - ./custom:/var/www/html/custom
YAML
chmod 600 "$APP_DIR/.env"
( cd "$APP_DIR" && docker compose up -d )
cat > "$APP_DIR/ACCESO.txt" <<EOF
DCADMIN está iniciando en: http://localhost:$PORT
Carpeta de datos: $APP_DIR
Usuario de base de datos: dolibarr
Las credenciales están guardadas en: $APP_DIR/.env
No compartas .env ni borres la carpeta db.
EOF
printf '\nDCADMIN instalado. Abre http://localhost:%s\nDatos en: %s\n' "$PORT" "$APP_DIR"
