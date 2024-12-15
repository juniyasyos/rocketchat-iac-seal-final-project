#!/bin/bash

# Fungsi untuk memastikan skrip dijalankan dengan hak akses sudo
ensure_root() {
  if [[ "$EUID" -ne 0 ]]; then
    echo "Silakan jalankan skrip ini dengan sudo."
    exit 1
  fi
}

# Pastikan user menggunakan sudo
ensure_root

# Update dan install dependensi
apt update -y
apt install -y apt-transport-https ca-certificates curl software-properties-common

# Tambahkan kunci GPG Docker dan install Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
apt update -y
apt install -y docker-ce
usermod -aG docker "$USER"

# Install Docker Compose
DOCKER_COMPOSE_BIN="/usr/local/bin/docker-compose"
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o $DOCKER_COMPOSE_BIN
chmod +x $DOCKER_COMPOSE_BIN

# Clone repositori Rocket.Chat
REPO_DIR="/home/$USER/seal-final"
if [[ ! -d "$REPO_DIR" ]]; then
  git clone https://github.com/juniyasyos/rocket-chat-seal-project.git "$REPO_DIR"
else
  echo "Direktori $REPO_DIR sudah ada. Lewati cloning."
fi

cd "$REPO_DIR" || exit 1

# Buat file .env jika belum ada
ENV_FILE=".env"
if [[ ! -f "$ENV_FILE" ]]; then
  cat <<EOL >"$ENV_FILE"
MONGODB_VERSION=6.0
MONGODB_REPLICA_SET_NAME=rs0
MONGODB_ADVERTISED_HOSTNAME=10.0.2.116
MONGODB_ENABLE_JOURNAL=true
ALLOW_EMPTY_PASSWORD=no
MONGODB_ROOT_USER=admin
MONGODB_ROOT_PASSWORD=passworddevelopmentservermongodb12
MONGODB_REPLICA_SET_KEY=3F1FCCBS0RhyuUm3AHcfbIQVYBqNPujFd2RqtvDxRL5g2HT0QVaJFoje0ws+L7
MONGODB_HOST=10.0.2.116
MONGODB_PORT_NUMBER=27017
MONGODB_DATABASE=rocketchat
MONGO_AUTH_SOURCE=admin
EOL
else
  echo "File $ENV_FILE sudah ada. Lewati pembuatan."
fi

# Buat direktori sertifikat jika belum ada
CERTS_DIR="/home/$USER/rocket-chat/nginx/certs"
mkdir -p "$CERTS_DIR"

# Generate sertifikat SSL jika belum ada
CERT_KEY="$CERTS_DIR/server.key"
CERT_CRT="$CERTS_DIR/server.crt"

if [[ ! -f "$CERT_KEY" || ! -f "$CERT_CRT" ]]; then
  openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout "$CERT_KEY" \
    -out "$CERT_CRT" \
    -subj "/C=US/ST=State/L=City/O=Organization/OU=IT/CN=localhost"
  echo "Sertifikat SSL dibuat di $CERTS_DIR."
else
  echo "Sertifikat SSL sudah ada. Lewati pembuatan."
fi

# Set izin file
chmod 0644 "$CERT_CRT"
chmod 0600 "$CERT_KEY"

# Jalankan Rocket.Chat dengan Docker Compose
DOCKER_COMPOSE_FILE="/home/$USER/rocket-chat/nginx-rochat.yml"
if [[ -f "$DOCKER_COMPOSE_FILE" ]]; then
  docker compose -f "$DOCKER_COMPOSE_FILE" up -d
  echo "Rocket.Chat dijalankan menggunakan Docker Compose."
else
  echo "File Docker Compose $DOCKER_COMPOSE_FILE tidak ditemukan. Pastikan file tersedia."
fi
