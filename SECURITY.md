# SECURITY.md

## 📜 Pendahuluan

Keamanan adalah prioritas utama dalam proyek ini. Dokumen ini memberikan panduan kepada kontributor dan pengguna untuk:

1. Melaporkan kerentanan keamanan.
2. Menangani masalah terkait keamanan dalam kode atau konfigurasi.
3. Menerapkan praktik keamanan terbaik dalam pengembangan.

---

## 🛡️ **Cara Melaporkan Kerentanan Keamanan**

Jika Anda menemukan potensi kerentanan keamanan atau masalah keamanan lainnya dalam proyek ini, harap **TIDAK** melaporkannya di forum publik seperti Issues atau Pull Requests.

### 📧 Langkah Melaporkan:

1. **Kirim Email** ke tim pengelola proyek di:  
   **[ahmadilyasdahlan@gmail.com](ilyas:ahmadilyasdahlan@gmail.com)**  
2. Berikan detail berikut dalam laporan Anda:  
   - **Deskripsi masalah** yang jelas dan ringkas.  
   - **Langkah reproduksi** jika memungkinkan.  
   - Dampak potensial dari kerentanan.  
   - Informasi lingkungan (*misalnya*, versi Terraform, Ansible, OS, dsb.).  
3. Sertakan informasi kontak jika kami memerlukan klarifikasi tambahan.

### 🔐 Privasi Laporan

- Semua laporan kerentanan akan ditangani dengan kerahasiaan penuh.
- Kami akan bekerja untuk memverifikasi dan menyelesaikan masalah secepat mungkin.

---

## 🧩 **Praktik Keamanan Terbaik**

### 1. **Pengelolaan Kredensial Aman**
   - **Jangan pernah memasukkan kredensial atau secret API key** secara langsung di file konfigurasi.
   - Gunakan **AWS Secrets Manager**, **HashiCorp Vault**, atau variabel lingkungan (`ENV`).

   Contoh buruk:  
   ```hcl
   aws_access_key = "AKIAXXXXXX"
   aws_secret_key = "1234567890"
   ```

   Contoh yang benar:  
   ```bash
   export AWS_ACCESS_KEY_ID=AKIAXXXXXX
   export AWS_SECRET_ACCESS_KEY=1234567890
   ```

### 2. **Konfigurasi Firewall dan Akses Jaringan**
   - Batasi akses ke **instance EC2** hanya ke IP yang dipercaya.
   - Terapkan **Security Group** yang membatasi port yang terbuka (misalnya hanya `80` dan `443`).

### 3. **Gunakan Protokol Aman**
   - Selalu gunakan **HTTPS** untuk mengakses Rocket.Chat.
   - Pastikan komunikasi antara server dan database dienkripsi.

### 4. **Perbarui Dependensi**
   - Gunakan versi terbaru dari Terraform, Ansible, dan dependensi lainnya.
   - Secara berkala lakukan audit keamanan menggunakan alat seperti `tfsec`, `checkov`, atau `trivy`.

### 5. **Pengaturan IAM Roles**
   - Gunakan **AWS IAM Roles** untuk memberikan akses minimal ke instance EC2 atau layanan lainnya.
   - Jangan gunakan akun root AWS untuk deployment.

### 6. **Enkripsi Data**
   - Gunakan **AWS KMS** atau alat lain untuk mengenkripsi data sensitif di **S3** atau database.
   - Pastikan enkripsi diaktifkan untuk EBS (Elastic Block Store).

---

## 🚀 **Audit Keamanan dan Validasi Infrastruktur**

Sebelum melakukan deployment, pastikan Anda memeriksa keamanan dengan langkah-langkah berikut:

1. **Validasi Terraform**  
   Jalankan perintah berikut untuk memastikan tidak ada kesalahan konfigurasi:  
   ```bash
   terraform validate
   terraform plan
   ```

2. **Audit Keamanan Menggunakan tfsec atau Checkov**  
   Contoh menggunakan `tfsec`:  
   ```bash
   tfsec .
   ```

3. **Pastikan Tidak Ada Kredensial yang Bocor**  
   Gunakan alat seperti `git-secrets` atau `truffleHog` untuk memeriksa kebocoran kredensial di repositori.  
   ```bash
   git-secrets --scan
   ```

---

## 🔄 **Kebijakan Patching dan Pembaruan**

- Tim akan berupaya untuk merilis **patch keamanan** segera setelah kerentanan diverifikasi.
- Semua kontributor dan pengguna diharapkan untuk **memperbarui deployment** secepat mungkin setelah pembaruan dirilis.

---

## 🛠️ **Tools Keamanan yang Disarankan**

Kami menyarankan penggunaan alat berikut untuk memeriksa keamanan proyek:

- **tfsec**: Audit keamanan untuk konfigurasi Terraform.  
   <https://github.com/aquasecurity/tfsec>  
- **Checkov**: Pemindai keamanan untuk infrastruktur *as code*.  
   <https://github.com/bridgecrewio/checkov>  
- **AWS Inspector**: Audit keamanan untuk instance EC2.  
   <https://aws.amazon.com/inspector/>  
- **Trivy**: Pemindai keamanan untuk container image.  
   <https://github.com/aquasecurity/trivy>

---

## 🤝 **Kolaborasi untuk Keamanan**

Keamanan adalah tanggung jawab bersama. Jika Anda melihat praktik tidak aman atau memiliki saran perbaikan keamanan, silakan:

- Membuka **Issue** dengan label `security` untuk saran keamanan (tanpa merinci kerentanan).  
- Menghubungi tim keamanan langsung melalui email: [security@example.com](mailto:security@example.com).

---

## 🛡️ **Komitmen Kami**

Kami berkomitmen untuk menangani semua laporan keamanan dengan serius. Tim kami akan:

1. Menanggapi laporan keamanan dalam waktu **24 jam**.
2. Memberikan pembaruan progres penyelesaian.
3. Menginformasikan solusi atau patch yang tersedia.

---

Terima kasih telah membantu menjaga keamanan proyek ini! Dengan kontribusi Anda, kita bisa membuat **Rocket.Chat IaC Deployment** lebih aman dan andal. 🚀
