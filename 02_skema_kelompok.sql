CREATE DATABASE IF NOT EXISTS kreasihub DEFAULT CHARACTER SET utf8mb4;
USE kreasihub;

-- 1. Tabel Peran
CREATE TABLE peran (
    id_peran INT AUTO_INCREMENT PRIMARY KEY,
    nama_peran VARCHAR(50) NOT NULL,
    deskripsi VARCHAR(255)
) ENGINE=InnoDB;

-- 2. Tabel Pengguna
CREATE TABLE pengguna (
    id_pengguna INT AUTO_INCREMENT PRIMARY KEY,
    id_peran INT NOT NULL,
    nama_lengkap VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    status_aktif BOOLEAN NOT NULL DEFAULT TRUE,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_pengguna_peran FOREIGN KEY (id_peran) REFERENCES peran(id_peran) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 3. Tabel Brand
CREATE TABLE brand (
    id_brand INT AUTO_INCREMENT PRIMARY KEY,
    nama_brand VARCHAR(100) NOT NULL,
    industri VARCHAR(100),
    status_kerja_sama VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

-- 4. Tabel Kontak Brand
CREATE TABLE kontak_brand (
    id_kontak INT AUTO_INCREMENT PRIMARY KEY,
    id_brand INT NOT NULL,
    id_pengguna INT NOT NULL,
    nama_kontak VARCHAR(100) NOT NULL,
    jabatan VARCHAR(100),
    email VARCHAR(100),
    telepon VARCHAR(20),
    CONSTRAINT fk_kontak_brand FOREIGN KEY (id_brand) REFERENCES brand(id_brand) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_kontak_pengguna FOREIGN KEY (id_pengguna) REFERENCES pengguna(id_pengguna) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 5. Tabel Kreator (Relasi 1:1 dengan Pengguna)
CREATE TABLE kreator (
    id_kreator INT AUTO_INCREMENT PRIMARY KEY,
    id_pengguna INT NOT NULL UNIQUE, -- UNIQUE untuk relasi 1:1
    nama_tampil VARCHAR(100) NOT NULL,
    bio TEXT,
    niche VARCHAR(100),
    status_ketersediaan VARCHAR(50) NOT NULL,
    CONSTRAINT fk_kreator_pengguna FOREIGN KEY (id_pengguna) REFERENCES pengguna(id_pengguna) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 6. Tabel Skema Kompensasi
CREATE TABLE skema_kompensasi (
    id_skema INT AUTO_INCREMENT PRIMARY KEY,
    nama_skema VARCHAR(100) NOT NULL,
    tipe_skema VARCHAR(50) NOT NULL,
    persen_kreator DECIMAL(5,2) NOT NULL,
    persen_agen DECIMAL(5,2) NOT NULL,
    fee_agency DECIMAL(10,2) NOT NULL,
    CONSTRAINT chk_persen CHECK (persen_kreator >= 0 AND persen_kreator <= 100)
) ENGINE=InnoDB;

-- 7. Tabel Kontrak
CREATE TABLE kontrak (
    id_kontrak INT AUTO_INCREMENT PRIMARY KEY,
    id_brand INT NOT NULL,
    id_manager INT NOT NULL,
    id_penyedia INT NOT NULL,
    id_kreator INT NOT NULL,
    nomor_kontrak VARCHAR(50) NOT NULL UNIQUE,
    judul_kontrak VARCHAR(150) NOT NULL,
    tanggal_mulai DATE NOT NULL,
    tanggal_selesai DATE NOT NULL,
    nilai_kontrak DECIMAL(12,2) NOT NULL,
    status_kontrak VARCHAR(50) NOT NULL,
    berkas_kontrak VARCHAR(255),
    tanggal_unggah DATE,
    CONSTRAINT chk_tgl_kontrak CHECK (tanggal_selesai >= tanggal_mulai),
    CONSTRAINT fk_kontrak_brand FOREIGN KEY (id_brand) REFERENCES brand(id_brand) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_kontrak_manager FOREIGN KEY (id_manager) REFERENCES pengguna(id_pengguna) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_kontrak_penyedia FOREIGN KEY (id_penyedia) REFERENCES pengguna(id_pengguna) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_kontrak_kreator FOREIGN KEY (id_kreator) REFERENCES kreator(id_kreator) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 8. Tabel Revisi Kontrak
CREATE TABLE revisi_kontrak (
    id_revisi_kontrak INT AUTO_INCREMENT PRIMARY KEY,
    id_kontrak INT NOT NULL,
    id_pengusul INT NOT NULL,
    nomor_revisi INT NOT NULL,
    ringkasan_perubahan TEXT NOT NULL,
    berkas_revisi VARCHAR(255),
    tanggal_revisi DATE NOT NULL,
    CONSTRAINT fk_rev_kontrak FOREIGN KEY (id_kontrak) REFERENCES kontrak(id_kontrak) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_rev_pengusul FOREIGN KEY (id_pengusul) REFERENCES pengguna(id_pengguna) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 9. Tabel Penugasan Kreator
CREATE TABLE penugasan_kreator (
    id_penugasan INT AUTO_INCREMENT PRIMARY KEY,
    id_kontrak INT NOT NULL,
    id_kreator INT NOT NULL,
    id_skema INT NOT NULL,
    peran_kreator VARCHAR(50) NOT NULL,
    tanggal_penugasan DATE NOT NULL,
    CONSTRAINT fk_penugasan_kontrak FOREIGN KEY (id_kontrak) REFERENCES kontrak(id_kontrak) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_penugasan_kreator FOREIGN KEY (id_kreator) REFERENCES kreator(id_kreator) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_penugasan_skema FOREIGN KEY (id_skema) REFERENCES skema_kompensasi(id_skema) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 10. Tabel Konten
CREATE TABLE konten (
    id_konten INT AUTO_INCREMENT PRIMARY KEY,
    id_penugasan INT NOT NULL,
    id_penyedia INT NOT NULL,
    judul_konten VARCHAR(150) NOT NULL,
    platform VARCHAR(50) NOT NULL,
    tipe VARCHAR(50) NOT NULL,
    storyboard TEXT,
    jadwal_tayang DATETIME,
    deadline DATETIME,
    status_produksi VARCHAR(50) NOT NULL,
    tanggal_rilis DATETIME,
    CONSTRAINT fk_konten_penugasan FOREIGN KEY (id_penugasan) REFERENCES penugasan_kreator(id_penugasan) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_konten_penyedia FOREIGN KEY (id_penyedia) REFERENCES pengguna(id_pengguna) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 11. Tabel Tugas Konten
CREATE TABLE tugas_konten (
    id_tugas INT AUTO_INCREMENT PRIMARY KEY,
    id_konten INT NOT NULL,
    id_pengguna INT NOT NULL,
    nama_tugas VARCHAR(150) NOT NULL,
    deskripsi_tugas TEXT,
    status_tugas VARCHAR(50) NOT NULL,
    CONSTRAINT fk_tugas_konten FOREIGN KEY (id_konten) REFERENCES konten(id_konten) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_tugas_pengguna FOREIGN KEY (id_pengguna) REFERENCES pengguna(id_pengguna) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 12. Tabel Revisi Konten
CREATE TABLE revisi_konten (
    id_revisi_konten INT AUTO_INCREMENT PRIMARY KEY,
    id_konten INT NOT NULL,
    nomor_revisi INT NOT NULL,
    catatan_revisi TEXT NOT NULL,
    tanggal_diminta DATE NOT NULL,
    tanggal_selesai DATE,
    CONSTRAINT fk_rev_konten FOREIGN KEY (id_konten) REFERENCES konten(id_konten) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 13. Tabel Portofolio
CREATE TABLE portofolio (
    id_portofolio INT AUTO_INCREMENT PRIMARY KEY,
    id_kreator INT NOT NULL,
    judul VARCHAR(150) NOT NULL,
    tautan_berkas VARCHAR(255) NOT NULL,
    tahun INT NOT NULL,
    CONSTRAINT fk_portofolio_kreator FOREIGN KEY (id_kreator) REFERENCES kreator(id_kreator) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 14. Tabel Bagi Hasil
CREATE TABLE bagi_hasil (
    id_bagi_hasil INT AUTO_INCREMENT PRIMARY KEY,
    id_penugasan INT NOT NULL,
    periode_mulai DATE NOT NULL,
    periode_selesai DATE NOT NULL,
    penjualan_bruto DECIMAL(12,2) NOT NULL,
    persen_kreator DECIMAL(5,2) NOT NULL,
    bagian_kreator DECIMAL(12,2) NOT NULL,
    tanggal_dibayar DATE,
    CONSTRAINT fk_bagi_hasil_penugasan FOREIGN KEY (id_penugasan) REFERENCES penugasan_kreator(id_penugasan) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 15. Tabel Rate Card
CREATE TABLE rate_card (
    id_rate_card INT AUTO_INCREMENT PRIMARY KEY,
    id_kreator INT NOT NULL,
    jenis_konten VARCHAR(50) NOT NULL,
    platform VARCHAR(50) NOT NULL,
    harga DECIMAL(12,2) NOT NULL,
    CONSTRAINT chk_harga CHECK (harga >= 0),
    CONSTRAINT fk_rate_card_kreator FOREIGN KEY (id_kreator) REFERENCES kreator(id_kreator) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;