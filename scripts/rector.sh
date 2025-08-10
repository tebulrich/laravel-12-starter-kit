#!/bin/bash

# Parse command line arguments
DRY_RUN=false
for arg in "$@"; do
    case $arg in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        *)
            # Ignore unknown arguments for compatibility
            ;;
    esac
done

if [ "$DRY_RUN" = true ]; then
    echo "▶ Running Rector in dry-run mode..."

    # Run Rector and capture output
    OUTPUT=$(vendor/bin/rector --dry-run)
    EXIT_CODE=$?

    # Always show Rector output
    echo "$OUTPUT"

    # Check if Rector found changes (but didn't crash)
    if echo "$OUTPUT" | grep -q 'would make changes'; then
        echo "❌ Rector found issues that need fixing."
        exit 1
    fi

    # Check if Rector failed for some other reason
    if [ $EXIT_CODE -ne 0 ]; then
        echo "❌ Rector exited with error code $EXIT_CODE."
        exit $EXIT_CODE
    fi

    echo "✅ Rector found no issues."
    exit 0
else
    echo "▶ Running Rector..."

    # Run Rector to apply changes
    if vendor/bin/rector; then
        echo "✅ Rector completed successfully."
        exit 0
    else
        echo "❌ Rector failed."
        exit 1
    fi
fi
