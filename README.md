<div class="ds-message _63c77b1" style="--panel-width: 0px;"><div class="ds-markdown" style="--ds-md-zoom: 1.143;"><h1><span>🚀 Server Setup CLI</span></h1><p class="ds-markdown-paragraph"><strong><span>Автоматизация развертывания серверов в один клик</span></strong><br><em><span>Ubuntu • Nginx • Docker • SSL • Firewall • Automated Deployment</span></em></p><hr><h2><span>📖 Описание</span></h2><p class="ds-markdown-paragraph"><span>Server Setup CLI - это мощная утилита командной строки для автоматической настройки и развертывания серверов. Всего одной командой вы можете подготовить чистый сервер Ubuntu к работе с полным стеком технологий:</span></p><ul><li><p class="ds-markdown-paragraph"><span>🔧 </span><strong><span>Автоматическая настройка</span></strong><span> - от обновления системы до деплоя приложения</span></p></li><li><p class="ds-markdown-paragraph"><span>🛡️ </span><strong><span>Безопасность</span></strong><span> - настройка фаервола, SSL сертификатов</span></p></li><li><p class="ds-markdown-paragraph"><span>🐳 </span><strong><span>Docker-ориентированность</span></strong><span> - полная поддержка контейнеризации</span></p></li><li><p class="ds-markdown-paragraph"><span>🌐 </span><strong><span>Nginx + Reverse Proxy</span></strong><span> - профессиональная настройка веб-сервера</span></p></li><li><p class="ds-markdown-paragraph"><span>📦 </span><strong><span>Git-интеграция</span></strong><span> - автоматическое клонирование и обновление репозиториев</span></p></li></ul><h2><span>✨ Возможности</span></h2><ul><li><p class="ds-markdown-paragraph"><span>✅ Автоматическое обновление системы</span></p></li><li><p class="ds-markdown-paragraph"><span>✅ Установка необходимых пакетов (Nginx, Docker, Certbot и др.)</span></p></li><li><p class="ds-markdown-paragraph"><span>✅ Настройка UFW фаервола</span></p></li><li><p class="ds-markdown-paragraph"><span>✅ Конфигурация Docker и Docker Compose</span></p></li><li><p class="ds-markdown-paragraph"><span>✅ Настройка Nginx с reverse proxy</span></p></li><li><p class="ds-markdown-paragraph"><span>✅ Получение SSL сертификатов (Let's Encrypt)</span></p></li><li><p class="ds-markdown-paragraph"><span>✅ Настройка SSH ключей для GitHub</span></p></li><li><p class="ds-markdown-paragraph"><span>✅ Клонирование и управление Git репозиториями</span></p></li><li><p class="ds-markdown-paragraph"><span>✅ Деплой Docker-приложений</span></p></li><li><p class="ds-markdown-paragraph"><span>✅ Мониторинг и управление развернутыми приложениями</span></p></li></ul><h2><span>🚀 Быстрый старт</span></h2>
  <h3><span>Установка</span></h3>
  <div class="md-code-block md-code-block-dark">
    <div class="md-code-block-banner-wrap">
      <div class="md-code-block-banner md-code-block-banner-lite">
          <pre><span class="token comment"># Клонирование репозитория</span>
  <span class="token function">git</span> clone https://github.com/your-username/server-setup-cli.git
<span class="token builtin class-name">cd</span> server-setup-cli

<span class="token comment"># Настройка прав доступа</span>
<span class="token function">chmod</span> +x setup.sh cli.sh modules/*.sh lib/*.sh</pre>
<h3><span>Первое использование</span></h3>
<pre><span class="token comment"># 1. Настройка конфигурации</span>
./setup.sh config

<span class="token comment"># 2. Полная настройка сервера (рекомендуется)</span>
./setup.sh full-setup

<span class="token comment"># 3. Или пошаговая настройка</span>
./setup.sh system-update
./setup.sh install-packages
./setup.sh setup-firewall
<span class="token comment"># ... и так далее</span></pre><svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 12 12" fill="none" class="_9bc997d _33882ae"><path d="M-5.24537e-07 0C-2.34843e-07 6.62742 5.37258 12 12 12L0 12L-5.24537e-07 0Z" fill="currentColor"></path></svg><svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 12 12" fill="none" class="_9bc997d _28d7e84"><path d="M-5.24537e-07 0C-2.34843e-07 6.62742 5.37258 12 12 12L0 12L-5.24537e-07 0Z" fill="currentColor"></path></svg></div>

<h2><span>📋 Команды CLI</span></h2>

<h3><span>🔧 Основные команды</span></h3>

<div class="ds-scroll-area _1210dd7"><div class="ds-scroll-area__gutters" style="position: sticky; top: 0px; left: 0px; right: 0px; height: 0px; --container-height: 184px;"><div class="ds-scroll-area__horizontal-gutter" style="left: 0px; right: 0px; top: calc(var(--container-height) - 12px); height: 8px;"><div class="ds-scroll-area__horizontal-bar" style="display: none;"></div></div><div class="ds-scroll-area__vertical-gutter" style="right: 0px; top: 8px; bottom: calc(0px - var(--container-height) + 8px); width: 8px;"><div class="ds-scroll-area__vertical-bar" style="display: none;"></div></div></div><table><thead><tr><th><span>Команда</span></th><th><span>Описание</span></th></tr></thead><tbody><tr>
<td><code>config</code></td><td><span>Настройка параметров доменов и репозитория</span>
</td></tr><tr><td><code>full-setup</code></td><td><strong><span>Полная автоматическая настройка сервера</span></strong>
</td></tr><tr><td><code>status</code></td><td><span>Показать статус системы и сервисов</span></td></tr></tbody>

</table></div><h3><span>⚙️ Модули настройки</span></h3><div class="ds-scroll-area _1210dd7"><div class="ds-scroll-area__gutters" style="position: sticky; top: 0px; left: 0px; right: 0px; height: 0px; --container-height: 460px;"><div class="ds-scroll-area__horizontal-gutter" style="left: 0px; right: 0px; top: calc(var(--container-height) - 12px); height: 8px;"><div class="ds-scroll-area__horizontal-bar" style="display: none;"></div></div><div class="ds-scroll-area__vertical-gutter" style="right: 0px; top: 8px; bottom: calc(0px - var(--container-height) + 8px); width: 8px;"><div class="ds-scroll-area__vertical-bar" style="display: none;"></div></div></div><table><thead><tr><th><span>Команда</span></th><th><span>Описание</span></th></tr></thead><tbody><tr><td><code>system-update</code></td><td><span>Обновление системы и пакетов</span></td></tr><tr><td><code>install-packages</code></td><td><span>Установка Nginx, Docker, Certbot и др.</span></td></tr><tr><td><code>setup-firewall</code></td><td><span>Настройка UFW фаервола</span></td></tr><tr><td><code>setup-docker</code></td><td><span>Настройка Docker и Docker Compose</span></td></tr><tr><td><code>setup-nginx</code></td><td><span>Настройка Nginx и reverse proxy</span></td></tr><tr><td><code>setup-ssl</code></td><td><span>Получение SSL сертификатов</span></td></tr><tr><td><code>setup-ssh</code></td><td><span>Настройка SSH ключей для GitHub</span></td></tr><tr><td><code>setup-repo</code></td><td><span>Клонирование и настройка Git репозитория</span></td></tr><tr><td><code>setup-env</code></td><td><span>Настройка переменных окружения (.env файл)</span></td></tr></tbody></table></div>

<h3><span>🚀 Деплой и управление</span></h3>

<table>
  <thead>
    <tr><th><span>Команда</span></th>
    <th><span>Описание</span></th></tr>
  </thead>
  <tbody>
    <tr><td><code>deploy</code></td><td><span>Деплой приложения (Docker Compose)</span></td></tr>
    <tr><td><code>rollback</code></td><td><span>Откат к предыдущей версии</span></td></tr>
    <tr><td><code>logs [service]</code></td><td><span>Просмотр логов контейнеров</span></td></tr>
    <tr><td><code>health-check</code></td><td><span>Проверка здоровья приложения</span></td></tr>
  </tbody>
</table>


<h3><span>ℹ️ Информационные команды</span></h3>

<table>
  <thead>
    <tr><th><span>Команда</span></th>
    <th><span>Описание</span></th></tr>
  </thead>
  <tbody>
    <tr><td><code>status</code></td><td><span>Статус системы, сервисов и контейнеров</span></td></tr>
    <tr><td><code>help</code></td><td><span>Показать справку по командам</span></td></tr>
  </tbody>
</table>

<h3><span>🎨 Управление страницами ошибок</span></h3>

<table>
  <thead>
    <tr><th><span>Команда</span></th>
    <th><span>Описание</span></th></tr>
  </thead>
  <tbody>
    <tr><td><code>view-maintenance</code></td><td><span>Просмотр текущей страницы технических работ</span></td></tr>
  </tbody>
</table>

<h2><span>🎯 Пример использования</span></h2>

<h3><span>Полная настройка нового сервера</span></h3>
<pre><span class="token comment"># 1. Клонируем утилиту</span>
<span class="token function">git</span> clone https://github.com/your-username/server-setup-cli.git
<span class="token builtin class-name">cd</span> server-setup-cli
<span class="token function">chmod</span> +x setup.sh cli.sh modules/*.sh lib/*.sh

<span class="token comment"># 2. Запускаем конфигуратор</span>
./setup.sh config
<span class="token comment"># Вводим:</span>
<span class="token comment"># - Домен: yourdomain.com</span>
<span class="token comment"># - Бэкенд домен: api.yourdomain.com  </span>
<span class="token comment"># - Email: your@email.com</span>
<span class="token comment"># - Git репозиторий: git@github.com:username/your-app.git</span>

<span class="token comment"># 3. Запускаем полную настройку</span>
./setup.sh full-setup</pre>

<h3><span>Пошаговая настройка</span></h3>
<pre><span class="token comment"># Обновляем систему</span>
./setup.sh system-update

<span class="token comment"># Устанавливаем пакеты</span>
./setup.sh install-packages

<span class="token comment"># Настраиваем фаервол</span>
./setup.sh setup-firewall

<span class="token comment"># Настраиваем Docker</span>
./setup.sh setup-docker

<span class="token comment"># Настраиваем Nginx</span>
./setup.sh setup-nginx

<span class="token comment"># Получаем SSL сертификаты</span>
./setup.sh setup-ssl

<span class="token comment"># Настраиваем SSH для GitHub</span>
./setup.sh setup-ssh

<span class="token comment"># Клонируем репозиторий</span>
./setup.sh setup-repo

<span class="token comment"># Настраиваем переменные окружения</span>
./setup.sh setup-env

<span class="token comment"># Деплоим приложение</span>
./setup.sh deploy</pre>
</div>
<h2><span>⚙️ Конфигурация</span></h2>
<p class="ds-markdown-paragraph"><span>Утилита сохраняет настройки в файл </span><code>server-setup.conf</code><span>:</span></p>

<pre><span class="token assign-left variable">DOMAIN</span><span class="token operator">=</span><span class="token string">"yourdomain.com"</span>
<span class="token assign-left variable">BACKEND_DOMAIN</span><span class="token operator">=</span><span class="token string">"api.yourdomain.com"</span>
<span class="token assign-left variable">REPO_URL</span><span class="token operator">=</span><span class="token string">"git@github.com:username/your-app.git"</span>
<span class="token assign-left variable">USER_EMAIL</span><span class="token operator">=</span><span class="token string">"your@email.com"</span></pre><svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 12 12" fill="none" class="_9bc997d _33882ae"><path d="M-5.24537e-07 0C-2.34843e-07 6.62742 5.37258 12 12 12L0 12L-5.24537e-07 0Z" fill="currentColor"></path></svg><svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 12 12" fill="none" class="_9bc997d _28d7e84"><path d="M-5.24537e-07 0C-2.34843e-07 6.62742 5.37258 12 12 12L0 12L-5.24537e-07 0Z" fill="currentColor"></path></svg></div>

<h2><span>🐳 Поддерживаемая структура проекта</span></h2><p class="ds-markdown-paragraph"><span>Утилита ожидает, что ваш проект имеет следующую структуру:</span></p>

<pre>your-project/
├── docker-compose.yml    # Docker Compose конфигурация
├── .env                  # Переменные окружения
├── backend/              # Бэкенд приложение
└── frontend/             # Фронтенд приложение
</pre>
</div>
<h2><span>🔧 Требования</span></h2>
<ul><li><p class="ds-markdown-paragraph"><span>✅ Сервер с Ubuntu 18.04+</span></p></li><li><p class="ds-markdown-paragraph"><span>✅ Доступ с правами root (sudo)</span></p></li><li><p class="ds-markdown-paragraph"><span>✅ Настроенные DNS записи для доменов</span></p></li><li><p class="ds-markdown-paragraph"><span>✅ SSH ключ, добавленный в GitHub (настраивается автоматически)</span></p></li></ul><h2><span>🛠️ Технологический стек</span></h2><ul><li><p class="ds-markdown-paragraph"><strong><span>ОС</span></strong><span>: Ubuntu 18.04+</span></p></li><li><p class="ds-markdown-paragraph"><strong><span>Веб-сервер</span></strong><span>: Nginx с reverse proxy</span></p></li><li><p class="ds-markdown-paragraph"><strong><span>Контейнеризация</span></strong><span>: Docker + Docker Compose</span></p></li><li><p class="ds-markdown-paragraph"><strong><span>SSL</span></strong><span>: Let's Encrypt (Certbot)</span></p></li><li><p class="ds-markdown-paragraph"><strong><span>Безопасность</span></strong><span>: UFW фаервол</span></p></li><li><p class="ds-markdown-paragraph"><strong><span>Версионность</span></strong><span>: Git</span></p></li><li><p class="ds-markdown-paragraph"><strong><span>Деплой</span></strong><span>: Автоматический через Docker Compose</span></p></li></ul>

<h2><span>📁 Структура проекта</span></h2>

<pre>server-setup-cli/
├── setup.sh              # Главный скрипт
├── cli.sh               # CLI менеджер
├── lib/
│   ├── colors.sh        # Цветовые функции
│   ├── helpers.sh       # Вспомогательные функции
│   └── config.sh        # Конфигурация
└── modules/
    ├── 01_system_update.sh
    ├── 02_packages.sh
    ├── 03_firewall.sh
    ├── 04_docker.sh
    ├── 05_nginx_setup.sh
    ├── 06_ssl.sh
    ├── 07_ssh_git.sh
    ├── 08_repo_setup.sh
    └── 09_deploy.sh</pre>
    
<h2><span>🐛 Устранение неполадок</span></h2>
<h3><span>Проверка статуса</span></h3>

<pre>./setup.sh status</pre>

<h3><span>Просмотр логов</span></h3>

<pre>./setup.sh logs
./setup.sh logs backend  <span class="token comment"># логи конкретного сервиса</span></pre>

<h3><span>Откат деплоя</span></h3>
<pre>./setup.sh rollback</pre>

<h3><span>Повторный деплой</span></h3>

<pre>./setup.sh deploy</pre>

<h2><span>🤝 Вклад в развитие</span></h2>

<p class="ds-markdown-paragraph"><span>Мы приветствуем вклад в развитие проекта!</span></p><ol start="1"><li><p class="ds-markdown-paragraph"><span>Форкните репозиторий</span></p></li><li><p class="ds-markdown-paragraph"><span>Создайте ветку для вашей функции (</span><code>git checkout -b feature/amazing-feature</code><span>)</span></p></li><li><p class="ds-markdown-paragraph"><span>Закоммитьте изменения (</span><code>git commit -m 'Add some amazing feature'</code><span>)</span></p></li><li><p class="ds-markdown-paragraph"><span>Запушьте в ветку (</span><code>git push origin feature/amazing-feature</code><span>)</span></p></li><li><p class="ds-markdown-paragraph"><span>Откройте Pull Request</span></p></li></ol><h2><span>📄 Лицензия</span></h2><p class="ds-markdown-paragraph"><span>Этот проект распространяется под лицензией MIT. Смотрите файл </span><code>LICENSE</code><span> для подробностей.</span></p><h2><span>👨‍💻 Автор</span></h2><p class="ds-markdown-paragraph"><strong><span>Muratop1gg</span></strong></p><ul><li><p class="ds-markdown-paragraph"><span>Email: </span><a href="https://mailto:andreymur2008200430@gmail.com" target="_blank" rel="noreferrer"><span>pleromacorp@gmail.com</span></a></p></li><li><p class="ds-markdown-paragraph"><span>GitHub: </span><a href="https://github.com/pleroma-corp" target="_blank" rel="noreferrer"><span>@pleroma-corp</span></a></p></li></ul><h2><span>⭐ Поддержка проекта</span></h2><p class="ds-markdown-paragraph"><span>Если этот проект был полезен для вас, поставьте звезду ⭐ репозиторию!</span></p><hr><p class="ds-markdown-paragraph"><strong><span>🚀 Начните использовать Server Setup CLI уже сегодня и автоматизируйте развертывание ваших серверов!</span></strong></p><hr><p class="ds-markdown-paragraph"><em><span>Последнее обновление: Октябрь 2025</span></em></p></div></div>
