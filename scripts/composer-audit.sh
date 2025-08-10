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
            echo "  --dry-run    Same as normal mode (Composer Audit is analysis-only)"
            echo "  --help, -h   Show this help message"
            echo ""
            echo "Composer Audit scans dependencies for known security vulnerabilities."
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

# Check if composer is available
if ! command -v composer &> /dev/null; then
    print_error "Composer is not installed or not in PATH"
    exit 1
fi

if [ "$DRY_RUN" = true ]; then
    print_step "Running Composer Audit in dry-run mode (same as normal - analysis only)..."
else
    print_step "Running Composer Audit..."
fi

if composer audit; then
    print_success "Composer Audit passed - no security vulnerabilities found"
else
    print_error "Composer Audit failed - security vulnerabilities found"
    exit 1
fi
