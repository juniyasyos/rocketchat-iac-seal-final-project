# **rocketChat-team-iac**

**rocketChat-team-iac** adalah repository **Infrastructure as Code (IaC)** yang dirancang untuk mengelola infrastruktur aplikasi **RocketChat**. Repository ini mendukung tiga environment utama: **Development (Dev)**, **Staging (Stag)**, dan **Production (Prod)**, menggunakan kombinasi **Terraform** untuk provisioning dan **Ansible** untuk konfigurasi.


## **Fitur**
- Multi-environment: Dev, Stag, Prod
- Isolasi state file menggunakan **Terraform Workspaces**
- Deployment otomatis menggunakan **Ansible**
- Modular dan scalable untuk kebutuhan jangka panjang
- Integrasi dengan cloud provider AWS Service



## **Prasyarat**
Sebelum menggunakan repository ini, pastikan Anda memiliki:
1. **Tools yang diinstal:**
   - [Terraform](https://www.terraform.io/downloads.html) (v1.4.0 atau lebih baru)
   - [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
   - Python (dengan `pip install -r requirments.txt` untuk dependency yg Ansible)

2. **Kredensial Cloud:**
   - Konfigurasi kredensial untuk AWS Service


## **Struktur Repository**
```plaintext
.
├── ansible.cfg          # Konfigurasi Ansible
├── data.tf              # Data sources Terraform (e.g., AMI, VPC)
├── deploy               # Script deployment tambahan
├── environment/         # File variabel spesifik environment
│   ├── development.env  # Variabel untuk Dev
│   ├── staging.env      # Variabel untuk Stag
│   └── production.env   # Variabel untuk Prod
├── inventories/         # Inventori host untuk Ansible
├── locals.tf            # Variabel lokal Terraform
├── main.tf              # Konfigurasi utama Terraform
├── modules/             # Modul reusable Terraform
│   ├── compute/         # Modul untuk EC2 (example)
│   └── network/         # Modul untuk VPC
├── output.tf            # Output Terraform
├── playbooks/           # Playbooks Ansible
│   ├── setup.yml        # Playbook setup aplikasi
│   └── update.yml       # Playbook update aplikasi
├── requirements.txt     # Dependency Python untuk Ansible
├── roles/               # Roles Ansible
│   ├── rocket_chat/     # Role untuk aplikasi RocketChat
│   ├── docker/          # Role untuk setup awal 
|   └── monitoring       # Role untuk monitoring server
├── templates/           # Template file konfigurasi
└── terraform.tfstate.d/ # State files untuk Terraform Workspaces
```


## **Cara Penggunaan**

### **1. Terraform Workspaces**
Repository ini menggunakan Terraform Workspaces untuk mengisolasi environment:
1. **Melihat Workspaces:**
   ```bash
   terraform workspace list
   ```
3. **Beralih ke Workspace:**
   ```bash
   terraform workspace select development
   ```

### **2. Menjalankan Terraform**
1. **Inisialisasi Terraform:**
   Jalankan di direktori root:
   ```bash
   terraform init
   ```
2. **Deploy Infrastruktur:**
   Gunakan file variabel environment yang sesuai:
   ```bash
   terraform apply -var-file=environment/<nama_environment>.env
   ```
   Contoh:
   ```bash
   terraform apply -var-file=environment/development.env
   ```
3. **Melihat Output:**
   Setelah deploy, Terraform akan menampilkan output seperti alamat IP server.

### **3. Konfigurasi dengan Ansible**
Setelah infrastruktur dibuat, gunakan Ansible untuk mengatur aplikasi:
1. **Setup Host Inventori:**
   Edit file di `inventories/` sesuai dengan IP server yang dihasilkan oleh Terraform.
2. **Jalankan Playbook:**
   Contoh, untuk setup RocketChat:
   
   ```bash
   ansible-playbook -i inventories/development playbooks/setup.yml
   ```


## **Pengembangan**

### **Branching Workflow**
Gunakan **Git Flow** untuk pengembangan:
1. **Buat Branch Baru:**
   ```bash
   git checkout -b feature/<nama_fitur>
   ```
2. **Commit dan Push:**
   ```bash
   git commit -m "Deskripsi perubahan"
   git push origin feature/<nama_fitur>
   ```
3. **Merge ke `main`:**
   Lakukan Pull Request untuk review sebelum merge.


## **Environment Spesifik**

| **Environment**  | **Konfigurasi**                | **Kebutuhan Infrastruktur**     | **Penggunaan**                                    |
|------------------|--------------------------------|---------------------------------|---------------------------------------------------|
| **Development**  | `environment/development.env`  | Single AZ, Instance kecil       | Pengujian lokal dan eksperimen                    |
| **Staging**      | `environment/staging.env`      | Load Balancer, Instance sedang  | Simulasi sebelum produksi                         |
| **Production**   | `environment/production.env`   | Multi-AZ, Instance besar        | Infrastruktur live untuk pengguna akhir           |

---

## **Troubleshooting**

### **1. Terraform Issues**
- **Error: "Could not load remote state":**
  Pastikan workspace Terraform sudah benar:
  ```bash
  terraform workspace select <nama_workspace>
  ```
- **Error saat deploy:**
  Periksa file variabel environment.

### **2. Ansible Issues**
- **Host Unreachable:**
  Pastikan server dapat diakses dengan SSH dan file inventori sudah benar.
- **Error Playbook:**
  Jalankan playbook dengan opsi `--check` untuk mode simulasi:
  
  ```bash
  ansible-playbook -i playbooks/<playbook.yml> --check
  ```

# **Monitoring Setup**

## **1. Setup Prometheus dan Grafana**
### **a. Akses Prometheus**
1. Buka browser Anda dan akses:  
   ```
   http://<public-ip-tag-monitoring-testing-k6>:9099
   ```
   Untuk IP server, lihat output terakhir dari `./deploy`, yang mencantumkan dua instance. Pilih IP dengan tag:  
   **`tag_monitoring_testing_k6`**

2. Verifikasi *target status* di Prometheus:  
   ![Prometheus](docs/prometheus.png)

---

### **b. Login ke Grafana**
1. Buka browser Anda dan akses Grafana:  
   ```
   http://<public-ip-instance-tag-learning-monitoring>:3030
   ```
2. Login dengan kredensial berikut:  
   - **Username:** `admin`  
   - **Password:** `my-password-grafana`  

---

### **c. Setup Dashboard Grafana**
1. Masuk ke menu **"Create" > "Import"** di Grafana.  
2. Gunakan file dashboard.json dari repositori berikut:  
   ```
   https://github.com/nginxinc/nginx-prometheus-exporter/blob/main/grafana/dashboard.json
   ```
3. Pilih data source **Prometheus** (tambahkan secara manual jika tidak ada), lalu klik **Import**.  

   ![Grafana Dashboard](docs/setup-datasource-prometheus.png)

4. Verifikasi tampilan dashboard sesuai contoh berikut

   ![Grafana Dashboard](docs/grafana-dashboard.png)

---

## **4. Melakukan Testing dengan Grafana K6**
### **a. Persiapan Instance Testing**
1. Gunakan server kedua untuk menjalankan K6. Akses server dengan SSH:  
   ```bash
   ssh -i monitoring ubuntu@<ip-tag-testing-k6>
   ```
   IP server tersedia di output terakhir `./deploy` dengan tag:  
   **`testing_k6`**

2. Pastikan Anda masuk ke direktori kerja K6:
   ```bash
   cd /opt/k6_repo
   ```

---

### **b. Membuat Script Pengujian K6**
Buat file `load.js` di dalam direktori `/opt/k6_repo/test/` dengan isi berikut:

```javascript
import http from "k6/http";
import { check, sleep } from "k6";

// Test configuration
export const options = {
    thresholds: {
        // Assert that 99% of requests finish within 3000ms
        http_req_duration: ["p(99) < 3000"],
    },
    stages: [
        { duration: "30s", target: 15 },
        { duration: "1m", target: 15 },
        { duration: "20s", target: 0 },
    ],
};

// Simulated user behavior
export default function () {
    let res = http.get("http://<ip-nginx-target>/stub_status");
    check(res, { "status was 200": (r) => r.status == 200 });
    sleep(1);
}
```
- **`<ip-nginx-target>`** adalah IP instance Nginx Anda (yang menjalankan Prometheus).

---

### **c. Menjalankan Pengujian dengan Docker**
Gunakan perintah berikut untuk menjalankan pengujian:
```bash
docker run -v /opt/k6_repo:/opt/k6_repo grafana/k6 run --out influxdb=http://<ip-vm-testing>:8086 /opt/k6_repo/test/load.js
```
- **`<ip-vm-testing>`** adalah IP instance yang menjalankan InfluxDB dan ip yg digunakan bisa private atau public. 

maka akan terjadi proses seperti ini 

![Proces testing k6](docs/proses-testing-k6.png)

![Result Testing](docs/final-testing-result.png)

Berikut penjelasan dari output tersebut:

- **Tes berhasil**: Semua permintaan HTTP berhasil dengan status 200, tanpa ada yang gagal.
- **Kecepatan**: Rata-rata server merespons dalam 1.2ms, sangat cepat.
- **Data**: 329 kB data diterima dan 115 kB data dikirim.
- **Kecepatan permintaan**: 11.7 permintaan per detik.
- **Virtual Users (VUs)**: Tes dilakukan dengan 1 hingga 15 pengguna virtual, dengan 1290 permintaan total.

tes menunjukkan performa yang baik dan server berfungsi dengan sangat baik.

---

### **Catatan Penting**
- **Jaringan Internal atau Public:**  
  Jika menggunakan private IP, pastikan kedua instance berada dalam satu VPC atau jaringan lokal. Jika menggunakan public IP, pastikan security group dan firewall mengizinkan koneksi.

- **Validasi Script:**  
  Cek endpoint Nginx (`/stub_status`) dengan curl:  
  ```bash
  curl http://<ip-nginx-target>/stub_status
  ```

---


## **Penyempurnaan Mendatang**
- **CI/CD Integration:**
  Menambahkan pipeline untuk deployment otomatis.
- **Monitoring Tools:**
  Mengintegrasikan Prometheus dan Grafana.
- **Testing Infrastructure:**
  Menambahkan tes otomatis untuk validasi IaC.

---

Semoga panduan ini membantu dalam pengelolaan dan pengembangan proyek ini. 😊