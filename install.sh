#!/bin/bash

# # Preguntar al usuario el nombre del proyecto
# read -p "Ingrese el nombre del proyecto: " PROJECT_NAME

# # Verificar que el usuario ingresó un nombre
# if [ -z "${PROJECT_NAME}" ]; then
#     echo "Error: No se ingresó un nombre de proyecto."
#     exit 1
# fi

PROJECT_NAME=${PWD##*/}

echo "Work directory: ${PROJECT_NAME}"

sleep 5

docker context use default

docker info > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Docker is not running."
    exit 1
fi

echo "Creating Laravel project.  Docker is installed and running."
sleep 5

docker run --rm \
    --pull=always \
    -v "$(pwd)":/opt \
    -w /opt \
    laravelsail/php84-composer:latest \
    bash -c "laravel new ${PROJECT_NAME} --no-interaction && cd ${PROJECT_NAME} && php ./artisan sail:install --with=none"
#     bash -c "laravel new ${PROJECT_NAME} --no-interaction && cd ${PROJECT_NAME} && php ./artisan sail:install --with=mysql,redis,meilisearch,mailpit,selenium"

if [ "mysql redis meilisearch mailpit selenium" == "none" ]; then
    ./vendor/bin/sail build
else
    ./vendor/bin/sail pull mysql redis meilisearch mailpit selenium
    ./vendor/bin/sail build
fi

echo "Laravel project created."
sleep 5

CYAN='\033[0;36m'
LIGHT_CYAN='\033[1;36m'
BOLD='\033[1m'
NC='\033[0m'

if command -v doas &>/dev/null; then
    SUDO="doas"
elif command -v sudo &>/dev/null; then
    SUDO="sudo"
    echo "SUDO available"
else
    echo "Neither sudo nor doas is available. Exiting."
    exit 1
fi

echo -e "${BOLD}Setting permissions...${NC}"
echo ""
sleep 5

if $SUDO -n true 2>/dev/null; then
    $SUDO chown -R "$USER":"$USER" .
    echo -e "${BOLD}Get started with:${NC} cd ${PROJECT_NAME} && sleep 2"
    # echo -e "${BOLD}Get started with:${NC} cd ${PROJECT_NAME} && ./vendor/bin/sail up"
else
    echo -e "${BOLD}Please provide your password so we can make some final adjustments to your application's permissions.${NC}"
    echo ""
    $SUDO chown -R "$USER":"$USER" .
    echo ""
    echo -e "${BOLD}Thank you! We hope you build something incredible. Dive in with:${NC} sleep 2"
    # echo -e "${BOLD}Thank you! We hope you build something incredible. Dive in with:${NC} cd ${PROJECT_NAME} && ./vendor/bin/sail up"
fi

echo Copying files...
sleep 5

rm docker-compose.yml

mv ../.vscode .
mv ../docker .
mv ../.env_docker .
mv ../.gitignore .
mv ../docker-compose.yml .
mv ../Dockerfile .

echo "Files copied."
sleep 5

# put all variables that are in .env_docker inside .env
cat .env_docker >> .env

# ...existing code...
docker compose up --build



