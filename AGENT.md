# AGENT.md: Rules for AI Agents

Dokumen ini berisi panduan untuk semua AI Agent yang terlibat dalam pengerjaan proyek Notefly.

---

## Aturan Utama (DO & DON'T)

### DO
- Ikuti siklus pengembangan: **Plan -> Code -> Test -> Commit -> Next**.
- Kerjakan satu iterasi saja dalam satu waktu. Jangan melompati fase atau iterasi.
- Minta konfirmasi kepada user sebelum berpindah ke iterasi berikutnya.
- Hasilkan file atau kode lengkap yang siap digunakan, bukan potongan kode (snippet).
- Perbarui `CONTEXT.md` (bagian ceklis fase dan iterasi) setiap kali sebuah iterasi selesai dikerjakan.
- Gunakan format **Conventional Commits** untuk semua pesan commit yang direkomendasikan.
- Ingatkan user untuk melakukan commit sebelum beralih ke iterasi berikutnya.
- Jalankan pemeriksaan `flutter analyze` sebelum melakukan commit.
- Ikuti struktur folder proyek yang telah ditetapkan.
- Lakukan push ke branch `feature/*` atau `develop`, jangan pernah ke `main`.
- Buat Pull Request (PR) ke branch `develop` setelah seluruh iterasi dalam satu fase selesai.
- Berikan konteks singkat mengenai keputusan teknis yang diambil.
- Jika ada hal yang tidak jelas atau ambigu, tanyakan kepada user terlebih dahulu.

### DON'T
- Jangan menulis kode tanpa membuat rencana implementasi (Planning) terlebih dahulu.
- Jangan menulis kode untuk beberapa iterasi sekaligus.
- Jangan mengubah nama paket (package name), nama aplikasi (app name), atau tech stack tanpa konfirmasi eksplisit dari user.
- Jangan melewati tahap pengujian (testing) meskipun perubahan kodenya sederhana.
- Jangan merekomendasikan dependensi (dependency) baru tanpa alasan dan persetujuan yang jelas.
- Jangan berasumsi apakah repositori sudah ada atau belum, selalu periksa terlebih dahulu.
- Jangan menggunakan emoji dalam pesan commit, kode, maupun dokumentasi.
- Jangan menggunakan em-dash (—) dalam format teks apa pun. Gunakan tanda hubung standar (-).
- Jangan melakukan push langsung ke branch `main`.
- Jangan melakukan refactoring kode di luar cakupan (scope) iterasi aktif.
- Jangan menghapus atau menulis ulang (overwrite) file yang sudah ada tanpa konfirmasi eksplisit.
- Jangan menjalankan build atau run aplikasi tanpa instruksi atau kebutuhan pengujian yang jelas.
- Jangan mengubah izin Android (permissions) pada `AndroidManifest.xml` tanpa konfirmasi.
- Jangan menyertakan file hasil generate seperti `*.g.dart` atau direktori `hive_adapters` ke dalam commit. Pastikan file-file tersebut terdaftar di `.gitignore`.

---

## Konvensi Penamaan

### Dart & Flutter

| Konteks | Konvensi | Contoh |
|---|---|---|
| Kelas | `PascalCase` | `NoteRepository`, `FloatingBubble` |
| Variabel | `camelCase` | `noteList`, `isDone` |
| Konstanta | `camelCase` dengan `const` | `const maxNoteLength = 500` |
| Anggota Privat | `_camelCase` | `_notes`, `_loadNotes()` |
| File | `snake_case` | `note_repository.dart`, `floating_bubble.dart` |
| Folder | `snake_case` | `data/`, `widgets/`, `providers/` |
| Enum | `PascalCase` (tipe), `camelCase` (nilai) | `enum NoteFilter { all, active, done }` |
| Ekstensi | `PascalCase` pada tipe | `extension NoteX on Note` |

### Hive
- Nama Box: String dengan format `snake_case` (contoh: `'note_box'`).
- TypeId: Didefinisikan sebagai `static const` di dalam kelas model terkait.

### Provider
- Kelas Provider: Akhiri dengan kata `Provider` (contoh: `NoteProvider`).
- Kelas Notifier: Akhiri dengan kata `Notifier` (contoh: `NoteNotifier`).

---

## Panduan Gaya Kode (Code Style)

### Umum
- Batas panjang baris maksimal: 80 karakter.
- Selalu gunakan `const` jika memungkinkan.
- Lebih baik gunakan `final` daripada `var`.
- Hindari hardcode angka (magic numbers). Ekstrak menjadi konstanta bernama.
- Jangan biarkan ada kode yang dikomentari (commented-out code) di dalam commit.

### Komentar & Dokumentasi
- Bahasa penulisan komentar: Inggris.
- API Publik (kelas, metode, properti): Gunakan komentar dokumentasi `///`.
- Penjelasan logika inline: Gunakan komentar satu baris `//`.
- Hindari komentar yang berlebihan yang hanya menjelaskan hal-hal yang sudah jelas terlihat dari kode.

```dart
// CONTOH BURUK
// increment counter by 1
counter++;

// CONTOH BAIK
// offset by 1 to account for header row
counter++;
```

### Widget
- Satu widget per file.
- Utamakan `StatelessWidget` kecuali jika state lokal benar-benar dibutuhkan.
- Ekstrak komponen UI yang dapat digunakan kembali ke dalam folder `widgets/`.
- Gunakan konstruktor `const` kapan pun memungkinkan.

### Asinkron (Async)
- Selalu gunakan `await` untuk objek Future. Hindari pola fire-and-forget kecuali jika disengaja secara eksplisit.
- Tangani error dengan blok `try/catch`. Jangan biarkan exception diabaikan tanpa penanganan.
- Gunakan `Future<void>` untuk metode asinkron yang tidak mengembalikan nilai.

### Urutan Import
Urutkan import dengan jeda satu baris kosong di antara kelompok berikut:
1. Dart SDK (`dart:`)
2. Flutter SDK (`package:flutter/`)
3. Paket Pihak Ketiga (`package:hive/`, `package:provider/`, dll.)
4. File Lokal Proyek (`package:notefly/` atau path relatif)

---

## Struktur Folder

```
lib/
├── main.dart
├── app.dart                  # Pengaturan MaterialApp
├── core/
│   └── constants.dart        # Konstanta tingkat aplikasi
├── data/
│   ├── models/
│   │   └── note.dart         # Model Note + Hive adapter
│   └── repositories/
│       └── note_repository.dart
├── providers/
│   └── note_provider.dart
├── overlay/
│   └── floating_bubble.dart  # Titik masuk untuk overlay
└── ui/
    ├── screens/
    │   └── notes_panel.dart
    └── widgets/
        ├── note_item.dart
        └── filter_tabs.dart
```

---

## Aturan Umum Kolaborasi

- **Tanggung Jawab Tunggal**: Setiap iterasi fokus pada satu hal saja.
- **Proyek Harus Selalu Berjalan**: Pada setiap akhir iterasi, proyek harus dalam kondisi dapat dijalankan menggunakan perintah `flutter run`.
- **Transparansi**: Jika Anda ragu, segera tanyakan ke user. Jangan mengambil keputusan arsitektur besar tanpa persetujuan.
- **Pahami Konteks**: Selalu baca `CONTEXT.md` dan `AGENT.md` sebelum memulai pekerjaan apa pun.
