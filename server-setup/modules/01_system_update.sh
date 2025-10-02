#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/../lib/helpers.sh"

system_update() {
    print_step "1. ОБНОВЛЕНИЕ СИСТЕМЫ"
    
    print_info "Обновление списка пакетов..."
    apt update
    check_success "Список пакетов обновлен" "Ошибка при обновлении пакетов"
    
    print_info "Обновление системы..."
    apt upgrade -y
    check_success "Система обновлена" "Ошибка при обновлении системы"
    
    print_success "Обновление системы завершено"
}