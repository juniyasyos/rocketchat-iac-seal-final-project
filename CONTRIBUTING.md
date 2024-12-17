Berikut adalah pembaruan file `CONTRIBUTING.md` yang mencakup penggunaan akun AWS, perintah deployment siap pakai dengan `./deploy`, serta opsi deployment dengan **Load Balancer** dan **Auto Scaling** atau tanpa keduanya.  

---

## CONTRIBUTING.md

# Kontribusi untuk Proyek Rocket.Chat Deployment menggunakan IaC

Terima kasih telah tertarik untuk berkontribusi pada proyek ini! Kami menyambut semua bentuk kontribusi, baik itu berupa kode, dokumentasi, perbaikan bug, atau saran untuk peningkatan. Panduan ini akan membantu Anda memahami cara berkontribusi dengan mudah dan efisien.

---

## 🛠️ Lingkup Proyek

Proyek ini berfokus pada:

- Penyusunan kode *Infrastructure as Code* (IaC) untuk deployment **Rocket.Chat**.
- Menggunakan alat seperti **Terraform**, **Ansible**, atau **Pulumi** untuk infrastruktur.
- Deployment siap pakai di akun AWS.
- Dukungan untuk dua opsi deployment:
   - **Dengan Load Balancer dan Auto Scaling**.
   - **Tanpa Load Balancer dan Auto Scaling**.
- Menyediakan dokumentasi yang jelas dan mudah diikuti.
- Otomatisasi deployment di berbagai lingkungan (*development*, *staging*, *production*).

---

## 📝 Panduan Umum Kontribusi

### 1. **Fork dan Clone Repository**
Fork proyek ini ke akun GitHub Anda dan clone repositori tersebut ke mesin lokal Anda:

```bash
git clone https://github.com/USERNAME/REPO_NAME.git
cd REPO_NAME
```

### 2. **Membuat Branch Fitur atau Perbaikan**
Buat branch baru untuk kontribusi Anda:

```bash
git checkout -b nama-branch-anda
```

Gunakan format nama branch yang deskriptif, misalnya:

- `feature/terraform-rocket-chat`
- `bugfix/fix-deployment-error`
- `docs/update-readme`

---

## 🚀 Deployment Rocket.Chat

Proyek ini menyediakan skrip **`./deploy`** untuk memudahkan deployment Rocket.Chat di AWS. Pastikan Anda memiliki akun **AWS** dan telah mengatur kredensialnya menggunakan AWS CLI.

### **Persyaratan Lingkungan:**
- Sistem Operasi: **Linux** (disarankan).
- **AWS CLI**: Terinstall dan dikonfigurasi dengan kredensial AWS Anda.
- Alat yang dibutuhkan:
   - **Terraform**: <https://www.terraform.io/downloads>
   - **Ansible** (jika diperlukan): <https://docs.ansible.com/ansible/latest/installation_guide/index.html>
   - **Docker** (opsional): <https://docs.docker.com/get-docker/>

### **Langkah Deployment:**

1. Pastikan kredensial AWS Anda sudah dikonfigurasi:

```bash
aws configure
```

2. Jalankan skrip `./deploy` untuk memulai deployment:

```bash
./deploy
```

3. Pilih opsi deployment:
   - **Dengan Load Balancer dan Auto Scaling**: Deployment akan membuat **Load Balancer** serta konfigurasi **Auto Scaling Group**.
   - **Tanpa Load Balancer dan Auto Scaling**: Deployment langsung menggunakan instance EC2 sederhana.

**Contoh Pemilihan Opsi:**
```bash
./deploy --mode=loadbalancer
./deploy --mode=single-server
```

4. Proses deployment akan:
   - Membuat infrastruktur di AWS menggunakan **Terraform**.
   - Menyiapkan server Rocket.Chat.
   - Menampilkan informasi akses akhir, seperti URL dan IP server.

---

## 🌐 Struktur Direktori

```bash
.
├── terraform/            # Konfigurasi Terraform untuk AWS
│   ├── modules/          # Modul modular Terraform
│   ├── main.tf           # Entry point Terraform
│   ├── variables.tf      # Variabel Terraform
│   └── outputs.tf        # Output informasi
│
├── ansible/              # Konfigurasi Ansible (jika diperlukan)
├── scripts/              # Skrip pendukung, termasuk `deploy`
├── README.md             # Panduan utama penggunaan
└── CONTRIBUTING.md       # Panduan kontribusi
```

---

## 🧑‍💻 Panduan Pengembangan Lokal

1. Pastikan Anda telah menginstal semua alat yang diperlukan.
2. Jalankan deployment lokal untuk menguji:

```bash
cd terraform/
terraform init
terraform plan
terraform apply
```

3. Untuk rollback atau menghancurkan infrastruktur:

```bash
terraform destroy
```

---

## ✅ Opsi Deployment

Proyek ini mendukung dua opsi deployment:

1. **Dengan Load Balancer dan Auto Scaling**:  
   - Membuat **Application Load Balancer (ALB)** di AWS.
   - Mengonfigurasi **Auto Scaling Group** untuk memastikan skalabilitas otomatis.
   - Cocok untuk lingkungan *production*.

2. **Tanpa Load Balancer dan Auto Scaling**:  
   - Menggunakan instance **EC2 tunggal** sebagai server.
   - Cocok untuk *development* atau skenario dengan sumber daya terbatas.

### Contoh Output:
Setelah deployment selesai, informasi berikut akan ditampilkan:

```plaintext
Rocket.Chat telah berhasil dideploy!

URL Akses: http://ec2-xx-xx-xx-xx.compute.amazonaws.com
Mode Deployment: Load Balancer
```

---

## 💡 Panduan Issue dan Fitur

Jika Anda menemukan masalah atau ingin mengusulkan fitur baru:

1. Buka tab **Issues** di repository GitHub.
2. Pilih **New Issue**.
3. Isi dengan format berikut:

### **Format Issue**
```
**Deskripsi singkat masalah:**
Berikan ringkasan dari masalah yang Anda hadapi.

**Langkah untuk Mereproduksi:**
1. Langkah pertama
2. Langkah kedua
3. Hasil yang diharapkan

**Lingkungan:**
- Alat yang digunakan: (contoh: Terraform v1.3.0, Ansible v2.10)
- Sistem Operasi: (Ubuntu 20.04, macOS, Windows)

**Catatan Tambahan:**
Informasi lain yang relevan.
```

---

## 🧭 Tools yang Digunakan

Proyek ini menggunakan:

- **Terraform**: untuk manajemen infrastruktur.
- **Ansible**: untuk otomatisasi konfigurasi server.
- **Docker**: untuk menjalankan Rocket.Chat dalam lingkungan kontainer (opsional).
- **AWS CLI**: untuk mengelola kredensial AWS.
- **GitHub Actions**: untuk CI/CD.

---

## 🎯 Konvensi dan Praktik Terbaik

- Ikuti [Terraform Best Practices](https://www.terraform-best-practices.com/).
- Dokumentasikan semua perubahan.
- Buat kode seefisien dan seramah mungkin terhadap *resource*.

---

## 🚀 Siap Berkontribusi?

Terima kasih atas minat dan usaha Anda untuk membuat proyek ini lebih baik! Jika Anda memiliki pertanyaan, jangan ragu untuk bertanya melalui [Issues](#) atau berdiskusi di *pull request*.

Selamat berkontribusi dan semoga sukses! 🎉

---  

### **Catatan:**  
Skrip `./deploy` dapat dikembangkan lebih lanjut untuk mendukung konfigurasi tambahan, seperti pemilihan database atau sertifikat SSL jika diperlukan.
