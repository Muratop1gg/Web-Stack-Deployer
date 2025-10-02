#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/../lib/helpers.sh"
source "$(dirname "${BASH_SOURCE[0]}")/../lib/config.sh"

setup_nginx() {
    print_step "5. НАСТРОЙКА NGINX"
    
    load_config
    
    # Создание папок
    print_info "Создание папки для HTML файлов..."
    mkdir -p /etc/nginx/html
    check_success "Папка создана" "Ошибка при создании папки"
    
    # Создание maintenance.html
    print_info "Создание страницы технических работ..."
    cat > /etc/nginx/html/maintenance.html << 'EOF'
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Технические работы</title>
    <style>
        body { font-family: 'Arial', sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); height: 100vh; margin: 0; display: flex; align-items: center; justify-content: center; color: white; text-align: center; }
        .container { max-width: 600px; padding: 40px; background: rgba(0, 0, 0, 0.7); border-radius: 15px; backdrop-filter: blur(10px); }
        h1 { font-size: 2.5em; margin-bottom: 20px; }
        p { font-size: 1.2em; line-height: 1.6; margin-bottom: 30px; }
        .loader { border: 5px solid #f3f3f3; border-top: 5px solid #3498db; border-radius: 50%; width: 50px; height: 50px; animation: spin 2s linear infinite; margin: 0 auto; }
        @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚧 На сайте ведутся технические работы</h1>
        <p>Мы обновляем систему для вашего удобства. Приносим извинения за временные неудобства.</p>
        <p>Сервер будет доступен в ближайшее время. Спасибо за понимание!</p>
        <div class="loader"></div>
        <p style="margin-top: 30px; font-size: 0.9em; opacity: 0.8;">Техническая поддержка: pleromacorp@gmail.com</p>
    </div>
</body>
</html>
EOF
    check_success "Страница технических работ создана" "Ошибка при создании страницы"
    
    # Создание конфигурации nginx
    print_info "Создание конфигурации nginx..."
    CONFIG_FILE="/etc/nginx/sites-available/${DOMAIN}"
    
    cat > "$CONFIG_FILE" << EOF
server {
    server_name $DOMAIN;
    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
    error_page 502 /maintenance.html;
    location = /maintenance.html {
        root /etc/nginx/html;
        internal;
    }
}

server {
    server_name $BACKEND_DOMAIN;
    location / {
        proxy_pass http://localhost:8000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
    location /static/ {
        alias /root/FoodMind.AI/backend/staticfiles/;
        autoindex on;
    }
    error_page 502 /maintenance.html;
    location = /maintenance.html {
        root /etc/nginx/html;
        internal;
    }
}
EOF
    check_success "Конфигурация nginx создана" "Ошибка при создании конфигурации"
    
    # Активация конфигурации
    print_info "Активация конфигурации..."
    ln -sf "$CONFIG_FILE" "/etc/nginx/sites-enabled/${DOMAIN}"
    rm -f /etc/nginx/sites-enabled/default
    
    # Проверка и перезагрузка
    print_info "Проверка конфигурации nginx..."
    nginx -t
    check_success "Конфигурация nginx корректна" "Ошибка в конфигурации nginx"
    
    print_info "Перезагрузка nginx..."
    systemctl reload nginx
    check_success "Nginx перезагружен" "Ошибка при перезагрузке nginx"
    
    print_success "Настройка Nginx завершена"
}