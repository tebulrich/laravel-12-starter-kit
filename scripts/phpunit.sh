#!/bin/bash

set -e  # Exit on any error

# Parse command line arguments
DRY_RUN=false
for arg in "$@"; do
    case $arg in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [--dry-run] [--help]"
            echo ""
            echo "Options:"
            echo "  --dry-run    Same as normal mode (PHPUnit runs tests)"
            echo "  --help, -h   Show this help message"
            echo ""
            echo "PHPUnit runs unit and feature tests for your application."
            echo "This script sets up a test environment and cleans up afterwards."
            exit 0
            ;;
        *)
            echo "Unknown option: $arg"
            echo "Use --help for usage information."
            exit 1
            ;;
    esac
done

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_step() {
    echo -e "${BLUE}▶ $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Check if we're in the project root
if [ ! -f "composer.json" ]; then
    print_error "Please run this script from the project root directory"
    exit 1
fi

# Check if vendor directory exists
if [ ! -d "vendor" ]; then
    print_error "Vendor directory not found. Please run 'composer install' first."
    exit 1
fi

# Check if .env.example exists
if [ ! -f ".env.example" ]; then
    print_error "Test environment template (.env.example) not found"
    exit 1
fi

# Check if phpunit.xml exists
if [ ! -f "phpunit.xml" ]; then
    print_error "PHPUnit configuration file (phpunit.xml) not found"
    exit 1
fi

if [ "$DRY_RUN" = true ]; then
    print_step "Running PHPUnit in dry-run mode (same as normal - runs tests)..."
else
    print_step "Setting up PHPUnit environment..."
fi

# Backup existing .env if it exists
ENV_BACKUP=""
if [ -f ".env" ]; then
    ENV_BACKUP=".env.backup.$(date +%s)"
    cp .env "$ENV_BACKUP"
    print_warning "Backed up existing .env to $ENV_BACKUP"
fi

# Setup test environment
cp .env.example .env
php artisan key:generate --quiet
touch database/database.sqlite

print_step "Running PHPUnit..."
if ./vendor/bin/phpunit; then
    print_success "PHPUnit passed - all tests completed successfully"
    TEST_RESULT=0
else
    print_error "PHPUnit failed - some tests failed"
    TEST_RESULT=1
fi

# Restore backup if it exists
if [ -n "$ENV_BACKUP" ] && [ -f "$ENV_BACKUP" ]; then
    mv "$ENV_BACKUP" .env
    print_warning "Restored original .env file"
fi

# Clean up test database
if [ -f "database/database.sqlite" ]; then
    rm database/database.sqlite
fi

exit $TEST_RESULT
