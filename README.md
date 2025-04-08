# 🌟 Miss Blum Task Automator

Script Ruby untuk mengotomatiskan eksekusi tugas di Miss Blum. Dibuat untuk mempermudah proses berulang dengan aman dan efisien.

---

## 🚀 Fitur Utama
- Mengambil `userId` dari file `data.txt`
- Memperbarui sesi secara otomatis
- Mengeksekusi tugas dari `task-001` hingga `task-026`
- Logging status untuk setiap langkah
- Penanganan error yang robust

---

## 📋 Prasyarat
Sebelum memulai, pastikan Anda memiliki:
- Ruby (versi 2.7 atau lebih tinggi) terinstal di sistem Anda
- Gem `httparty` untuk komunikasi HTTP
- File `data.txt` dengan format URL-encoded yang berisi informasi user (contoh: `user={"id":12345}`)

---

## 🛠️ Cara Instalasi
1. **Clone Repository**
   ```bash
   git clone https://github.com/Yuurichan-N3/MissBlum-Miniapp.git
   cd MissBlum-Miniapp
   ```

2. **Instal Dependensi**
   Jalankan perintah berikut untuk menginstal gem yang dibutuhkan:
   ```bash
   gem install httparty
   ```

3. **Siapkan File `data.txt`**
   - Buat file `data.txt` di direktori yang sama dengan script
   - Masukkan data user dalam format URL-encoded, contoh:
     ```
     user=%7B%22id%22%3A12345%7D
     ```
   - Pastikan data valid dan berisi `id` user

---

## ▶️ Cara Penggunaan
1. **Jalankan Script**
   Dari terminal, ketik:
   ```bash
   bot.rb
   ```

2. **Pantau Output**
   - Script akan menampilkan banner dan memproses tugas satu per satu
   - Setiap langkah akan dilog dengan status code (200 untuk sukses, 400 untuk gagal)
   - Contoh output:
     ```
     Session berhasil diperbarui!
     Status code: 200
     Task task-001 berhasil diselesaikan!
     Status code: 200
     ```

3. **Hentikan Jika Diperlukan**
   Tekan `Ctrl+C` untuk menghentikan eksekusi kapan saja

---

## 📂 Struktur File
- `bot.rb`: Script utama
- `data.txt`: File input berisi userId (harus dibuat manual)
- `README.md`: Dokumentasi ini

---

## ⚠️ Catatan Penting
- Pastikan koneksi internet stabil
- Script akan berhenti jika sesi gagal diperbarui
- Simpan `data.txt` dengan benar untuk menghindari error parsing

---

## 📜 Lisensi
Script ini didistribusikan untuk keperluan pembelajaran dan pengujian. Penggunaan di luar tanggung jawab pengembang.

Untuk update terbaru, bergabunglah di grup **Telegram**: [Klik di sini](https://t.me/sentineldiscus).

---

## 💡 Disclaimer
Penggunaan bot ini sepenuhnya tanggung jawab pengguna. Kami tidak bertanggung jawab atas penyalahgunaan skrip ini.
