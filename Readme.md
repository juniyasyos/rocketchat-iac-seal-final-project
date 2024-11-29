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