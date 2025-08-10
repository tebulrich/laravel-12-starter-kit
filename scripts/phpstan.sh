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
            echo "  --dry-run    Same as normal mode (PHPStan is analysis-only)"
            echo "  --help, -h   Show this help message"
            echo ""
            echo "PHPStan performs static analysis to find bugs and type issues."
            echo "This tool is analysis-only and does not make changes to your code."
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

# Check if phpstan.neon exists
if [ ! -f "phpstan.neon" ]; then
    print_error "PHPStan configuration file (phpstan.neon) not found"
    exit 1
fi

if [ "$DRY_RUN" = true ]; then
    print_step "Running PHPStan in dry-run mode (same as normal - analysis only)..."
else
    print_step "Running PHPStan..."
fi

if ./vendor/bin/phpstan analyse --memory-limit=1G; then
    print_success "PHPStan passed - no type safety or bug issues found"
else
    print_error "PHPStan failed - type safety or bug issues found"
    exit 1
fi
