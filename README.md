# MyPortfolio Mobile

Aplikasi portofolio pribadi berbasis Flutter untuk mata kuliah Pemrograman Berbasis Platform, Semester Gasal 2026/2027. Pengembangan dimulai dari halaman profil dan menu pada Tutorial 08, dilanjutkan navigasi dan formulir proyek pada Tutorial 09, serta formulir Gallery pada Tugas 8.

| Identitas | Keterangan |
| --- | --- |
| Nama pada aplikasi | Danar Iqbal Abi Zaidan S |
| NPM | 2506534371 |
| Kelas | PBP-A |
| Repositori | [myportofolio_mobile](https://github.com/danariqbalabi/myportofolio_mobile) |
| Branch Tugas 8 | `tugas/8-form-gallery` |

## Fitur aplikasi

- Tiga kartu identitas untuk NPM, nama, dan kelas, beserta sambutan personal.
- Empat kartu aksi dengan ikon, warna berbeda, dan SnackBar sesuai tombol yang ditekan.
- Drawer bersama untuk Home, Add Project, dan Tambah Foto Gallery.
- Form proyek dengan validasi dan dialog ringkasan.
- Form Gallery dengan validasi judul, tahun, gambar, kategori, dan lokasi, serta input caption dan featured.
- Halaman dan dialog yang dapat digulir, dengan menu dua kolom pada layar kurang dari 400 piksel.

| Kartu aksi | Warna | Perilaku |
| --- | --- | --- |
| Lihat Proyek | Biru `#1D4ED8` | Menampilkan SnackBar |
| Tambah Proyek | Hijau `#047857` | Menampilkan SnackBar dan membuka form proyek |
| Tambah Foto Gallery | Ungu `#7E22CE` | Menampilkan SnackBar dan membuka form Gallery |
| Logout | Merah `#B91C1C` | Menampilkan SnackBar |

Pada tahap ini, isian formulir ditampilkan dalam dialog dan dikelola selama halaman aktif. Integrasi penyimpanan ke API Django merupakan tahap pengembangan berikutnya.

## Setup dan menjalankan

Siapkan Git, Flutter SDK yang kompatibel dengan dependensi proyek, serta Dart sesuai batas SDK di `pubspec.yaml` (`^3.13.5`). Target web menggunakan Chrome. Target Android memerlukan Android SDK dan emulator atau perangkat dengan USB debugging.

```sh
git clone https://github.com/danariqbalabi/myportofolio_mobile.git
cd myportofolio_mobile
git switch tugas/8-form-gallery
flutter pub get
flutter doctor
flutter run -d chrome
```

Untuk salinan lokal yang sudah tersedia, pindah ke branch tersebut dan jalankan `flutter pub get` sebelum menjalankan aplikasi. Untuk Android, lihat perangkat yang tersedia, lalu gunakan ID perangkat tujuan.

```sh
flutter devices
flutter run -d <device-id>
```

Impor Material aplikasi menggunakan `package:material_ui/material_ui.dart`, dengan dependensi `material_ui` tercantum di `pubspec.yaml` dan versi hasil resolusi disimpan di `pubspec.lock`.

## Struktur proyek

```text
lib/
  main.dart                # Entry point, MaterialApp, dan tema
  screens/
    menu.dart              # MyHomePage, InfoCard, dan ItemHomepage
    project_form.dart      # Form proyek dari Tutorial 09
    gallery_form.dart      # Form Gallery dari Tugas 8
  widgets/
    left_drawer.dart       # Drawer bersama dan navigasi antarhalaman
    project_card.dart      # ItemCard, SnackBar, dan navigasi kartu
test/
  widget_test.dart         # Identitas, warna, SnackBar, dan layout menu
  project_form_test.dart   # Navigasi, validasi, dialog, dan reset form proyek
  gallery_form_test.dart   # Navigasi, validasi, dialog, dan layout form Gallery
```

`ItemHomepage` menyimpan nama, ikon, dan warna setiap kartu. `ItemCard` menggunakan `item.color` sebagai latar. Kedua halaman formulir memakai komponen `LeftDrawer` yang sama dengan beranda.

## Progres mingguan

| Tahap | Perubahan | Branch |
| --- | --- | --- |
| Tutorial 08 | Setup Flutter, pemisahan halaman, tema, kartu profil contoh, dan SnackBar | `tutorial/08-basic-flutter` |
| Tugas 7 | Identitas pribadi, warna menu, tes widget, dan jawaban reflektif | `tugas/7-portofolio-pribadi` |
| Tutorial 09 | Drawer, form proyek, validasi, dialog, navigasi, dan direktori screens/widgets | `tutorial/09-navigasi-form` |
| Tugas 8 | Form Gallery, validasi sesuai field, kartu dan drawer Gallery, serta tes interaksi | `tugas/8-form-gallery` |

### Tutorial 09

Form proyek menerima nama, deskripsi, kategori, teknologi, dan tautan. Nama dan deskripsi wajib diisi dan menolak isian yang hanya berisi spasi. Kategori yang tersedia adalah Web Development, Mobile Development, Machine Learning, Data Science, dan Other.

Kartu Tambah Proyek memakai `Navigator.push()` sehingga Back dapat kembali ke beranda. Drawer memakai `Navigator.pushReplacement()` setelah drawer ditutup. Save menampilkan ringkasan input. Tombol OK pada dialog proyek mengosongkan form dan mengembalikan kategori ke Web Development. Menutup dialog melalui Back mempertahankan isian.

### Implementasi Tugas 8

`GalleryFormPage` menggunakan `StatefulWidget`, `Form`, dan `GlobalKey<FormState>`. Field mengikuti bagian Gallery pada portofolio Django.

| Input | Widget | Aturan |
| --- | --- | --- |
| Judul | `TextFormField` | Wajib setelah trim, maksimal 255 karakter |
| Tahun | `TextFormField` dengan keyboard angka | Wajib, angka bulat 2000-2100 |
| Gambar | `TextFormField` dengan keyboard URL | Wajib, maksimal 500 karakter, URL HTTP/HTTPS dengan host atau path berkas di `/static/img/` |
| Caption | `TextFormField` multiline | Opsional |
| Kategori | `TextFormField` | Opsional, maksimal 100 karakter setelah trim |
| Lokasi | `TextFormField` | Opsional, maksimal 255 karakter setelah trim |
| Featured | `CheckboxListTile` | Pilihan Ya/Tidak, awalnya Tidak |

Validasi gambar menolak spasi, skema selain HTTP/HTTPS, kredensial pada URL, path gambar kosong, serta segmen `.` atau `..` pada path statis. Tahun tetap divalidasi meskipun keyboard sudah diatur sebagai angka.

Saat Simpan ditekan, `validate()` memeriksa seluruh validator. Jika valid, `save()` menjalankan `onSaved`, keyboard ditutup, dan `showDialog()` menampilkan seluruh isian melalui `AlertDialog`. Nilai opsional yang kosong ditampilkan sebagai tanda `-`. Tombol OK menutup dialog dan mempertahankan isian form Gallery.

Form memakai `Scaffold`, `AppBar`, `SafeArea`, `SingleChildScrollView`, `Padding`, dan `SizedBox`. Warna AppBar dan tombol Simpan diambil dari `Theme.of(context).colorScheme.primary`.

### Mencoba form Gallery

1. Tekan kartu Tambah Foto Gallery di beranda. Form terbuka menggunakan `Navigator.push()`, sehingga Back perangkat dapat kembali ke beranda.
2. Tekan Simpan dengan input kosong atau spasi. Pesan wajib diisi muncul pada judul, tahun, dan gambar.
3. Coba tahun `1999`, `2101`, atau `2026.5`, gambar `javascript:alert(1)`, dan judul lebih dari 255 karakter. Kolom terkait harus menampilkan kesalahan.
4. Isi judul, tahun yang valid, dan gambar seperti `https://example.com/foto.jpg` atau `/static/img/kampus.jpg`. Lengkapi field opsional dan ubah featured.
5. Tekan Simpan dan periksa ketujuh nilai dalam dialog. Tekan OK untuk kembali ke form dengan isian yang sama.
6. Ubah judul dan simpan kembali. Dialog harus menampilkan nilai terbaru.
7. Buka drawer, pilih Home, lalu buka Gallery melalui opsi drawer. Uji juga Add Project untuk memeriksa navigasi antarkedua formulir.
8. Pada layar selebar ponsel atau saat keyboard terbuka, gulir hingga tombol Simpan dapat ditekan. Saat menggunakan Chrome, opsi Home pada drawer menjadi jalur kembali ke beranda.

## Pemeriksaan

```sh
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

Hasil pemeriksaan Tugas 8 pada 23 November 2026 adalah `flutter analyze` dengan **No issues found** dan **19 tes widget lolos**. Tes mencakup navigasi kartu dan drawer, Back ke Home, penolakan input kosong/spasi, batas panjang dan tahun, format gambar, seluruh nilai dialog, isian yang bertahan setelah OK, submit ulang, serta layar 320 x 568 dan 568 x 320 dengan simulasi keyboard.

Pemeriksaan layout Tugas 8 tersebut menggunakan tes widget. Tampilan langsung di Chrome dan perangkat Android belum diverifikasi dalam pemeriksaan ini.

### Riwayat verifikasi

| Tahap | Hasil pada saat pengerjaan |
| --- | --- |
| Tugas 7, 16 November 2026 | Formatter bersih, analyze bersih, 5 tes lolos, build web optimasi ringan berhasil |
| Tutorial 09, 18 November 2026 | Formatter bersih pada 7 berkas, analyze bersih, 11 tes lolos, build web optimasi ringan berhasil |
| Tugas 8, 23 November 2026 | Analyze bersih dan 19 tes lolos |

Pada pengerjaan sebelumnya, build release standar mengalami kehabisan memori pada mesin lokal. Build web berhasil dengan optimasi yang lebih ringan.

```sh
flutter build web --no-wasm-dry-run -O1
```

Opsi `-O1` mengurangi tingkat optimasi JavaScript, sedangkan `--no-wasm-dry-run` melewati kompilasi uji WebAssembly. Hasil build tersimpan di `build/web/` yang diabaikan Git.

## Pertanyaan reflektif

### Tugas 7

1. **Apa itu widget tree dan bagaimana hubungan parent-child bekerja?**

   Widget tree adalah susunan widget secara hierarkis yang mendeskripsikan antarmuka Flutter. Parent menyusun dan memberikan konfigurasi kepada child lewat parameter seperti `child`, `children`, atau slot khusus seperti `body`. Misalnya, `Scaffold` punya `AppBar` dan isi halaman, sedangkan `Row` menyusun tiga `InfoCard` secara horizontal. Child juga bisa menjadi parent untuk widget lain; `InfoCard` membangun `Card`, lalu `Padding`, `Column`, dan beberapa `Text`.

   Hubungan ini berpengaruh pada layout: batas ukuran turun dari parent, child menghitung ukurannya, lalu parent menentukan posisinya. Jadi, ukuran widget tidak ditentukan sendiri tanpa mempertimbangkan ruang dari parent. Gambaran sederhananya di proyek ini:

   ```text
   MyApp
   +-- MaterialApp
       +-- MyHomePage
           +-- Scaffold
               |-- AppBar -> Text
               +-- SafeArea -> SingleChildScrollView -> Column
                   |-- Row -> Expanded -> InfoCard
                   |-- Text (sambutan)
                   +-- GridView -> ItemCard
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

### Tugas 8

1. **Perbedaan Navigator.push(), Navigator.pushReplacement(), dan Navigator.pop()**

   `Navigator.push()` menambahkan halaman di atas tumpukan route. Pada kartu Tambah Foto Gallery, metode ini membuka `GalleryFormPage` melalui `MaterialPageRoute`. Halaman Home tetap berada di bawahnya, sehingga Back perangkat dapat kembali ke Home.

   `Navigator.pushReplacement()` mengganti route aktif dengan route baru. Drawer memakai cara ini untuk membuka Home, Add Project, atau Gallery. Saat Home dipilih dari form, kode mengambil Navigator, memanggil `pop()` untuk menutup drawer, kemudian `pushReplacement()` untuk mengganti halaman form dengan `MyHomePage`.

   `Navigator.pop()` menutup route teratas. Pada tombol OK dialog Gallery, metode ini menutup dialog sehingga form terlihat kembali dengan input yang tetap ada.

2. **Peran Scaffold, AppBar, Drawer, dan konsistensi tema**

   `Scaffold` menyediakan kerangka halaman, `AppBar` menampilkan judul, dan `Drawer` menyediakan navigasi bersama. Home, form proyek, serta form Gallery memakai `LeftDrawer` yang sama sehingga pilihan menu dan alur navigasinya konsisten.

   Tema utama didefinisikan pada `MaterialApp` dengan `ColorScheme.fromSeed`. AppBar Home dan AppBar Gallery sama-sama mengambil `Theme.of(context).colorScheme.primary`. Tombol Simpan Gallery memakai warna primary yang sama, dengan teks putih.

3. **Alasan memilih layout formulir**

   Field disusun vertikal menggunakan `Column` agar label, input, dan pesan error mudah dibaca secara berurutan. `Padding` memberi jarak dari tepi layar, sedangkan `SizedBox` memisahkan field agar tidak terlalu rapat. Caption menggunakan beberapa baris agar teks yang lebih panjang tetap nyaman diisi.

   `SafeArea` menjaga konten dari area sistem. `SingleChildScrollView` memungkinkan seluruh field dan tombol Simpan dijangkau ketika layar sempit, landscape, atau keyboard mengurangi ruang yang tersedia. Konten dialog juga dapat digulir ketika ringkasan lebih tinggi daripada ruang layar.

4. **Peran GlobalKey<FormState>, validator, dan validate()**

   `GlobalKey<FormState>` menghubungkan kode tombol Simpan dengan state dari `Form`. Setiap `validator` mengembalikan pesan jika input tidak valid, atau `null` jika input diterima. Pemanggilan `_formKey.currentState!.validate()` memeriksa seluruh field dan menampilkan pesan pada kolom yang gagal.

   Sebagai contoh, judul `"   "` ditolak setelah `trim()` karena kosong, dan tahun `2101` ditolak karena melewati batas 2100. Keyboard angka hanya membantu cara memasukkan data. Pengguna masih dapat menempelkan nilai yang salah, sehingga aturan tetap harus diperiksa oleh validator.

   Setelah validasi berhasil, `save()` memanggil `onSaved` untuk mengambil nilai setiap field. Nilai tersebut kemudian ditampilkan dalam dialog, termasuk featured yang dikelola melalui `setState()`.

## AI disclosure

Proyek ini dikerjakan dengan bantuan **ChatGPT/Codex**. Rincian bantuan ditulis per tahap agar kontribusi AI dan keputusan pemilik proyek dapat ditelusuri melalui percakapan serta riwayat Git.

### Tugas 7 dan Tutorial 09

Bantuan AI pada tahap sebelumnya mencakup membaca ketentuan tugas, perubahan kode Flutter, refactoring direktori, migrasi impor Material, implementasi drawer dan form proyek, penyusunan tes widget, draf jawaban reflektif, dokumentasi, serta commit dan push.

Identitas, pemilihan warna, dan arah tampilan disesuaikan dengan keputusan pemilik proyek. Pengerjaan menggabungkan perubahan manual dan bantuan AI. Log percakapan tahap sebelumnya tersedia pada [log Tugas 7 dan Tutorial 09](https://chatgpt.com/s/cx_6afa76f5fab08191bb0b49500c93a199).

### Tugas 8

Bantuan ChatGPT/Codex dalam percakapan ini mencakup hal berikut.

- Membaca PDF Tugas 8 dan memetakan persyaratannya ke bagian Gallery.
- Membahas field, aturan validasi, navigasi kartu dan drawer, serta urutan pengerjaan.
- Meninjau implementasi yang sudah dikerjakan pemilik proyek dan menjalankan `flutter analyze` serta tes widget yang tersedia.
- Merapikan README, menyusun draf empat jawaban reflektif, dan menjelaskan perilaku implementasi berdasarkan kode.
- Menghapus aplikasi contoh `form_sample` sesuai permintaan, serta melakukan commit dan push dokumentasi.

Pemilik proyek melaporkan telah mengerjakan form Gallery, validasi, dialog, tema, layout, dan navigasi sebelum meminta pemeriksaan akhir. Pemeriksaan pada percakapan ini membaca implementasi tersebut serta menjalankan tes yang sudah tersedia.

Strategi prompting dimulai dari memberikan PDF dan konteks kode, menanyakan perubahan yang dibutuhkan, melaporkan bagian yang telah selesai, kemudian meminta pemeriksaan sebelum penulisan README. Dokumentasi disesuaikan dengan perilaku aktual kode dan hasil pemeriksaan lokal.

Penjelasan AI perlu dicocokkan dengan kode karena dapat keliru tentang versi SDK, detail navigasi, atau cakupan pengujian. Hasil tes widget membantu memeriksa perilaku dan layout dalam kondisi yang diuji. Pengujian tersebut belum mencakup semua perangkat fisik. Jawaban reflektif ini merupakan draf berbantuan AI yang perlu dipahami dan ditinjau pemilik proyek.

Log percakapan yang diberikan pemilik proyek tersedia pada [log Tugas 8](https://chatgpt.com/s/cx_6b03bca8f4448191b6374622770ba673).
