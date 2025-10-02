#!/bin/bash

# Конфигурация
CONFIG_FILE="/root/server-setup.conf"
DOMAIN=""
BACKEND_DOMAIN=""
REPO_URL=""
USER_EMAIL=""

load_config() {
    if [ -f "$CONFIG_FILE" ]; then
        source "$CONFIG_FILE"
        return 0
    fi
    return 1
}

save_config() {
    cat > "$CONFIG_FILE" << EOF
DOMAIN="$DOMAIN"
BACKEND_DOMAIN="$BACKEND_DOMAIN"
REPO_URL="$REPO_URL"
USER_EMAIL="$USER_EMAIL"
EOF
}

print_config() {
    echo "Текущая конфигурация:"
    echo "  Домен: $DOMAIN"
    echo "  Бэкенд: $BACKEND_DOMAIN"
    echo "  Репозиторий: $REPO_URL"
    echo "  Email: $USER_EMAIL"
}