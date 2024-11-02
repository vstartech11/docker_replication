#!/bin/bash

# Tunggu sampai primary siap
sleep 10

# Hapus direktori data di secondary (akan digantikan oleh data primary)
rm -rf $PGDATA/*

# Sinkronkan dengan primary
pg_basebackup -h bintang-primary -D $PGDATA -U bintang -Fp -Xs -P -R

# Konfigurasi tambahan pada secondary
echo "primary_conninfo = 'host=bintang-primary port=5432 user=bintang password=bintang123'" >> $PGDATA/postgresql.conf
