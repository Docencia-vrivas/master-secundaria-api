@echo off
echo "Paso 1: Obtener imagen"
docker pull bitnami/moodle:latest

echo "Paso 2: Crear red"
docker network create moodle-network

echo "Paso 3: Crear volumen para BBDD MariaDB"
docker volume create mariadb_data

echo "Paso 4: Ejecutar contenedor para BBDD MariaDB"
docker run -d --name mariadb ^
  --env ALLOW_EMPTY_PASSWORD=yes ^
  --env MARIADB_USER=bn_moodle ^
  --env MARIADB_PASSWORD=bitnami ^
  --env MARIADB_DATABASE=bitnami_moodle ^
  --network moodle-network ^
  --volume /d/mariadb_data:/bitnami/mariadb ^
  bitnami/mariadb:latest

echo "Paso 5: Crear volumen para Moodle"
docker volume create moodle_data

echo "Paso 6: Ejecutar contenedor para Moodle"
docker run -d --name moodle ^
  -p 8080:8080 -p 8443:8443 ^
  --env ALLOW_EMPTY_PASSWORD=yes ^
  --env MOODLE_DATABASE_USER=bn_moodle ^
  --env MOODLE_DATABASE_PASSWORD=bitnami ^
  --env MOODLE_DATABASE_NAME=bitnami_moodle ^
  --network moodle-network ^
  --volume /d/moodle_data:/bitnami/moodle ^
  --volume /d/moodledata_data:/bitnami/moodledata ^
  bitnami/moodle:latest

echo "Proceso completado."
pause
