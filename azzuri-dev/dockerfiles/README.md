## How to use dockerfiles/

1. arahkan dulu terminal ke direktori `azzuri-dev/`
2. bikin image untuk tiap dockerfile
`docker build -t mongodb-image -f dockerfiles/mongodb/dockerfile .`
`docker build -t nginx-image -f dockerfiles/nginx/dockerfile .`
`docker build -t rocketchat-image -f dockerfiles/rocketchat/dockerfile .`
3. create network untuk ketiga image
`docker network create rocketchat-network`
4. jalankan container untuk ketiga image, IKUTI URUTAN YAA
`docker run -d --name mongodb --network rocketchat-network mongodb-image`
`docker run -d --name nginx --network rocketchat-network -p 80:80 -p 443:443 nginx-image`
`docker run -d --name rocketchat --network rocketchat-network   -e MONGO_URL=mongodb://mongodb:27017/rocketchat   -e ROOT_URL=http://localhost:3000   -e PORT=3000   -p 3000:3000 rocketchat-image`
5. akses rocketchat via https://localhost