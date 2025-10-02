#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/colors.sh"

# Проверка прав root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        print_error "Этот скрипт должен запускаться с правами root. Используйте sudo!"
        exit 1
    fi
}

# Функция для проверки успешности выполнения команды
check_success() {
    if [ $? -eq 0 ]; then
        print_success "$1"
    else
        print_error "$2"
        exit 1
    fi
}

# Подтверждение действия
confirm_action() {
    local message="$1"
    read -p "$(echo -e ${YELLOW}"$message (y/n): "${NC})" response
    [[ "$response" =~ ^[Yy]$ ]]
}

# Ввод с проверкой
input_with_check() {
    local prompt="$1"
    local var_name="$2"
    local default_value="$3"
    
    if [ -n "$default_value" ]; then
        prompt="$prompt [по умолчанию: $default_value]: "
    else
        prompt="$prompt: "
    fi
    
    read -p "$(echo -e ${YELLOW}"$prompt"${NC})" input_value
    eval "$var_name=\"${input_value:-$default_value}\""
}