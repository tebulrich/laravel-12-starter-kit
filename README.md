# Laravel 12 Starter Kit

A comprehensive starter kit for Laravel 12 applications with modern development tools, optimized Docker setup, and
pre-configured services.

## Features

### 🚀 High-Performance Stack

- **PHP 8.4** - Latest PHP version with improved performance and features
- **FrankenPHP** - Modern PHP application server with HTTP/3 support and Octane integration
- **HTTP/3 Early Hints** - Improved page load times with early resource hints
- **Apache** - for debugging with Xdebug

### 🐳 Docker Environment

- **MySQL 8.0** - Robust database server
- **RabbitMQ** - Message broker for reliable queue processing
- **MailHog** - Email testing tool for local development
- **Supervisor** - Process manager for Laravel queue workers and scheduled tasks

### 📦 Pre-configured Laravel Packages

#### Core Packages

- **Laravel 12** - Latest Laravel framework
- **Laravel Telescope** - Debug assistant for Laravel applications

#### Development Tools

- **Laravel Debugbar** - Debug toolbar for Laravel applications
- **Laravel Pail** - Real-time log viewer
- **Laravel Pint** - PHP code style fixer
- **Laravel Breeze** - Minimal authentication scaffolding

#### Queue & Messaging

- **Laravel RabbitMQ** - RabbitMQ integration for Laravel queues
- **PHP AMQPLIB** - PHP AMQP library for RabbitMQ communication
- **Symfony Mercure** - Real-time updates using the Mercure protocol

#### UI & Frontend

- **Tailwind CSS** - Utility-first CSS framework with custom configuration
- **Blade UI Kit** - UI components for Laravel Blade
- **Blade Heroicons** - Heroicons integration for Blade
- **Ziggy** - Use Laravel routes in JavaScript

#### Utilities

- **Dotenv Editor** - Edit .env files programmatically
- **Security Advisories Health Check** - Security vulnerability scanning

## Docker Configuration

### Services

- **PHP**: Runs on ports 80 (HTTP with Apache) and 443 (HTTPS/HTTP3 with FrankenPHP)
- **MySQL**: Runs on port 3306
- **RabbitMQ**: Runs on ports 5672 (AMQP) and 15672 (Management UI)
- **MailHog**: Runs on ports 1025 (SMTP) and 8025 (Web UI)

### SSL Configuration

The starter kit automatically creates a local SSL certificate and registers it on the host machine:

- **Automatic Certificate Generation**: Uses `mkcert` to create trusted SSL certificates for localhost
- **Host Registration**: Certificates are automatically registered with your system's trust store
- **HTTPS Ready**: Access your application via HTTPS without browser security warnings

### Background Processes

The starter kit comes with pre-configured Supervisor processes that run automatically:

- **Queue Worker**: Processes jobs from the default queue using Laravel's queue system with RabbitMQ
- **Scheduled Tasks**: Runs Laravel's scheduler for cron jobs using the `schedule:work` command
- **Automatic Migrations**: Runs database migrations on container startup
- **Composer Install**: Automatically installs PHP dependencies on container startup
- **Yarn Build Process**: Installs frontend dependencies and builds assets with Tailwind CSS in watch mode

## Getting Started

1. Clone this repository
2. Copy `.env.example` to `.env` and configure as needed
3. Run `./start.sh` to start the application
   - This script generates SSL certificates, creates a .env file if needed, and starts Docker containers
4. Run `./stop.sh` when you want to stop the application
5. Access your application at https://localhost or http://localhost

## Environment Configuration

Key environment variables:

- `APP_PORT`: HTTP port (default: 80)
- `APP_PORT_FRANKENPHP_HTTPS`: HTTPS port (default: 443)
- `RABBITMQ_PORT_AMQP`: RabbitMQ AMQP port (default: 5672)
- `RABBITMQ_PORT_HTTP`: RabbitMQ management UI port (default: 15672)
- `DOCKER_WWWUSER` and `DOCKER_WWWGROUP`: User/group IDs for Docker containers

## Development Workflow

### Frontend Setup

The starter kit comes with a pre-configured frontend setup:

- **Tailwind CSS**: Utility-first CSS framework with custom configuration
- **Yarn**: Package manager for frontend dependencies
- **Automatic Asset Building**: Assets are automatically built and watched for changes

When the container starts, the following happens automatically:

1. Yarn dependencies are installed (`yarn install`)
2. Assets are built with Tailwind CSS processing
3. The build process continues in watch mode to rebuild on file changes

### Composer Scripts

- `composer dev`: Starts development environment with concurrent processes
- `composer test`: Runs tests
- `composer code-quality`: Runs all code-quality checks and fixes where possible

## Code Quality

This project includes a set of scripts to standardize and automate code quality checks. They wrap commonly used tools and provide a single entry point you can run locally or in CI.

Included checks:

- Laravel Pint — code style/formatting (pint.json)
- Rector — automated refactoring and modernization (rector.php)
- PHPStan — static analysis (phpstan.neon)
- PHPUnit — unit and feature tests (phpunit.xml)
- Composer Audit — dependency vulnerability scan

Quick start:

- Run everything (will apply fixes where possible):
  - composer code-quality
  - or: ./scripts/code-quality.sh
- Dry run (report only, do not change files):
  - composer run code-quality -- --dry-run
  - or: ./scripts/code-quality.sh --dry-run

Notes and prerequisites:

- The aggregator script will run composer install automatically if vendor/ is missing.
- Ensure Composer and PHP 8.4 are available locally. Some tools may require ext-curl and ext-zlib (already declared in composer.json).
- The PHPUnit script creates a fresh .env from .env.example, generates a key, uses an SQLite database at database/database.sqlite for tests, and restores your original .env when finished.

Run checks individually (optional):

- Formatting with Pint: ./scripts/pint.sh [--dry-run]
- Refactoring with Rector: ./scripts/rector.sh [--dry-run]
- Static analysis with PHPStan: ./scripts/phpstan.sh [--dry-run]
- Run tests with PHPUnit: ./scripts/phpunit.sh [--dry-run]
- Security audit with Composer: ./scripts/composer-audit.sh [--dry-run]

Tip: You can pass tool-specific flags by running the tool directly from vendor/bin if needed.

## Security

This starter kit includes security tools:

- **Roave Security Advisories**: Prevents installation of packages with known security issues
- **Spatie Security Advisories Health Check**: Checks for security vulnerabilities

## Author

T. Ulrich <dlhairbus320@googlemail.com>
