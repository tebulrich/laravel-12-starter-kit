#!/bin/bash

set -e  # Exit on any error

if [ "$EUID" -eq 0 ]; then
  echo "❌ Do not run this script as root or with sudo."
  echo "👉 Just run it normally like: ./generate-certificates.sh"
  exit 1
fi

# Check if mkcert is installed
if ! command -v mkcert &> /dev/null; then
    echo "mkcert is not installed. Installing..."

    # Detect OS and install mkcert
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v apt &> /dev/null; then
            sudo apt update && sudo apt install -y mkcert libnss3-tools
        elif command -v yum &> /dev/null; then
            sudo yum install -y mkcert nss-tools
        elif command -v pacman &> /dev/null; then
            sudo pacman -Sy mkcert nss
        else
            echo "Unsupported package manager. Please install mkcert manually."
            exit 1
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew install mkcert nss
    else
        echo "Unsupported OS. Install mkcert manually from https://github.com/FiloSottile/mkcert"
        exit 1
    fi
fi

# Install mkcert root CA if not already installed
echo "Installing mkcert root CA..."
mkcert -install

# Create SSL certificates for localhost
CERT_DIR="./"
mkdir -p "$CERT_DIR"

echo "Generating SSL certificate for localhost..."
mkcert -cert-file "$CERT_DIR/localhost.pem" -key-file "$CERT_DIR/localhost-key.pem" localhost

echo "SSL Certificate created successfully:"
ls -l "$CERT_DIR"

echo "Done!"
