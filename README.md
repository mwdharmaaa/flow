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

3. **Performa Native Skia / Impeller**
   - Render antarmuka native 60/120 FPS tanpa WebView.
   - Bebas masalah *white screen* atau *asset loading*.

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
