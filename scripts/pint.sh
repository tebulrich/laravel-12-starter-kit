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
            echo "  --dry-run    Check code formatting without making changes"
            echo "  --help, -h   Show this help message"
            echo ""
            echo "By default, this script applies code formatting fixes."
            echo "Use --dry-run to only check for formatting issues without making changes."
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

if [ "$DRY_RUN" = true ]; then
    print_step "Running Laravel Pint in dry-run mode..."
    if ./vendor/bin/pint --test; then
        print_success "Laravel Pint passed - no formatting issues found"
    else
        print_error "Laravel Pint failed - formatting issues found"
        exit 1
    fi
else
    print_step "Running Laravel Pint..."
    if ./vendor/bin/pint; then
        print_success "Laravel Pint completed successfully"
    else
        print_error "Laravel Pint failed"
        exit 1
    fi
fi
