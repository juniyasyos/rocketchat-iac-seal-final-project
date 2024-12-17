#!/bin/bash

# Pastikan dijalankan sebagai root
[ "$EUID" -ne 0 ] && exit 1

# Cek dan instal Ansible jika belum ada
command -v ansible &>/dev/null || (sudo apt update -y && sudo apt install -y ansible)

# Variabel
REPO_URL="https://github.com/juniyasyos/rocket-chat-seal-project.git"
CLONE_DIR="/home/ubuntu/repo"
ROCKET_CHAT_DIR="/home/ubuntu/rocket-chat"
CERTS_DIR="$ROCKET_CHAT_DIR/nginx/certs"

# Bersihkan direktori lama dan kloning ulang repositori
rm -rf "$CLONE_DIR"
git clone "$REPO_URL" "$CLONE_DIR" || exit 1

# Pindahkan template ke direktori tujuan
mkdir -p "$ROCKET_CHAT_DIR"
cp -rf "$CLONE_DIR/templates/"* "$ROCKET_CHAT_DIR/" || exit 1

# Buat sertifikat SSL
mkdir -p "$CERTS_DIR"
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout "$CERTS_DIR/server.key" \
  -out "$CERTS_DIR/server.crt" \
  -subj "/C=US/ST=State/L=City/O=Organization/OU=IT/CN=localhost" || exit 1
chmod 0644 "$CERTS_DIR/server.crt"
chmod 0600 "$CERTS_DIR/server.key"

# Buat file .env untuk MongoDB
cat > "$ROCKET_CHAT_DIR/.env" <<EOL
MONGODB_VERSION=6.0
MONGODB_REPLICA_SET_NAME=rs0
MONGODB_ADVERTISED_HOSTNAME=10.100.2.209
MONGODB_ENABLE_JOURNAL=true
ALLOW_EMPTY_PASSWORD=no
MONGODB_ROOT_USER=admin
MONGODB_ROOT_PASSWORD=passworddevelopmentservermongodb12
MONGODB_REPLICA_SET_KEY=3F1FCCBS0RhyuUm3AHcfbIQVYBqNPujFd2RqtvDxRL5g2HT0QVaJFoje0ws+L7
MONGODB_HOST=10.100.2.209
MONGODB_PORT_NUMBER=27017
MONGODB_DATABASE=rocketchat
MONGO_AUTH_SOURCE=admin
EOL

# Jalankan playbook Ansible
cd "$CLONE_DIR"
ansible-playbook -i inventory.ini playbooks/setup/docker.yaml || exit 1

# Jalankan Docker Compose
docker-compose -f "$ROCKET_CHAT_DIR/nginx-rochat.yml" up -d || exit 1
