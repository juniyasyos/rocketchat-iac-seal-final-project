Directory azzuri-dev/ gua pake untuk development dan coba-coba. Sejauh ini, container rocketchat bisa dijalankan dan diakses via https://localhost. Berikut stepnya:

1. Pastikan sudah menginstall docker-compose dan docker desktop (klo ada alternatif lain silahkan coba)
2. Buat SSL certificate menggunakan `openssl`, simpan dalam folder `nginx/certs/`. Pastikan ada file `.crt` dan `.key`
2. Jalankan `docker-compose up -d` pada direktori ini
3. Setelah container berhasil dibuat, tunggu sekitar 10 detik sambil dicoba akses `https://localhost`
4. Akan ada warning karena SSL certificate masih self-signed, pilih advance>>proceed to page (kurang lebih keterangannya gitu), dan hwalaaa rocketchat bisa jalan via https