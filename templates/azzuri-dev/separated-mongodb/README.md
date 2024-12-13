## About separated-mongodb/

Folder ini dibuat untuk menjalankan rocketchat dan mongodb pada server yang berbeda. Rocketchat dan nginx pada server A, dan mongodb pada server B. Pastikan beberapa hal berikut:

1. pastikan keduanya dalam VPC yang sama dan subnet yg sama
2. pastikan keduanya bisa saling `ping` 
3. pastikan server A bisa terkoneksi dengan mongodb server B via `telnet <ip-private-server-B> <port-container-mongodb>`.

## Cara menjalankan 

1. arahkan path ke `separated-mongodb/`
2. buat file `.env` pada server A dan B yang berisi variabel berikut:
```
# ISI VALUE NYA YAAA
kkkMONGODB_VERSION=6.0
MONGODB_PORT_NUMBER=27017
MONGODB_REPLICA_SET_NAME=rs0
MONGODB_ADVERTISED_HOSTNAME=<ip-private-server-B>
MONGODB_ENABLE_JOURNAL=true
ALLOW_EMPTY_PASSWORD=no
MONGODB_ROOT_USER=<root-username-bebas>
MONGODB_ROOT_PASSWORD=<root-password-bebas>
MONGODB_REPLICA_SET_KEY=<generate-pakai-openssl> # openssl rand -base64 48 ; output digunakan di .env kedua server
MONGODB_DATABASE=<nama-database-bebas>
MONGODB_USERNAME=<username-database-bebas>
MONGODB_PASSWORD=<password-database-bebas>
ROOT_URL=https://localhost
PORT=3000
```
3. pada server B, jalankan `docker-compose -f new-mongodb.yml up -d`, pastikan container berhasil running
4. pada server A, buat folder `nginx/certs`, buat file `.crt` dan `.key`. Generate pakai `openssl`. Atur permission nya 
```
chmod 644 *.crt
chmod 600 *.key
```
5. pada server A, jalankan `docker-compose -f new-nginx-rc.yml up -d`, pastikan container berhasil running
6. tunggu sekitar 30 detik hingga container rocketchat bisa berjalan sepenuhnya. 
7. akses rocketchat pada `https://<ip-public-server-A>`
