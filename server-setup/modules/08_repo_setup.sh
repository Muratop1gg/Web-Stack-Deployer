#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/../lib/helpers.sh"
source "$(dirname "${BASH_SOURCE[0]}")/../lib/config.sh"

setup_repository() {
    print_step "8. НАСТРОЙКА РЕПОЗИТОРИЯ"
    
    load_config
    
    if [ -z "$REPO_URL" ]; then
        print_error "URL репозитория не настроен"
        input_with_check "Введите SSH URL репозитория Git" "REPO_URL" ""
        save_config
    fi
    
    if [ -z "$REPO_URL" ]; then
        print_error "URL репозитория обязателен для продолжения"
        return 1
    fi
    
    # Получаем имя папки репозитория из URL
    REPO_NAME=$(basename "$REPO_URL" .git)
    PROJECT_DIR="/root/$REPO_NAME"
    
    # Проверяем, существует ли уже репозиторий
    if [ -d "$PROJECT_DIR" ]; then
        print_warning "Репощиторий уже существует в $PROJECT_DIR"
        
        if confirm_action "Хотите обновить репозиторий (git pull)?"; then
            print_info "Обновление репозитория..."
            cd "$PROJECT_DIR"
            git pull
            check_success "Репощиторий обновлен" "Ошибка при обновлении репозитория"
        else
            print_info "Пропускаем клонирование репозитория"
        fi
    else
        print_info "Клонирование репозитория $REPO_URL..."
        cd /root
        git clone "$REPO_URL"
        check_success "Репощиторий склонирован" "Ошибка при клонировании репозитория"
    fi
    
    # Переходим в директорию проекта
    if [ -d "$PROJECT_DIR" ]; then
        cd "$PROJECT_DIR"
        print_success "Рабочая директория: $(pwd)"
        
        # Показываем информацию о репозитории
        print_info "Информация о репозитории:"
        git log --oneline -5
        echo ""
        
        # Проверяем структуру проекта
        print_info "Структура проекта:"
        ls -la
    else
        print_error "Директория проекта не найдена: $PROJECT_DIR"
        return 1
    fi
    
    print_success "Настройка репозитория завершена"
}

# Функция для настройки .env файла
setup_env_file() {
    print_step "НАСТРОЙКА ПЕРЕМЕННЫХ ОКРУЖЕНИЯ"
    
    load_config
    
    PROJECT_DIR="/root/$(basename "$REPO_URL" .git)"
    ENV_FILE="$PROJECT_DIR/.env"
    
    if [ ! -d "$PROJECT_DIR" ]; then
        print_error "Директория проекта не найдена. Сначала настройте репозиторий."
        return 1
    fi
    
    cd "$PROJECT_DIR"
    
    if [ ! -f "$ENV_FILE" ]; then
        print_info "Создание файла .env..."
        touch "$ENV_FILE"
        print_success "Файл .env создан"
    else
        print_info "Файл .env уже существует"
    fi
    
    # Показываем текущее содержимое .env
    if [ -s "$ENV_FILE" ]; then
        print_info "Текущее содержимое .env:"
        echo "=== НАЧАЛО .env ==="
        cat "$ENV_FILE"
        echo "=== КОНЕЦ .env ==="
        echo ""
    fi
    
    if confirm_action "Хотите отредактировать файл .env?"; then
        if command -v nano >/dev/null 2>&1; then
            nano "$ENV_FILE"
        elif command -v vim >/dev/null 2>&1; then
            vim "$ENV_FILE"
        else
            vi "$ENV_FILE"
        fi
        print_success "Файл .env отредактирован"
    fi
    
    # Проверяем базовые настройки
    if [ -f "$ENV_FILE" ]; then
        print_info "Проверка прав доступа к .env..."
        chmod 600 "$ENV_FILE"
        print_success "Права доступа к .env установлены"
    fi
}