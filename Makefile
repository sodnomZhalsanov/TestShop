# Переменные
PHP = php
COMPOSER = composer
SYMFONY = $(PHP) bin/console

# Цели
.PHONY: install test clear-cache migrate

# Установка зависимостей
install:
	$(COMPOSER) install

# Запуск тестов
test:
	$(PHP) bin/phpunit

# Очистка кеша
clear-cache:
	$(SYMFONY) cache:clear

# Запуск миграций
migrate:
	$(SYMFONY) doctrine:migrations:migrate --no-interaction

lint:
	$(COMPOSER) run cs-fix
	$(COMPOSER) run phpstan

# Сборка проекта (установка зависимостей, миграции, очистка кеша)
build: install migrate clear-cache