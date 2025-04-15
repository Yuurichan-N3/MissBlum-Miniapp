## Miss Blum Task Automator

adalah skrip Node.js untuk mengotomatiskan tugas di platform **Miss Blum**, seperti check-in harian, menyelesaikan tugas, menambah tiket melalui tap-to-earn, dan voting untuk influencer. Skrip ini dirancang untuk mempermudah pengguna dengan antarmuka CLI yang interaktif, log berwarna, dan penanganan error yang andal.

> ⚠️ **Peringatan**: Gunakan skrip ini dengan bijak dan sesuai aturan platform Miss Blum. Pengembang tidak bertanggung jawab atas penyalahgunaan.

## 📋 Fitur

- **Check-In Harian**: Otomatis melakukan check-in untuk mendapatkan tiket.
- **Eksekusi Tugas**: Mendukung 25+ tugas seperti mengikuti akun sosial media, bergabung dengan grup, dan lainnya.
- **Tap-to-Earn**: Tambah tiket (1-5 per sesi) dengan request satu per satu dan delay acak 30-60 detik.
- **Voting Influencer**: Vote untuk kandidat (Luna Kim, Kwon Star, Song Yi) dengan jumlah tiket yang fleksibel.
- **Log Berwarna**: Log dalam bahasa Indonesia dengan warna berbeda untuk sukses (hijau), error (merah), info (biru), dan peringatan (kuning).
- **Tampilan Tabel**: Menampilkan daftar tugas dalam format tabel menggunakan `cli-table3`.
- **Efek Gradasi**: Pesan penting ditampilkan dengan gradasi oranye-biru menggunakan `gradient-string`.
- **Penanganan Error**: Fallback aman untuk `gradient-string` dan validasi input ketat.

## 🚀 Cara Instalasi

1. **Prasyarat**:
   - [Node.js](https://nodejs.org/) (disarankan v20 LTS, karena v23.x mungkin memiliki masalah kompatibilitas).
   - Akses ke file `data.txt` yang berisi `initData` dari platform Miss Blum.

2. **Clone Repository**:
   ```bash
   git clone https://github.com/Yuurichan-N3/MissBlum-Miniapp.git
   cd MissBlum-Miniapp
   ```

3. **Install Dependensi**:
   ```bash
   npm install
   ```
   Atau secara spesifik:
   ```bash
   npm install axios querystring cli-table3 colors gradient-string
   ```

4. **Siapkan `data.txt`**:
   - Buat file `data.txt` di direktori proyek.
   - Isi dengan `initData` yang berisi informasi `userId` (contoh: `user=%7B%22id%22%3A123456%7D`).
   - Pastikan file memiliki izin baca (khususnya di Android/Termux).

## 🛠️ Cara Penggunaan

1. **Jalankan Skrip**:
   ```bash
   node bot.js
   ```

2. **Interaksi**:
   - **Banner**: Muncul dalam bahasa Inggris dengan warna biru.
   - **Tugas Tambahan**: Pilih `y` untuk menjalankan semua tugas atau `n` untuk hanya check-in.
   - **Tap-to-Earn**: Masukkan jumlah tiket (1-5) setelah check-in. Request dikirim satu per satu dengan delay 40-50 detik.
   - **Voting**: Pilih influencer (1-3) dan masukkan jumlah tiket, atau ketik `0` untuk keluar.

3. **Contoh Output**:
   ```
   ╔══════════════════════════════════════════════╗
   ║       🌟 MISS BLUM TASK AUTOMATOR            ║
   ║   Automate your task execution on Miss Blum! ║
   ║  Developed by: https://t.me/sentineldiscus   ║
   ╚══════════════════════════════════════════════╝
   User ID ditemukan: 123456
   Daftar Tugas Tersedia:
   ┌───────────────┬──────────────────────────────┐
   │ ID Tugas      │ Nama Tugas                   │
   ├───────────────┼──────────────────────────────┤
   │ task-001      │ Check-In Harian              │
   ...
   Apakah ingin mengerjakan tugas lain selain check-in harian? (y/n): n
   Berhasil check-in! Sisa tiket: 5
   Masukkan jumlah tiket untuk tap-to-earn (1-5): 2
   Mengirim request untuk tiket ke-1 dari 2...
   Berhasil menambah 1 tiket dari 200 tap (tiket ke-1)
   Sisa tiket: 6
   Menunggu 40-50 detik sebelum request berikutnya...
   ```

## 📦 Dependensi

| Paket            | Versi        | Fungsi                              |
|------------------|--------------|-------------------------------------|
| axios            | ^1.7.7       | HTTP requests ke API Miss Blum      |
| querystring      | Node built-in| Parsing initData dari data.txt      |
| cli-table3       | ^0.6.5       | Menampilkan tabel tugas             |
| colors           | ^1.4.0       | Pewarnaan log (hijau, merah, dll.)  |
| gradient-string  | ^2.0.2       | Efek gradasi untuk pesan penting    |

## 📂 Struktur File

```
miss-blum-task-automator/
├── bot.js         # Skrip utama untuk otomasi tugas
├── data.txt        # File berisi initData (harus dibuat manual)
├── package.json    # Konfigurasi proyek dan dependensi
└── README.md       # Dokumentasi ini
```

## 🐛 Troubleshooting

- **Error `gradient is not a function`**:
  - Update `gradient-string`:
    ```bash
    npm install gradient-string@latest
    ```
  - Atau downgrade Node.js ke v20:
    ```bash
    nvm install 20
    nvm use 20
    npm install
    ```
- **File `data.txt` tidak ditemukan**:
  - Pastikan file ada di direktori proyek dan berisi `initData` yang valid.
- **Masalah koneksi**:
  - Periksa jaringan atau izin akses (khususnya di Termux/Android).
- **Log tidak berwarna**:
  - Pastikan terminal mendukung ANSI colors (Termux seharusnya mendukung).

## 🙌 Kontribusi

Kami menyambut kontribusi! Silakan:
1. Fork repository ini.
2. Buat branch baru: `git checkout -b fitur-anda`.
3. Commit perubahan: `git commit -m "Menambah fitur X"`.
4. Push ke branch: `git push origin fitur-anda`.
5. Buat Pull Request.

## 📜 Lisensi

Script ini didistribusikan untuk keperluan pembelajaran dan pengujian. Penggunaan di luar tanggung jawab pengembang.

Untuk update terbaru, bergabunglah di grup **Telegram**: [Klik di sini](https://t.me/sentineldiscus).

---

## 💡 Disclaimer
Penggunaan bot ini sepenuhnya tanggung jawab pengguna. Kami tidak bertanggung jawab atas penyalahgunaan skrip ini.
```

   - Solusi untuk masalah umum seperti error `gradient-string`, file tidak ditemukan, atau masalah koneksi.

8. **Kontribusi**:
   - Panduan sederhana untuk berkontribusi agar ramah untuk open-source.

## 📜 Lisensi  

Script ini didistribusikan untuk keperluan pembelajaran dan pengujian. Penggunaan di luar tanggung jawab pengembang.  

Untuk update terbaru, bergabunglah di grup **Telegram**: [Klik di sini](https://t.me/sentineldiscus).


---

## 💡 Disclaimer
Penggunaan bot ini sepenuhnya tanggung jawab pengguna. Kami tidak bertanggung jawab atas penyalahgunaan skrip ini.
