## How to use dockerfiles/

1. arahkan dulu terminal ke direktori `azzuri-dev/`
2. bikin image untuk tiap dockerfile
`docker build -t mongodb-image -f dockerfiles/mongodb/dockerfile .`
`docker build -t nginx-image -f dockerfiles/nginx/dockerfile .`
`docker build -t rocketchat-image -f dockerfiles/rocketchat/dockerfile .`
3. create network untuk ketiga image
`docker network create rocketchat-network`
4. jalankan container untuk ketiga image, IKUTI URUTAN YAA
```docker run -d --name mongodb --network rocketchat-network mongodb-image```
```docker run -d --name nginx --network rocketchat-network -p 80:80 -p 443:443 nginx-image```
```docker start nginx```
```
# run ini sekaligus
docker run -d --name rocketchat \
  --network rocketchat-network \
  -e MONGO_URL=mongodb://mongodb:27017/rocketchat \
  -e ROOT_URL=https://localhost \
  -e PORT=3000 \
  rocketchat-image
```
5. akses rocketchat via https://localhost

## Jika ingin mengulang dari awal
1. hapus semua container yg ada, bisa manual via docker desktop atau `docker ps` dulu baru kemudian di delete satu per satu sesuai ID nya.
2. hapus semua image yang telah dibuat sebelumnya. biar praktis, pakai `docker image prune -a` biar sekalian hapus semua image yg ada (yaaa karena kita cuma butuh 3 image untuk ngejalanin rocketchat ini)
