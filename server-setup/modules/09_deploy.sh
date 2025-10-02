#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/../lib/helpers.sh"
source "$(dirname "${BASH_SOURCE[0]}")/../lib/config.sh"

deploy_app() {
    print_step "9. ДЕПЛОЙ ПРИЛОЖЕНИЯ"
    
    load_config
    
    if [ -z "$REPO_URL" ]; then
        print_error "URL репозитория не настроен. Сначала настройте репозиторий."
        return 1
    fi
    
    PROJECT_DIR="/root/$(basename "$REPO_URL" .git)"
    
    if [ ! -d "$PROJECT_DIR" ]; then
        print_error "Директория проекта не найдена. Сначала настройте репозиторий."
        return 1
    fi
    
    cd "$PROJECT_DIR"
    
    # Проверяем наличие docker-compose.yml
    if [ ! -f "docker-compose.yml" ] && [ ! -f "docker-compose.yaml" ]; then
        print_error "Файл docker-compose.yml не найден в корне проекта"
        print_info "Содержимое директории:"
        ls -la
        return 1
    fi
    
    # Проверяем .env файл
    if [ ! -f ".env" ]; then
        print_warning "Файл .env не найден. Запустите настройку переменных окружения."
        if confirm_action "Хотите создать .env файл сейчас?"; then
            touch .env
            print_success "Файл .env создан"
            print_warning "Не забудьте настроить переменные окружения перед запуском"
        fi
    fi
    
    # Остановка существующих контейнеров
    print_info "Остановка существующих контейнеров..."
    docker-compose down
    check_success "Контейнеры остановлены" "Ошибка при остановке контейнеров"
    
    # Обновление репозитория
    print_info "Обновление кода из репозитория..."
    git pull
    check_success "Код обновлен" "Ошибка при обновлении кода"
    
    # Сборка образов
    print_info "Сборка Docker образов..."
    docker-compose build --no-cache
    check_success "Docker образы собраны" "Ошибка при сборке Docker образов"
    
    # Запуск контейнеров
    print_info "Запуск Docker контейнеров..."
    docker-compose up -d
    check_success "Docker контейнеры запущены" "Ошибка при запуске Docker контейнеров"
    
    # Мониторинг запуска
    print_info "Мониторинг запуска контейнеров..."
    sleep 10
    
    # Проверка статуса контейнеров
    print_info "Статус контейнеров:"
    docker-compose ps
    
    # Проверка логов
    print_info "Проверка логов приложения..."
    docker-compose logs --tail=20
    
    # Проверка здоровья приложения
    print_info "Проверка здоровья приложения..."
    check_application_health
    
    print_success "Деплой завершен успешно!"
}

# Функция для проверки здоровья приложения
check_application_health() {
    print_info "Проверка здоровья приложения..."
    
    # Проверка бэкенда
    if curl -f -s "http://localhost:8000/health/" > /dev/null 2>&1 || \
       curl -f -s "http://localhost:8000/" > /dev/null 2>&1; then
        print_success "Бэкенд доступен на localhost:8000"
    else
        print_warning "Бэкенд может быть недоступен. Проверьте логи: docker-compose logs"
    fi
    
    # Проверка фронтенда
    if curl -f -s "http://localhost:8080/" > /dev/null 2>&1; then
        print_success "Фронтенд доступен на localhost:8080"
    else
        print_warning "Фронтенд может быть недоступен. Проверьте логи: docker-compose logs"
    fi
    
    # Проверка через nginx
    if [ -n "$DOMAIN" ]; then
        print_info "Проверка через домен $DOMAIN..."
        if curl -f -s "https://$DOMAIN" > /dev/null 2>&1; then
            print_success "Домен $DOMAIN доступен"
        else
            print_warning "Домен $DOMAIN может быть недоступен"
        fi
    fi
}

# Функция для отката деплоя
rollback_deploy() {
    print_step "ОТКАТ ДЕПЛОЯ"
    
    load_config
    
    PROJECT_DIR="/root/$(basename "$REPO_URL" .git)"
    
    if [ ! -d "$PROJECT_DIR" ]; then
        print_error "Директория проекта не найдена"
        return 1
    fi
    
    cd "$PROJECT_DIR"
    
    print_info "Откат к предыдущей версии..."
    git reset --hard HEAD~1
    check_success "Откат версии выполнен" "Ошибка при откате версии"
    
    print_info "Перезапуск контейнеров..."
    docker-compose down
    docker-compose up -d
    check_success "Контейнеры перезапущены" "Ошибка при перезапуске контейнеров"
    
    print_success "Откат завершен"
}

# Функция для просмотра логов
show_logs() {
    load_config
    
    PROJECT_DIR="/root/$(basename "$REPO_URL" .git)"
    
    if [ ! -d "$PROJECT_DIR" ]; then
        print_error "Директория проекта не найдена"
        return 1
    fi
    
    cd "$PROJECT_DIR"
    
    local service="$1"
    if [ -n "$service" ]; then
        print_info "Логи сервиса $service:"
        docker-compose logs "$service" --tail=50 -f
    else
        print_info "Логи всех сервисов:"
        docker-compose logs --tail=50 -f
    fi
}