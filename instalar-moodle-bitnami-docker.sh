#!/bin/bash
# PASO 1: Obtener imagen 
docker pull bitnami/moodle:latest

# PASO 2: Crear red 
docker network create moodle-network

# PASO 3: Crear volumen para BBDD MariaDB
docker volume create --name mariadb_data

# PASO 4: Ejecutar contenedor para BBDD MariaDB
docker run -d --name mariadb \
  -p 3306:3306 \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env MARIADB_USER=bn_moodle \
  --env MARIADB_PASSWORD=bitnami \
  --env MARIADB_DATABASE=bitnami_moodle \
  --network moodle-network \
  --volume mariadb_data:/bitnami/mariadb \
  bitnami/mariadb:latest

# PASO 5: Crear volumen para Moodle
docker volume create --name moodle_data

# PASO 6: Ejecutar contenedor para Moodle
docker run -d --name moodle \
  -p 8080:8080 -p 8443:8443 \
  --env ALLOW_EMPTY_PASSWORD=yes \
  --env MOODLE_DATABASE_USER=bn_moodle \
  --env MOODLE_DATABASE_PASSWORD=bitnami \
  --env MOODLE_DATABASE_NAME=bitnami_moodle \
  --network moodle-network \
  --volume moodle_data:/bitnami/moodle \
  --volume moodledata_data:/bitnami/moodledata \
  bitnami/moodle:latest

