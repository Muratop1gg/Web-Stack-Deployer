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
    
    # Настройка страницы технических работ
    setup_maintenance_page
    
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

setup_maintenance_page() {
    print_step "НАСТРОЙКА СТРАНИЦЫ ТЕХНИЧЕСКИХ РАБОТ"
    
    echo ""
    print_info "Выберите тип страницы для технических работ:"
    echo "  1) 📄 Использовать стандартную страницу"
    echo "  2) 🎨 Создать новую кастомную страницу" 
    echo "  3) 📂 Указать путь к существующему HTML файлу"
    echo ""
    
    local choice
    read -p "$(echo -e ${YELLOW}"Ваш выбор (1/2/3): "${NC})" choice
    
    case $choice in
        1)
            setup_default_maintenance_page
            ;;
        2)
            setup_custom_maintenance_page
            ;;
        3)
            setup_existing_maintenance_page
            ;;
        *)
            print_warning "Неверный выбор. Используется стандартная страница."
            setup_default_maintenance_page
            ;;
    esac
}

setup_default_maintenance_page() {
    print_info "Настройка стандартной страницы технических работ..."
    
    local support_email
    if [ -z "$USER_EMAIL" ]; then
        read -p "$(echo -e ${YELLOW}"Введите email для технической поддержки: "${NC})" support_email
    else
        read -p "$(echo -e ${YELLOW}"Введите email для технической поддержки [по умолчанию: $USER_EMAIL]: "${NC})" support_email
        support_email="${support_email:-$USER_EMAIL}"
    fi
    
    cat > /etc/nginx/html/maintenance.html << EOF
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Технические работы</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            height: 100vh;
            margin: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            text-align: center;
        }
        .container {
            max-width: 600px;
            padding: 40px;
            background: rgba(0, 0, 0, 0.7);
            border-radius: 15px;
            backdrop-filter: blur(10px);
        }
        h1 {
            font-size: 2.5em;
            margin-bottom: 20px;
        }
        p {
            font-size: 1.2em;
            line-height: 1.6;
            margin-bottom: 30px;
        }
        .loader {
            border: 5px solid #f3f3f3;
            border-top: 5px solid #3498db;
            border-radius: 50%;
            width: 50px;
            height: 50px;
            animation: spin 2s linear infinite;
            margin: 0 auto;
        }
        .contact-info {
            margin-top: 30px;
            padding: 15px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 8px;
            font-size: 0.9em;
        }
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚧 На сайте ведутся технические работы</h1>
        <p>Мы обновляем систему для вашего удобства. Приносим извинения за временные неудобства.</p>
        <p>Сервер будет доступен в ближайшее время. Спасибо за понимание!</p>
        <div class="loader"></div>
        <div class="contact-info">
            <strong>Техническая поддержка:</strong><br>
            ${support_email}
        </div>
    </div>
</body>
</html>
EOF
    check_success "Стандартная страница технических работ создана" "Ошибка при создании страницы"
}

