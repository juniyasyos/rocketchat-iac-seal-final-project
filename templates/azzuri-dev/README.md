Directory templates/azzuri-dev/ gua pake untuk development dan coba-coba. Sejauh ini, container rocketchat bisa dijalankan dan diakses via https://localhost. Berikut stepnya:

1. Pastikan sudah menginstall docker-compose dan docker desktop (klo ada alternatif lain silahkan coba)
2. Buat SSL certificate menggunakan `openssl`, simpan dalam folder `nginx/certs/`. Pastikan ada file `.crt` dan `.key`
2. Jalankan `docker-compose up -d` pada direktori ini
3. Setelah container berhasil dibuat, tunggu sekitar 10 detik sambil dicoba akses `https://localhost`
4. Akan ada warning karena SSL certificate masih self-signed, pilih advance>>proceed to page (kurang lebih keterangannya gitu), dan hwalaaa rocketchat bisa jalan via https

# Tentang automatic-updates.yml

Pastikan sudah men-generate github token (personal access token / PAT). Copy, lalu simpan di _secrets_ dengan nama TOKEN_GITHUB.

_automatic-updates.yml_ akan running tiap 15 menit sekali (sesuai dengan yg di _docker.official.image_ github). Tapi sudah dimodifikasi sehingga bisa di trigger secara manual di menu **Actions**.

Github action sudah bisa mendeteksi perubahan pada file docker compose di root directory maupun di subdirectory. Tinggal tambahin aja path file docker compose di bagian `const files` di _automatic-updates.yml_. Saat pertama kali github action berjalan, akan muncul branch baru bernama `update-branch`. Itu tidak masalah, memang scriptnya berjalan seperti itu. Setiap perubahan harus dilakukan pada branch yg ada di bagian `base: ` (scroll ke bawah _automatic-updates.yml_). Perubahan yang dilakukan di branch `update-branch` tidak akan terdeteksi.

Setelah github action berjalan, dia akan menyinkronkan semua file pada branch `development` (karena `base: development` pada _automatic-updates.yml_) ke branch `update-branch` (karena `branch: update-branch` pada _automatic-updates.yml_). Intinya, branch `update-branch` akan menyinkronkan dirinya dengan branch `development`, bukan sebaliknya.
