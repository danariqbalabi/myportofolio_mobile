# MyPortfolio Mobile

Implementasi Tutorial 08: Basic Flutter untuk PBP Gasal 2026/2027.

## Fitur

- Bootstrap aplikasi di `lib/main.dart` dan halaman stateless di `lib/menu.dart`.
- Tema Material 3 dengan warna dasar indigo dan warna sekunder amber.
- Widget reusable `InfoCard` untuk NPM, Name, dan Class.
- Model `ItemHomepage` dan widget reusable `ItemCard` dalam grid tiga kolom.
- Tombol Lihat Proyek, Tambah Proyek, dan Logout menampilkan SnackBar sesuai nama tombol.
- Halaman dapat digulir dan kartu menyesuaikan lebar layar.

Data profil masih mengikuti contoh Tutorial 08: Burhan, NPM 2406000001, kelas PBP A.
Tombol aksi pada tahap ini hanya menampilkan SnackBar. Navigasi, autentikasi,
integrasi API, dan personalisasi untuk Individual Assignment 7 belum termasuk tahap tutorial ini.

## Menjalankan

Prasyarat: Flutter SDK dengan Dart yang memenuhi `pubspec.yaml` (Dart ^3.13.5).

```sh
flutter pub get
flutter run -d chrome
```

Untuk Android, jalankan emulator atau hubungkan perangkat dengan USB debugging,
lalu pilih ID perangkat dari `flutter devices`:

```sh
flutter run -d <device-id>
```

## Pemeriksaan

```sh
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
flutter build web
```

Tes mencakup isi halaman, pesan SnackBar ketiga tombol, dan interaksi pada ukuran
layar 320 x 568 serta 568 x 320.

## Alur Git

Pengerjaan dilakukan bertahap di branch `tutorial/08-basic-flutter`:
inisialisasi proyek, perubahan halaman dan tema, implementasi kartu dan tes,
lalu dokumentasi. Branch tersebut digabungkan ke `main` dengan merge commit
agar riwayat pengerjaan tetap terlihat.
