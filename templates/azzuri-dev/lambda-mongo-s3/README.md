## About lambda-mongo-s3/

Folder ini dibuat untuk mengintegrasikan antara aws lambda, server mongoDB, dan S3. Perlu diperhatikan pada file `infra.tf`, ada beberapa part yang harus disesuaikan, yaitu `line 3 dan 81-83`. 

line (3) sesuaikan dengan region yang ditempati server rocketchat maupun mongodb nya. 
line (81-83) harus disinkronkan dengan file `.env` yang digunakan di server rocketchat dan mongoDB nya. 

Selain part tersebut, **jangan diutak-atik**. Setelah infrastruktur dibuat pakai terraform, nantinya akan digunakan image dari ECR buatan gua. Jadi sebetulnya gaperlu ngutak-ngatik lagi.

## Langkah-langkah development di local masing2 (jalanin container pakai docker desktop)

1. sinkronkan dulu variabel `.env` yang ada di server mongoDB dengan yang ada di `infra.tf` (line 78).
2. buat infrastrukturnya (lambda function dan s3 bucket) dengan `terraform init`, `terraform plan`, dan `terraform apply`
3. create image untuk lambda function dengan `docker build -t mongodb-backup .`
4. jalankan dan masuk ke dalam container nya dengan `docker run -it --entrypoint /bin/bash -e MONGODB_USER="<username-mongoDB>" -e MONGODB_PASS="<password-mongoDB>" mongodb-backup`
5. export aws credentials (lihat di "aws details" di lab kalian) menggunakan:
```
export AWS_ACCESS_KEY_ID=<punya-anda>
export AWS_SECRET_ACCESS_KEY=<punya-anda>
export AWS_SESSION_TOKEN=<punya-anda> 
```
6. trigger lambda function dengan `python -c 'import lambda_function; print(lambda_function.handler({}, {}))'`, tunggu beberapa saat (maybe more than 30 secs)
7. kalau lambda function berhasil jalan, nanti akan muncul beruntun list file yang akan di-backup. Sampai pada 
`{'statusCode': 200, 'body': 'Backup successful: rocketchat_backup_<timestamp-lah-intinya>.gz'}` tandanya database berhasil di-backup dan di-upload ke S3. Cek di _AWS console >> S3 >> Buckets >> rochat-backup >> mongodb-backups/_, nanti akan ada file `.gz` yang merupakan hasil backup.

## Langkah-langkah debug
1. jangan sampai ada typo di step (5) 
2. kalau masih gagal, lihat log error nya, perhatikan bagian `Using MongoDB URI: ...`. Pastikan username dan password kalian terbaca dan benar, kemudian pastikan ip server mongoDB dan port nya benar, dan pastikan diakhiri dengan `/rocketchat`