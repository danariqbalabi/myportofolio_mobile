# MyPortfolio Mobile

Aplikasi portofolio pribadi berbasis Flutter untuk mata kuliah Pemrograman Berbasis Platform, Gasal 2026/2027. Proyek ini melanjutkan Tutorial 08 ke Tugas 7: profil contoh diganti dengan identitas pribadi dan tiap menu diberi warna sendiri.

| Identitas | Keterangan |
| --- | --- |
| Nama | Danar Iqbal Abi Zaidan Suharso |
| NPM | 2506534371 |
| Kelas | PBP A |
| Repository | [myportofolio_mobile](https://github.com/danariqbalabi/myportofolio_mobile) |
| Branch Tugas 7 | `tugas/7-portofolio-pribadi` |

## Fitur

- Tiga `InfoCard` di bagian atas untuk NPM, Name, dan Class.
- Sambutan dengan nama pemilik portofolio.
- Tiga kartu aksi dengan ikon, efek sentuh, dan warna yang berbeda.
- Pesan SnackBar yang sesuai dengan tombol yang ditekan.
- Halaman bisa digulir supaya tetap bisa digunakan di layar kecil dan landscape.
- Teks putih pada kartu aksi memakai latar yang kontras; rasio kontrasnya ikut diperiksa lewat tes.

| Menu | Ikon | Warna | Pesan saat ditekan |
| --- | --- | --- | --- |
| Lihat Proyek | Folder | Biru `#1D4ED8` | Kamu telah menekan tombol Lihat Proyek! |
| Tambah Proyek | Add circle | Hijau `#047857` | Kamu telah menekan tombol Tambah Proyek! |
| Logout | Logout | Merah `#B91C1C` | Kamu telah menekan tombol Logout! |

Sesuai cakupan Tugas 7, ketiga tombol masih menampilkan SnackBar. Daftar proyek, form tambah proyek, logout sungguhan, dan koneksi API Django belum diimplementasikan.

## Setup dan menjalankan

Prasyarat: Git, Flutter SDK, serta Dart yang memenuhi `pubspec.yaml` (`^3.13.5`). Untuk target web siapkan Chrome; untuk Android siapkan Android SDK beserta emulator atau perangkat dengan USB debugging.

```sh
git clone https://github.com/danariqbalabi/myportofolio_mobile.git
cd myportofolio_mobile
git switch tugas/7-portofolio-pribadi
flutter pub get
flutter doctor
flutter run -d chrome
```

Kalau proyek sudah ada secara lokal, cukup pindah ke branch tugas, jalankan `flutter pub get`, lalu `flutter run -d chrome`. Untuk Android, cari ID perangkat lewat `flutter devices`, kemudian jalankan:

```sh
flutter run -d <device-id>
```

## Struktur proyek

```text
lib/
  main.dart          # entry point, MaterialApp, dan tema
  menu.dart          # MyHomePage, InfoCard, ItemHomepage, dan ItemCard
test/
  widget_test.dart   # profil, warna/kontras, SnackBar, dan layout
```

`ItemHomepage` menyimpan nama, ikon, dan warna sebagai data. `ItemCard` tinggal membaca `item.color`, sehingga tidak perlu rangkaian `if-else` untuk menentukan warna berdasarkan nama tombol.

## Progres mingguan

| Tahap | Perubahan | Branch |
| --- | --- | --- |
| Tutorial 08 | Setup Flutter, pemisahan halaman, tema, kartu profil contoh, dan SnackBar | `tutorial/08-basic-flutter` |
| Tugas 7 | Identitas pribadi, warna unik tiap menu, pengujian, jawaban reflektif, dan AI disclosure | `tugas/7-portofolio-pribadi` |

Tutorial 08 sudah digabungkan ke `main`. Pengerjaan Tugas 7 disimpan di branch tersendiri dengan commit dan push bertahap agar progresnya bisa ditelusuri.

## Pemeriksaan

```sh
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
flutter build web
```

Tes widget memeriksa identitas pribadi dan ketiadaan data contoh Burhan, tiga warna unik yang benar-benar dipakai kartu, kontras teks minimal 4.5:1, pesan SnackBar setiap menu, serta interaksi pada layar 320 x 568 dan 568 x 320. Build web menghasilkan berkas di `build/web/`; folder hasil build tidak masuk Git.

## Pertanyaan reflektif

### Tugas 7

1. **Apa itu widget tree dan bagaimana hubungan parent-child bekerja?**

   Widget tree adalah susunan widget secara hierarkis yang mendeskripsikan antarmuka Flutter. Parent menyusun dan memberikan konfigurasi kepada child lewat parameter seperti `child`, `children`, atau slot khusus seperti `body`. Misalnya, `Scaffold` punya `AppBar` dan isi halaman, sedangkan `Row` menyusun tiga `InfoCard` secara horizontal. Child juga bisa menjadi parent untuk widget lain; `InfoCard` membangun `Card`, lalu `Padding`, `Column`, dan beberapa `Text`.

   Hubungan ini berpengaruh pada layout: batas ukuran turun dari parent, child menghitung ukurannya, lalu parent menentukan posisinya. Jadi, ukuran widget tidak ditentukan sendiri tanpa mempertimbangkan ruang dari parent. Gambaran sederhananya di proyek ini:

   ```text
   MyApp
   └── MaterialApp
       └── MyHomePage
           └── Scaffold
               ├── AppBar → Text
               └── SafeArea → SingleChildScrollView → Column
                   ├── Row → Expanded → InfoCard
                   ├── Text (sambutan)
                   └── GridView → ItemCard
   ```

   Rujukan: [penjelasan widget dan komposisi UI Flutter](https://docs.flutter.dev/ui).

2. **Widget apa saja yang digunakan dan apa fungsinya?**

   Berikut seluruh jenis widget yang ditulis secara eksplisit di kode aplikasi, termasuk widget buatan sendiri. Widget internal yang dibuat otomatis oleh framework tidak dihitung satu per satu.

   | Widget | Fungsi di proyek |
   | --- | --- |
   | `MyApp` | Widget buatan sendiri yang membangun konfigurasi aplikasi. |
   | `MaterialApp` | Mengatur judul, tema Material, dan halaman awal. |
   | `MyHomePage` | Halaman stateless untuk profil dan menu portofolio. |
   | `Scaffold` | Kerangka halaman dengan app bar dan body. |
   | `AppBar` | Menampilkan judul MyPortfolio di bagian atas. |
   | `Text` | Menampilkan judul, label identitas, nama, sambutan, dan pesan. |
   | `SafeArea` | Menjaga konten dari area sistem seperti notch atau bilah navigasi. |
   | `SingleChildScrollView` | Membuat isi halaman dapat digulir saat lebih tinggi dari layar. |
   | `Column` | Menyusun bagian halaman dan isi kartu secara vertikal. |
   | `Row` | Menyusun tiga kartu identitas secara horizontal. |
   | `Expanded` | Membagi ruang horizontal untuk kartu identitas. |
   | `InfoCard` | Widget reusable untuk pasangan label dan isi identitas. |
   | `Card` | Permukaan kartu profil dengan sudut membulat dan elevasi. |
   | `Padding` | Memberi jarak antara isi dan tepi widget. |
   | `SizedBox` | Memberikan jarak vertikal antarbagian. |
   | `GridView.count` | Menyusun menu dalam grid tiga kolom; ini constructor dari `GridView`. |
   | `ItemCard` | Widget reusable untuk sebuah tombol menu. |
   | `Material` | Permukaan berwarna yang juga mendukung efek tinta `InkWell`. |
   | `InkWell` | Menangani tap dan menampilkan efek sentuh pada kartu. |
   | `Center` | Memusatkan isi tombol menu. |
   | `Icon` | Menampilkan simbol folder, tambah, dan logout. |
   | `SnackBar` | Menampilkan umpan balik sementara setelah tombol ditekan. |

   `StatelessWidget` adalah kelas dasar untuk widget buatan sendiri di atas. `ItemHomepage` merupakan model data, bukan widget. `ThemeData`, `ColorScheme`, `TextStyle`, dan `EdgeInsets` juga objek konfigurasi, bukan widget. `ScaffoldMessenger.of(context)` dipakai untuk menemukan pengelola SnackBar yang disediakan di atas halaman oleh `MaterialApp`.

3. **Apa fungsi MaterialApp dan mengapa biasa dipakai di root?**

   `MaterialApp` menyediakan konfigurasi tingkat aplikasi untuk UI Material, seperti tema, judul, navigasi, dan dukungan lokalisasi. Di proyek ini, `MyApp` mengembalikan `MaterialApp` dengan `home: const MyHomePage()` dan tema dari `ColorScheme.fromSeed`. Konfigurasi tersebut tersedia bagi widget turunannya, jadi setiap halaman tidak perlu memasang infrastruktur aplikasi sendiri.

   Widget ini umum ditempatkan dekat root karena cakupannya berlaku untuk seluruh aplikasi. Namun, `MaterialApp` bukan syarat wajib semua aplikasi Flutter: aplikasi bergaya Cupertino bisa memakai `CupertinoApp`, sedangkan kebutuhan lebih dasar bisa memakai `WidgetsApp`. Rujukan: [dokumentasi MaterialApp](https://api.flutter.dev/flutter/material/MaterialApp-class.html).

4. **Apa perbedaan StatelessWidget dan StatefulWidget, serta kapan memakainya?**

   `StatelessWidget` cocok ketika tampilan bergantung pada konfigurasi dan context tanpa perlu mengelola state lokal yang berubah. Ini bukan berarti `build` hanya dipanggil sekali. Widget stateless tetap bisa dibangun ulang ketika konfigurasi dari parent atau dependensi seperti tema berubah. Profil dan menu di `MyHomePage` memakai pendekatan ini karena datanya tetap.

   `StatefulWidget` dipakai ketika ada state yang perlu bertahan di antara pemanggilan `build`, misalnya nilai counter, pilihan filter, atau status form. Objek widget-nya tetap immutable; data yang berubah berada pada objek `State`. Saat perubahan state memengaruhi tampilan, `setState` bisa digunakan untuk menjadwalkan rebuild.

   Tombol yang menampilkan SnackBar tidak otomatis membuat halaman harus stateful, karena pengelolaan SnackBar dilakukan oleh `ScaffoldMessenger`. Rujukan: [StatelessWidget](https://api.flutter.dev/flutter/widgets/StatelessWidget-class.html) dan [StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html).

5. **Apa itu BuildContext dan bagaimana digunakan dalam build?**

   `BuildContext` adalah referensi ke lokasi widget di tree. Melalui lokasi ini, Flutter dapat mencari ancestor atau konfigurasi yang relevan. Contohnya, `Theme.of(context)` di `MyHomePage.build` mengambil tema untuk warna app bar, sedangkan `ScaffoldMessenger.of(context)` di `ItemCard` mencari pengelola SnackBar.

   Context harus berada di bawah ancestor yang dicari. Context milik widget yang sedang membangun sebuah parent baru belum menjadi context child dari parent tersebut. Karena itu, lokasi pemanggilan `.of(context)` penting, bukan sekadar adanya variabel bernama `context`. Jika context dipakai setelah operasi asynchronous, perlu memastikan widget masih mounted sebelum menggunakannya. Rujukan: [BuildContext](https://api.flutter.dev/flutter/widgets/BuildContext-class.html).

6. **Apa itu hot reload, bedanya dengan hot restart, dan kapan perlu restart?**

   Hot reload memasukkan perubahan kode Dart ke aplikasi yang sedang berjalan dan membangun ulang widget tree sambil mempertahankan state. Ini cocok untuk mengubah teks, warna, padding, atau susunan widget. `main()` dan `initState()` tidak dijalankan ulang, jadi perubahan yang bergantung pada inisialisasi awal belum tentu terlihat.

   Hot restart memulai ulang aplikasi Flutter dan membuang state sebelumnya. Ini diperlukan ketika ingin menjalankan ulang inisialisasi, mengatur ulang state, atau menerapkan perubahan struktur kode yang tidak didukung hot reload, misalnya perubahan parameter tipe generic tertentu.

   Full restart menghentikan lalu menjalankan aplikasi lagi beserta proses build yang diperlukan. Ini diperlukan untuk perubahan kode native Kotlin/Java/Swift/Objective-C atau konfigurasi native/plugin yang membutuhkan kompilasi ulang. Kalau ada compilation error, kode harus diperbaiki dulu; menekan reload atau restart saja tidak menyelesaikan error tersebut. Rujukan: [hot reload, hot restart, dan full restart](https://docs.flutter.dev/tools/hot-reload).

## AI disclosure

Pengerjaan proyek ini dibantu **ChatGPT/Codex**. Bantuan AI dipakai untuk membaca ketentuan tugas, mengubah kode Flutter, menyusun tes widget, membuat draf jawaban reflektif dan dokumentasi, serta menjalankan alur commit dan push bertahap.

Strategi prompting yang dipakai adalah memberikan PDF tugas dan konteks proyek yang sudah ada, lalu meminta implementasi di branch terpisah, pesan commit berbahasa Indonesia lowercase, README yang rapi, dan pencantuman log chat. Ketentuan tugas dicocokkan dengan implementasi, lalu hasilnya diperiksa menggunakan formatter, `flutter analyze`, tes widget, dan build web.

Penyesuaian pada hasil bantuan AI di tugas ini mencakup penggantian identitas contoh berdasarkan README portofolio web lokal, pemindahan warna tombol ke atribut model `ItemHomepage`, serta pemilihan warna yang diuji kontrasnya terhadap teks putih. Pengujian profil dan layout juga disesuaikan agar memakai nama lengkap, bukan data contoh tutorial. Perubahan tersebut merupakan bagian dari pengerjaan yang dibantu AI, bukan klaim bahwa semuanya dilakukan manual tanpa AI.

AI bisa salah memahami kebutuhan, mengisi data contoh, atau memberi penjelasan yang terdengar meyakinkan tetapi kurang tepat. Karena itu, jawaban konsep dilengkapi rujukan dokumentasi Flutter, data identitas dicocokkan dengan sumber proyek yang sudah ada, dan perilaku aplikasi diuji. Tes widget dan build web juga belum membuktikan tampilan serta perilaku pada setiap perangkat Android/iOS; pemeriksaan perangkat nyata tetap berguna.

Log chat yang disertakan: [percakapan ChatGPT](https://chatgpt.com/s/cx_6afa76f5fab08191bb0b49500c93a199).
