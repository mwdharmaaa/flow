# Flow - Personal Finance & Expense Tracker (Flutter Native)

Flow adalah aplikasi manajemen keuangan pribadi modern berarsitektur **100% Offline-First / Local Storage**, dibangun menggunakan **Flutter & Dart**.

---

## Karakteristik Utama

1. **Tanpa Fitur Login (Zero Login)**
   - Tidak ada formulir pendaftaran, email, password, atau autentikasi awan.
   - Aplikasi langsung terbuka ke dasbor keuangan utama secara instan saat diluncurkan.

2. **Bebas Paywall & Semua Fitur Terbuka**
   - Multi-Dompet tanpa batas (Cash, Bank BCA, Mandiri, E-Wallet GoPay/OVO/DANA, Tabungan).
   - Transfer saldo antar akun secara otomatis.
   - Anggaran bulanan per kategori tanpa batasan jumlah.
   - Analitik arus kas dan visualisasi distribusi pengeluaran.
   - Pencatat hutang dan piutang dengan pelunasan instan.
   - Tagihan rutin dan langganan (subscriptions).

3. **Deteksi Struk Belanja (Receipt OCR Scanner)**
   - Pindai nota belanja dan ekstrak merchant, line items, PPN, serta total expense secara otomatis.
   - Pilihan preset struk ritel Indonesia (Indomaret, Alfamart, Kopi Kenangan, Restoran Padang) dan parser teks nota.

4. **Interaksi Suara Hands-Free (Voice Input & Voice Output)**
   - Voice Input: Pencatatan pengeluaran via ucapan suara dengan visualisasi gelombang frekuensi.
   - Voice Output: Audio feedback (TTS) otomatis yang mengonfirmasi transaksi dan total struk secara verbal.

5. **Performa Native Skia / Impeller**
   - Render antarmuka native 60/120 FPS tanpa WebView.
   - Bebas masalah white screen atau asset loading lag.

---

## Menjalankan Proyek

```bash
flutter pub get
flutter run
```

Kompilasi APK mandiri:
```bash
flutter build apk --release --no-tree-shake-icons
```
Output APK berada di `build/app/outputs/flutter-apk/app-release.apk`.
