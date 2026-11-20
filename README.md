# Aplikasi HR — Praktikum BAB 6

Contoh manajemen state Flutter sesuai modul: Provider untuk pengajuan cuti,
Riverpod 3 untuk penggajian, dan Cubit untuk autentikasi.

## Struktur

```text
lib/
  main.dart
  home_page.dart
  models/
    karyawan.dart
  latihan61_provider/
  latihan62_riverpod/
  latihan63_bloc/
test/
android/
web/
```

Setiap folder latihan menyimpan halaman dan state yang digunakan pada latihan
tersebut. Data karyawan bersama berada di `models/`.

## Menjalankan

Dari folder `aplikasi_hr_app`:

```powershell
flutter pub get
flutter devices
flutter run -d chrome
```

Untuk Android, jalankan emulator atau hubungkan perangkat, lalu gunakan
`flutter run -d <device-id>` atau pilih perangkat di VS Code. Tekan **F5**
untuk memulai debug dengan konfigurasi **Aplikasi HR (Flutter)**.

Akun simulasi login: `admin@company.com` / `admin123`.

## Pemeriksaan

```powershell
flutter analyze
flutter test
```
