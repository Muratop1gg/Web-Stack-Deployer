#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/helpers.sh"
source "$SCRIPT_DIR/lib/config.sh"

show_help() {
    echo "Использование: $0 [команда]"
    echo ""
    echo "Команды:"
    echo "  config              Настройка параметров"
    echo "  system-update       Обновление системы"
    echo "  install-packages    Установка пакетов"
    echo "  setup-firewall      Настройка фаервола"
    echo "  setup-docker        Настройка Docker"
    echo "  setup-nginx         Настройка Nginx"
    echo "  setup-ssl           Настройка SSL"
    echo "  setup-ssh           Настройка SSH и Git"
    echo "  setup-repo          Настройка репозитория"
    echo "  setup-env           Настройка переменных окружения"
    echo "  deploy              Деплой приложения"
    echo "  rollback            Откат деплоя"
    echo "  logs [service]      Просмотр логов"
    echo "  health-check        Проверка здоровья приложения"
    echo "  full-setup          Полная настройка сервера"
    echo "  status              Показать статус"
    echo "  help                Показать эту справку"
    echo ""
}

setup_config() {
    print_step "НАСТРОЙКА КОНФИГУРАЦИИ"
    
    input_with_check "Введите основной домен" "DOMAIN" "$DOMAIN"
    input_with_check "Введите домен бэкенда" "BACKEND_DOMAIN" "$BACKEND_DOMAIN"
    input_with_check "Введите email для SSL" "USER_EMAIL" "$USER_EMAIL"
    input_with_check "Введите SSH URL репозитория" "REPO_URL" "$REPO_URL"
    
    save_config
    print_success "Конфигурация сохранена"
    print_config
}

run_module() {
    local module_name="$1"
    local module_file="$SCRIPT_DIR/modules/$module_name"
    
    if [ ! -f "$module_file" ]; then
        print_error "Модуль $module_name не найден"
        return 1
    fi
    
    source "$module_file"
}

full_setup() {
    print_step "ПОЛНАЯ НАСТРОЙКА СЕРВЕРА"
    
    # Загрузка конфигурации
    if ! load_config; then
        print_warning "Конфигурация не найдена. Запустите настройку конфигурации."
        setup_config
    fi
    
    # Проверка обязательных параметров
    if [ -z "$DOMAIN" ] || [ -z "$BACKEND_DOMAIN" ]; then
        print_error "Домены не настроены. Запустите настройку конфигурации."
        exit 1
    fi
    
    # Последовательный запуск модулей
    run_module "01_system_update.sh" && system_update
    run_module "02_packages.sh" && install_packages
    run_module "03_firewall.sh" && setup_firewall
    run_module "04_docker.sh" && setup_docker
    run_module "05_nginx_setup.sh" && setup_nginx
    run_module "06_ssl.sh" && setup_ssl
    run_module "07_ssh_git.sh" && setup_ssh_git
    run_module "08_repo_setup.sh" && setup_repository
    run_module "08_repo_setup.sh" && setup_env_file
    run_module "09_deploy.sh" && deploy_app
    
    print_success "Полная настройка завершена!"
    print_divider
    print_info "Доступные домены:"
    print_info "  Frontend: https://$DOMAIN"
    print_info "  Backend:  https://$BACKEND_DOMAIN"
    print_divider
}

show_status() {
    print_step "СТАТУС СИСТЕМЫ"
    
    print_config
    
    echo ""
    print_info "Статус сервисов:"
    systemctl is-active nginx >/dev/null 2>&1 && print_success "Nginx: активен" || print_error "Nginx: неактивен"
    systemctl is-active docker >/dev/null 2>&1 && print_success "Docker: активен" || print_error "Docker: неактивен"
    systemctl is-active ufw >/dev/null 2>&1 && print_success "UFW: активен" || print_error "UFW: неактивен"
    
    echo ""
    print_info "Правила фаервола:"
    ufw status
    
    echo ""
    print_info "Docker контейнеры:"
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
}

# Основная логика
case "${1:-help}" in
    "config")
        setup_config
        ;;
    "system-update")
        run_module "01_system_update.sh" && system_update
        ;;
    "install-packages")
        run_module "02_packages.sh" && install_packages
        ;;
    "setup-firewall")
        run_module "03_firewall.sh" && setup_firewall
        ;;
    "setup-docker")
        run_module "04_docker.sh" && setup_docker
        ;;
    "setup-nginx")
        run_module "05_nginx_setup.sh" && setup_nginx
        ;;
    "setup-ssl")
        run_module "06_ssl.sh" && setup_ssl
        ;;
    "setup-ssh")
        run_module "07_ssh_git.sh" && setup_ssh_git
        ;;
    "setup-repo")
        run_module "08_repo_setup.sh" && setup_repository
        ;;
    "setup-env")
        run_module "08_repo_setup.sh" && setup_env_file
        ;;
    "deploy")
        run_module "09_deploy.sh" && deploy_app
        ;;
    "rollback")
        run_module "09_deploy.sh" && rollback_deploy
        ;;
    "logs")
        run_module "09_deploy.sh" && show_logs "$2"
        ;;
    "health-check")
        run_module "09_deploy.sh" && check_application_health
        ;;
    "full-setup")
        full_setup
        ;;
    "status")
        show_status
        ;;
        # В секции case добавьте:
    "view-maintenance")
    run_module "05_nginx_setup.sh" && view_maintenance_page
    ;;
    "help"|"-h"|"--help")
        show_help
        ;;
    *)
        print_error "Неизвестная команда: $1"
        show_help
        exit 1
        ;;
esac