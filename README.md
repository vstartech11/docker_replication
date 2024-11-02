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
```
## Langkah-Langkah Pembuatan Kontainer

Ikuti langkah-langkah berikut untuk membuat kontainer *primary* dan *secondary*, serta menjalankan replikasi:

### 1. Membuat Kontainer Primary

Buat dan jalankan kontainer primary:
```
docker build -f Dockerfile-primary -t bintang-primary .
docker run --name bintang-primary -e POSTGRES_USER=bintang -e POSTGRES_PASSWORD=bintang123 -d bintang-primary
```
### 2. Membuat Kontainer Secondary

Buat dan jalankan kontainer secondary:
```
docker build -f Dockerfile-secondary -t bintang-secondary .
docker run --name bintang-secondary --link bintang-primary -e POSTGRES_USER=bintang -e POSTGRES_PASSWORD=bintang123 -d bintang-secondary
```
### 3. Verifikasi Replikasi

Untuk memastikan replikasi berjalan, lakukan pengujian berikut:

- Masuk ke dalam kontainer `bintang-primary` dan buat tabel, lalu masukkan data.
- Cek apakah data tersebut tersinkronisasi di `bintang-secondary`.

#### Langkah Pengujian

##### Masukkan Data di Primary

Masuk ke dalam kontainer `bintang-primary`:

docker exec -it bintang-primary psql -U bintang -d bintangdb

Setelah masuk ke *psql* di *primary*, buat tabel dan masukkan data:
```
CREATE TABLE test_data (
    id SERIAL PRIMARY KEY,
    data VARCHAR(50)
);

INSERT INTO test_data (data) VALUES ('Data pertama');
INSERT INTO test_data (data) VALUES ('Data kedua');

SELECT * FROM test_data;
```
##### Periksa Data di Secondary

Masuk ke dalam kontainer `bintang-secondary`:
```
docker exec -it bintang-secondary psql -U bintang -d bintangdb
```
Setelah masuk ke *psql* di *secondary*, jalankan perintah berikut untuk melihat data yang direplikasi:
```
SELECT * FROM test_data;
```
Jika replikasi berhasil, Anda akan melihat data `Data pertama` dan `Data kedua` yang ditambahkan di *primary* juga ada di *secondary*.

### 4. Periksa Status Replikasi

Anda dapat memeriksa status replikasi di *primary* untuk memastikan bahwa *secondary* tersinkronisasi dengan baik. Jalankan perintah berikut di kontainer *primary*:
```
docker exec -it bintang-primary psql -U bintang -d bintangdb -c "SELECT * FROM pg_stat_replication;"
```
## Keterangan File

- **Dockerfile-primary**: Konfigurasi Dockerfile untuk membuat kontainer *primary*.
- **Dockerfile-secondary**: Konfigurasi Dockerfile untuk membuat kontainer *secondary*.
- **setup-primary.sh**: Skrip inisialisasi untuk konfigurasi *primary*, termasuk pengaturan replikasi.
- **setup-secondary.sh**: Skrip inisialisasi untuk konfigurasi *secondary*, termasuk sinkronisasi data dari *primary*.

## Catatan

- Pastikan untuk menyesuaikan pengaturan jaringan jika Anda menggunakan Docker di lingkungan dengan konfigurasi jaringan yang berbeda.
- Untuk menggunakan pengaturan replikasi ini dalam lingkungan yang lebih kompleks, pertimbangkan menggunakan Docker Compose atau orkestrasi yang lebih lanjut.
