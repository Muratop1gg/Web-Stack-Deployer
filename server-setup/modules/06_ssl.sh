#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/../lib/helpers.sh"
source "$(dirname "${BASH_SOURCE[0]}")/../lib/config.sh"

setup_ssl() {
    print_step "6. НАСТРОЙКА SSL СЕРТИФИКАТОВ"
    
    load_config
    
    if [ -z "$DOMAIN" ] || [ -z "$BACKEND_DOMAIN" ]; then
        print_error "Домены не настроены. Сначала запустите настройку конфигурации."
        return 1
    fi
    
    if [ -z "$USER_EMAIL" ]; then
        print_warning "Email не настроен. Используется email по умолчанию."
        USER_EMAIL="pleromacorp@gmail.com"
    fi
    
    print_info "Запрос SSL сертификатов для $DOMAIN и $BACKEND_DOMAIN..."
    certbot --nginx -d "$DOMAIN" -d "$BACKEND_DOMAIN" --non-interactive --agree-tos --email "$USER_EMAIL" --redirect
    check_success "SSL сертификаты получены" "Ошибка при получении SSL сертификатов"
    
    print_info "Проверка автоматического продления сертификатов..."
    # Тест автоматического обновления
    certbot renew --dry-run
    check_success "Автопродление настроено" "Ошибка при настройке автопродления"
    
    print_info "Добавление cron job для автоматического обновления SSL..."
    # Добавляем задание в cron для автоматического обновления
    (crontab -l 2>/dev/null; echo "0 12 * * * /usr/bin/certbot renew --quiet") | crontab -
    check_success "Cron job добавлен" "Ошибка при добавлении cron job"
    
    print_info "Финальная перезагрузка nginx..."
    systemctl reload nginx
    check_success "Nginx перезагружен" "Ошибка при перезагрузке nginx"
    
    print_success "Настройка SSL завершена"
}

# Функция для проверки SSL
check_ssl() {
    print_info "Проверка SSL сертификатов..."
    
    local domains=("$DOMAIN" "$BACKEND_DOMAIN")
    for domain in "${domains[@]}"; do
        print_info "Проверка $domain..."
        if openssl s_client -connect "$domain:443" -servername "$domain" < /dev/null 2>/dev/null | openssl x509 -noout -dates; then
            print_success "SSL для $domain работает корректно"
        else
            print_error "Проблема с SSL для $domain"
        fi
    done
}