setup_custom_maintenance_page() {
    print_info "Создание кастомной страницы технических работ..."
    
    # Создаем расширенную кастомную страницу
    cat > /etc/nginx/html/maintenance.html << 'EOF'
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Технические работы</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            height: 100vh;
            margin: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #333;
            text-align: center;
        }
        
        .maintenance-container {
            max-width: 800px;
            padding: 50px;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(10px);
        }
        
        .logo {
            font-size: 3em;
            margin-bottom: 20px;
            color: #667eea;
        }
        
        h1 {
            font-size: 2.8em;
            margin-bottom: 20px;
            color: #2d3748;
            font-weight: 700;
        }
        
        .subtitle {
            font-size: 1.4em;
            color: #4a5568;
            margin-bottom: 30px;
            line-height: 1.6;
        }
        
        .progress-container {
            width: 100%;
            height: 8px;
            background: #e2e8f0;
            border-radius: 4px;
            margin: 40px 0;
            overflow: hidden;
        }
        
        .progress-bar {
            height: 100%;
            background: linear-gradient(90deg, #667eea, #764ba2);
            border-radius: 4px;
            animation: progress 2s ease-in-out infinite;
        }
        
        .features {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin: 40px 0;
        }
        
        .feature {
            padding: 20px;
            background: rgba(102, 126, 234, 0.1);
            border-radius: 10px;
            transition: transform 0.3s ease;
        }
        
        .feature:hover {
            transform: translateY(-5px);
        }
        
        .feature-icon {
            font-size: 2em;
            margin-bottom: 10px;
            color: #667eea;
        }
        
        .contact-section {
            margin-top: 40px;
            padding: 30px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            border-radius: 15px;
        }
        
        .contact-info {
            font-size: 1.1em;
            margin: 10px 0;
        }
        
        .social-links {
            margin-top: 20px;
        }
        
        .social-link {
            display: inline-block;
            margin: 0 10px;
            padding: 10px 20px;
            background: rgba(255, 255, 255, 0.2);
            color: white;
            text-decoration: none;
            border-radius: 25px;
            transition: background 0.3s ease;
        }
        
        .social-link:hover {
            background: rgba(255, 255, 255, 0.3);
        }
        
        @keyframes progress {
            0% { transform: translateX(-100%); }
            50% { transform: translateX(0%); }
            100% { transform: translateX(100%); }
        }
        
        @keyframes float {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-10px); }
        }
        
        .floating {
            animation: float 3s ease-in-out infinite;
        }
        
        @media (max-width: 768px) {
            .maintenance-container {
                margin: 20px;
                padding: 30px 20px;
            }
            
            h1 {
                font-size: 2em;
            }
            
            .features {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="maintenance-container">
        <div class="logo floating">🚀</div>
        
        <h1>Мы становимся лучше!</h1>
        
        <div class="subtitle">
            В настоящее время мы проводим технические работы для улучшения нашего сервиса. 
            Мы вернемся в ближайшее время с обновлениями, которые сделают вашу работу еще удобнее.
        </div>
        
        <div class="progress-container">
            <div class="progress-bar"></div>
        </div>
        
        <div class="features">
            <div class="feature">
                <div class="feature-icon">⚡</div>
                <h3>Повышение скорости</h3>
                <p>Улучшаем производительность системы</p>
            </div>
            <div class="feature">
                <div class="feature-icon">🔒</div>
                <h3>Улучшение безопасности</h3>
                <p>Обновляем системы защиты</p>
            </div>
            <div class="feature">
                <div class="feature-icon">🎨</div>
                <h3>Новый дизайн</h3>
                <p>Работаем над улучшением интерфейса</p>
            </div>
            <div class="feature">
                <div class="feature-icon">🛠️</div>
                <h3>Техническое обновление</h3>
                <p>Обновляем технологии и инфраструктуру</p>
            </div>
        </div>
        
        <div class="contact-section">
            <h2 style="color: white; margin-bottom: 20px;">Нужна помощь?</h2>
            <div class="contact-info">
                <strong>Техническая поддержка:</strong><br>
                pleromacorp@gmail.com
            </div>
            <div class="contact-info">
                <strong>Время работы:</strong><br>
                Круглосуточно, 7 дней в неделю
            </div>
            
            <div class="social-links">
                <a href="mailto:pleromacorp@gmail.com" class="social-link">📧 Написать нам</a>
                <a href="https://github.com/pleroma-corp" class="social-link">💻 GitHub</a>
            </div>
        </div>
        
        <div style="margin-top: 30px; font-size: 0.9em; color: #718096;">
            Благодарим за ваше терпение и понимание!
        </div>
    </div>
</body>
</html>
EOF
    check_success "Кастомная страница технических работ создана" "Ошибка при создании страницы"
    
    print_success "Создана расширенная кастомная страница с анимациями и дополнительной информацией"
}

setup_existing_maintenance_page() {
    print_info "Использование существующего HTML файла..."
    
    local html_path
    read -p "$(echo -e ${YELLOW}"Введите полный путь к HTML файлу: "${NC})" html_path
    
    if [ -z "$html_path" ]; then
        print_warning "Путь не указан. Используется стандартная страница."
        setup_default_maintenance_page
        return
    fi
    
    if [ ! -f "$html_path" ]; then
        print_error "Файл не найден: $html_path"
        print_warning "Используется стандартная страница."
        setup_default_maintenance_page
        return
    fi
    
    # Копируем файл в нужную директорию
    cp "$html_path" /etc/nginx/html/maintenance.html
    check_success "Файл скопирован в /etc/nginx/html/maintenance.html" "Ошибка при копировании файла"
    
    # Проверяем, что файл имеет правильное содержимое
    if file "/etc/nginx/html/maintenance.html" | grep -q "HTML"; then
        print_success "HTML файл проверен и готов к использованию"
    else
        print_warning "Файл может не быть HTML. Убедитесь в корректности содержимого."
    fi
}

# Функция для просмотра текущей страницы
view_maintenance_page() {
    print_info "Текущая страница технических работ:"
    if [ -f "/etc/nginx/html/maintenance.html" ]; then
        echo "=== Начало файла ==="
        head -20 /etc/nginx/html/maintenance.html
        echo "=== Конец preview ==="
        print_info "Полный путь: /etc/nginx/html/maintenance.html"
    else
        print_error "Страница технических работ не найдена"
    fi
}