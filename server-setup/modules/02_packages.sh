#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/../lib/helpers.sh"

install_packages() {
    print_step "2. УСТАНОВКА НЕОБХОДИМЫХ ПАКЕТОВ"
    
    print_info "Установка nginx, certbot, git, docker и ufw..."
    apt install -y nginx certbot python3-certbot-nginx git docker.io docker-compose ufw
    check_success "Пакеты установлены" "Ошибка при установке пакетов"
    
    print_success "Установка пакетов завершена"
}