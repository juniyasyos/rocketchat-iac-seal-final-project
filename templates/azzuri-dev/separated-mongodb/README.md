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
MONGODB_VERSION=6.0
MONGODB_REPLICA_SET_NAME=rs0
MONGODB_ADVERTISED_HOSTNAME=<ip-private-server-B>
MONGODB_ENABLE_JOURNAL=true
ALLOW_EMPTY_PASSWORD=no
MONGODB_ROOT_USER=<username-mongodb>
MONGODB_ROOT_PASSWORD=<password-mongodb>
MONGODB_REPLICA_SET_KEY=<generate-pakai-openssl>
MONGODB_HOST=<ip-private-server-B> 
MONGODB_PORT_NUMBER=<port-container-mongodb>
MONGODB_DATABASE=rocketchat
MONGO_AUTH_SOURCE=<username-mongodb>
```
3. pada server B, jalankan `docker-compose -f mongodb.yml up -d`, pastikan container berhasil running
4. pada server A, buat folder `nginx/certs`, buat file `.crt` dan `.key`. Atur permission nya 
```
chmod 644 *.crt
chmod 600 *.key
```
5. pada server A, jalankan `docker-compose -f nginx-rochat.yml up -d`, pastikan container berhasil running
6. tunggu sekitar 1 menit hingga container rocketchat bisa berjalan sepenuhnya. 
7. akses rocketchat pada `https://<ip-public-server-A>`
