#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/../lib/helpers.sh"
source "$(dirname "${BASH_SOURCE[0]}")/../lib/config.sh"

setup_ssh_git() {
    print_step "7. НАСТРОЙКА SSH И GIT"
    
    # Создание папки .ssh если не существует
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh
    
    # Проверка существующего SSH ключа
    if [ -f ~/.ssh/id_rsa.pub ]; then
        print_info "Найден существующий SSH ключ"
        if confirm_action "Показать публичный SSH ключ?"; then
            print_warning "=== Публичный ключ ==="
            cat ~/.ssh/id_rsa.pub
            print_warning "=== Конец публичного ключа ==="
        fi
    else
        print_info "SSH ключ не найден. Генерация нового ключа..."
        
        if [ -z "$USER_EMAIL" ]; then
            input_with_check "Введите ваш email для генерации SSH ключа" "USER_EMAIL" "$USER_EMAIL"
            save_config
        fi
        
        ssh-keygen -t rsa -b 4096 -C "$USER_EMAIL" -f ~/.ssh/id_rsa -N ""
        check_success "SSH ключ сгенерирован" "Ошибка при генерации SSH ключа"
        
        print_success "Новый SSH ключ сгенерирован"
        print_warning "=== Публичный ключ (скопируйте в GitHub) ==="
        cat ~/.ssh/id_rsa.pub
        print_warning "=== Конец публичного ключа ==="
        
        echo ""
        print_warning "ВАЖНО: Скопируйте ключ выше и добавьте его в:"
        print_warning "GitHub → Settings → SSH and GPG keys → New SSH key"
        echo ""
        
        if confirm_action "Нажмите Y после добавления ключа в GitHub"; then
            print_success "SSH ключ настроен"
        else
            print_warning "Не забудьте добавить SSH ключ в GitHub позже"
        fi
    fi
    
    # Тестирование подключения к GitHub
    print_info "Тестирование подключения к GitHub..."
    if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
        print_success "Подключение к GitHub настроено корректно"
    else
        print_warning "Подключение к GitHub требует настройки. Убедитесь, что:"
        print_warning "1. SSH ключ добавлен в GitHub"
        print_warning "2. Доступ к репозиторию предоставлен"
    fi
    
    # Настройка Git
    print_info "Настройка Git..."
    if [ -n "$USER_EMAIL" ]; then
        git config --global user.email "$USER_EMAIL"
        git config --global user.name "Server Admin"
        print_success "Git настроен (email: $USER_EMAIL)"
    fi
    
    print_success "Настройка SSH и Git завершена"
}

# Функция для проверки SSH подключения
test_ssh_connection() {
    print_info "Проверка SSH подключения к GitHub..."
    ssh -T git@github.com
}