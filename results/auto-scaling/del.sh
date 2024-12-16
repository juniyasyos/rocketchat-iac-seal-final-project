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

# Hentikan semua container yang sedang berjalan
echo "Menghentikan semua container Docker..."
docker-compose down
docker stop $(docker ps -aq)

# Menghapus semua container yang ada
echo "Menghapus semua container..."
docker rm $(docker ps -aq)

# Menghapus semua image Docker
echo "Menghapus semua image Docker..."
docker rmi $(docker images -q)

# Menghapus semua volume Docker
echo "Menghapus semua volume Docker..."
docker volume rm $(docker volume ls -q)

# Menghapus semua jaringan Docker yang tidak terpakai
echo "Menghapus semua jaringan Docker yang tidak terpakai..."
docker network prune -f

# Menghentikan layanan Docker
echo "Menghentikan Docker..."
systemctl stop docker

# Menghapus Docker dan dependensinya
echo "Menghapus Docker dan dependensinya..."
apt-get purge -y docker-ce docker-ce-cli containerd.io

# Menghapus file yang terkait dengan Docker
echo "Menghapus file yang terkait dengan Docker..."
rm -rf /var/lib/docker
rm -rf /etc/docker
rm -rf /var/run/docker.sock
rm -rf /etc/systemd/system/docker.service.d
sudo rm /etc/apt/sources.list.d/docker.list
sudo rm /usr/share/keyrings/docker-archive-keyring.gpg

# Menghapus Docker Compose
echo "Menghapus Docker Compose..."
rm -f /usr/local/bin/docker-compose

# Menghapus dependensi yang tidak terpakai
echo "Menghapus dependensi yang tidak terpakai..."
apt-get autoremove -y

# Menjalankan update untuk memastikan tidak ada paket yang tertinggal
echo "Melakukan update sistem..."
apt-get update -y

echo "Proses selesai. Docker dan Docker Compose beserta dependensinya telah dihapus."
