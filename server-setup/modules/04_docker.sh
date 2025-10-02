#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/../lib/helpers.sh"

setup_docker() {
    print_step "4. НАСТРОЙКА DOCKER"
    
    print_info "Включение автозапуска Docker..."
    systemctl enable docker
    check_success "Docker добавлен в автозагрузку" "Ошибка при настройке автозагрузки"
    
    print_info "Запуск Docker..."
    systemctl start docker
    check_success "Docker запущен" "Ошибка при запуске Docker"
    
    print_info "Добавление пользователя в группу docker..."
    usermod -aG docker $SUDO_USER
    check_success "Пользователь добавлен в группу docker" "Ошибка при добавлении в группу"
    
    print_success "Настройка Docker завершена"
}