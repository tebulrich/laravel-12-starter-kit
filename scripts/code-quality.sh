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
            echo "  --dry-run    Run checks in dry-run mode (no actual changes)"
            echo "  --help, -h   Show this help message"
            echo ""
            echo "By default, this script runs all checks and applies fixes where possible."
            echo "Use --dry-run to only check for issues without making changes."
            exit 0
            ;;
        *)
            echo "Unknown option: $arg"
            echo "Use --help for usage information."
            exit 1
            ;;
    esac
done

if [ "$DRY_RUN" = true ]; then
    echo "🚀 Running all GitLab CI code-quality checks locally (DRY-RUN MODE)..."
else
    echo "🚀 Running all GitLab CI code-quality checks locally..."
fi
echo "=================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# Function to run individual script
run_script() {
    local script_name="$1"
    local script_path="scripts/$script_name"

    if [ ! -f "$script_path" ]; then
        print_error "$script_name not found at $script_path"
        exit 1
    fi

    chmod +x "$script_path"

    if [ "$DRY_RUN" = true ]; then
        if ! "./$script_path" --dry-run; then
            exit 1
        fi
    else
        if ! "./$script_path"; then
            exit 1
        fi
    fi

    echo ""
}

# Check if we're in the project root
if [ ! -f "composer.json" ]; then
    print_error "Please run this script from the project root directory"
    exit 1
fi

# Check if vendor directory exists
if [ ! -d "vendor" ]; then
    print_warning "Vendor directory not found. Running composer install..."
    composer install --no-progress --no-interaction --prefer-dist --optimize-autoloader
    echo ""
fi

# Run all code quality checks using individual scripts
run_script "pint.sh"
run_script "rector.sh"
run_script "phpstan.sh"
run_script "phpunit.sh"
run_script "composer-audit.sh"

echo "=================================================="
print_success "All code-quality checks passed! 🎉"
echo ""
echo "The following checks were run:"
echo "  • Laravel Pint (code formatting)"
echo "  • Rector (code modernization)"
echo "  • PHPStan (static analysis)"
echo "  • PHPUnit (tests)"
echo "  • Composer Audit (security vulnerabilities)"
