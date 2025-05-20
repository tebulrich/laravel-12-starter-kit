mkcert -cert-file ./certs/localhost.pem -key-file ./certs/localhost-key.pem "*.localhost" "localhost"

[ -f .env ] || cp .env.example .env

docker compose down && docker compose up -d --build --force-recreate
