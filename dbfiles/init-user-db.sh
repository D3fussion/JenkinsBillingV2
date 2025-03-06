#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    -- Crear el usuario
    CREATE USER billingapp WITH PASSWORD 'qwerty';
    -- Crear la base de datos
    CREATE DATABASE billingapp_db;
    -- Otorgar todos los privilegios sobre la base de datos
    GRANT ALL PRIVILEGES ON DATABASE billingapp_db TO billingapp;
EOSQL

# Conectarse a la base de datos recién creada y otorgar permisos sobre el esquema public
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "billingapp_db" <<-EOSQL
    GRANT ALL ON SCHEMA public TO billingapp;
    GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO billingapp;
    GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO billingapp;
EOSQL
