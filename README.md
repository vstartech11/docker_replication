# Replikasi PostgreSQL dengan Docker tanpa Docker Compose

Proyek ini adalah contoh konfigurasi replikasi PostgreSQL menggunakan Docker tanpa Docker Compose. Replikasi dilakukan antara dua kontainer PostgreSQL, yaitu `bintang-primary` sebagai *primary* dan `bintang-secondary` sebagai *secondary*. Konfigurasi ini menggunakan `username` dan `password` untuk autentikasi, serta `bintangdb` sebagai basis data yang direplikasi.

## Prasyarat

Pastikan Anda sudah menginstal:
- Docker
- Akses terminal atau shell untuk menjalankan perintah Docker

## Struktur Proyek

Proyek ini memiliki struktur file sebagai berikut:

```plaintext
├── Dockerfile-primary           # Dockerfile untuk kontainer primary
├── Dockerfile-secondary         # Dockerfile untuk kontainer secondary
├── setup-primary.sh             # Skrip konfigurasi untuk primary
└── setup-secondary.sh           # Skrip konfigurasi untuk secondary
