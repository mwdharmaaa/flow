# Flow - Personal Finance & Expense Tracker

Flow adalah aplikasi pencatat keuangan pribadi modern berarsitektur **100% Offline-First / Local Database**, dirancang dengan estetika Linear/Figma dark palette, zero-latency, dan mengedepankan privasi mutlak pengguna tanpa ketergantungan server luar.

---

## Fitur Utama (Semua Fitur Bebas Tanpa Paywall)

1. **Multi-Dompet & Rekening Tanpa Batas**
   - Mendukung Uang Tunai (Cash), Rekening Bank (BCA, Mandiri, BRI, dll), E-Wallet (GoPay, OVO, DANA), Tabungan/Investasi, dan Kartu Kredit.
   - Fitur transfer saldo antar dompet instan dengan penyesuaian saldo otomatis.

2. **Pencatatan Transaksi Lengkap**
   - Transaksi Pengeluaran, Pemasukan, dan Transfer Saldo.
   - Filter real-time berdasarkan kategori, tipe transaksi, dan pencarian cepat.

3. **Anggaran Bulanan & Indikator Batas**
   - Buat batas anggaran bulanan per kategori tanpa batas.
   - Progress bar indikator threshold (Aman < 70%, Perhatian 70-90%, Over Budget > 90%).

4. **Analitik & Visualisasi Arus Kas**
   - Grafik distribusi persentase pengeluaran per kategori.
   - Visualisasi vertikal perbandingan arus kas pemasukan vs pengeluaran.

5. **Catatan Hutang & Piutang (Debts & Loans)**
   - Catat siapa yang meminjam uang (Piutang) dan uang yang dipinjam (Hutang).
   - Pengingat tanggal jatuh tempo dan tombol pelunasan satu kali klik.

6. **Transaksi Rutin & Langganan (Subscriptions)**
   - Jadwal pengeluaran berulang (Netflix, Spotify, Wifi, Listrik, dsb).
   - Periode harian, mingguan, bulanan, dan tahunan.

7. **Cadangan & Ekspor Data Penuh**
   - Ekspor riwayat transaksi ke format `.csv`.
   - Backup dan restore seluruh basis data ke format `.json`.

---

## Panduan Menjalankan di Lokal

### 1. Menjalankan Server Pengembangan Lokal
Cukup jalankan satu baris perintah:
```bash
bash runapp.sh
# atau
npm run dev
```
Akses aplikasi melalui browser di `http://localhost:3000`.

### 2. Build dan Sinkronisasi Android
```bash
bash deploy.sh
```

### 3. Build APK Siap Pakai
Workflow CI/CD GitHub Actions (`.github/workflows/build-apk.yml`) otomatis melakukan kompilasi APK saat kode di-push ke GitHub.
File APK (`flow.apk`) dapat diunduh langsung dari tab **Actions / Releases** di repositori GitHub.
