# Tickets Cakramedia — Rails App

Proyek ini adalah aplikasi Rails 8.1 untuk manajemen tiket dan pelanggan, berjalan bersama Nginx reverse proxy dan PostgreSQL. Aplikasi menggunakan Devise untuk autentikasi, Pagy untuk pagination, dan Solid* (Cache/Queue/Cable) untuk caching, job queue, dan ActionCable.

## Stack
- Ruby `3.3.7` dan Rails `8.1.0` (`Gemfile`:4)
- PostgreSQL 16 sebagai database
- Puma sebagai web server
- Devise untuk akun (`config/routes.rb`:2–9)
- Pagy untuk pagination (`Gemfile`:65)
- Solid Cache/Queue/Cable (`Gemfile`:27–30)
- Nginx sebagai reverse proxy (`docker/nginx/nginx.conf`)

## Jalankan dengan Docker Compose
1. Pastikan network eksternal tersedia:
   - `nginx-proxy` dan `cakramedia_net` (ditandai `external: true` di compose)
2. Dari root project: `docker-compose -f docker/domains/tickets.cakramedia.net.id/docker-compose.yml up -d --build --remove-orphans`
3. Layanan yang berjalan:
   - `tickets.cakramedia.net.id` (Nginx)
   - `tickets-web` (Rails)
   - `tickets_db` (PostgreSQL)

## Konfigurasi Penting
- Environment DB untuk `web` di compose:
  - `DATABASE_URL=postgresql://tickets:Tickets123!@db:5432/tickets_database`
  - `POSTGRES_USER=tickets`, `POSTGRES_PASSWORD=Tickets123!`, `POSTGRES_DB=tickets_database`
- Entry point melakukan:
  - Tunggu DB siap (`pg_isready`)
  - `bundle install`
  - `rails db:migrate` dengan proteksi rollback dan cleanup index duplikat
  - Cek dan bersihkan `tmp/pids/server.pid` sebelum start

## Routing Utama
- Root: `frontend/home#index` (`config/routes.rb`:112–113)
- Area `protected` berisi resource: customers, devices, issues, accounts, employees, roles, role_requests, networks, dsb. (`config/routes.rb`:22–107)
- Health check: `GET /up` (`config/routes.rb`:14)

## Pengembangan Lokal
- Jalankan server: `bin/rails server -b 0.0.0.0 -p 3000`
- Migrasi DB: `bin/rails db:migrate`
- Seeds: `bin/rails db:seed` (`db/seeds.rb`)
- Generator custom ada di `lib/generators`, namun diabaikan oleh autoload saat produksi (`config/application.rb`:29)

## Deployment
- Gunakan image `tickets_web` dari Dockerfile.ruby untuk produksi.
- Nginx mem-proxy ke `web:3000` (`docker/nginx/nginx.conf`:5–13).
- Pastikan reverse proxy global (`nginx-proxy`) mengenali `VIRTUAL_HOST=tickets.cakramedia.net.id`.

## Troubleshooting
- Konflik nama container: hapus container lama `docker rm -f tickets.cakramedia.net.id`.
- DB belum siap: backend akan menunggu; jika migrasi gagal, cek `entrypoint.sh` log dan ulangi.
- Error generator di production: pastikan `config.autoload_lib(ignore: %w[assets tasks generators templates])` sudah diterapkan.
