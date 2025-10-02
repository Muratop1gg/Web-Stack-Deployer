#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/../lib/helpers.sh"

setup_firewall() {
    print_step "3. НАСТРОЙКА ФАЕРВОЛА"
    
    print_info "Сброс правил фаервола..."
    ufw --force reset
    check_success "Правила сброшены" "Ошибка при сбросе правил"
    
    print_info "Настройка правил..."
    ufw allow 22/tcp
    ufw allow 80/tcp
    ufw allow 443/tcp
    ufw default deny incoming
    ufw default allow outgoing
    
    print_info "Включение фаервола..."
    ufw --force enable
    check_success "Фаервол включен" "Ошибка при включении фаервола"
    
    print_info "Текущие правила фаервола:"
    ufw status numbered
    
    print_success "Настройка фаервола завершена"
}