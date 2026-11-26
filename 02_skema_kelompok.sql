CREATE DATABASE IF NOT EXISTS kreasihub_db;
USE kreasihub_db;

-- 1. Tabel Brand / Klien
CREATE TABLE brand (
    brand_id INT AUTO_INCREMENT PRIMARY KEY,
    nama_brand VARCHAR(100) NOT NULL,
    industri VARCHAR(50),
    email_pic VARCHAR(100)
);

-- 2. Tabel Kreator
CREATE TABLE kreator (
    kreator_id INT AUTO_INCREMENT PRIMARY KEY,
    nama_kreator VARCHAR(100) NOT NULL,
    username_sosmed VARCHAR(50),
    persentase_bagi_hasil DECIMAL(5,2) DEFAULT 70.00 -- 70% untuk kreator
);

-- 3. Tabel Kontrak Brand
CREATE TABLE kontrak (
    kontrak_id INT AUTO_INCREMENT PRIMARY KEY,
    brand_id INT NOT NULL,
    kreator_id INT NOT NULL,
    judul_kampanye VARCHAR(150) NOT NULL,
    nilai_kontrak DECIMAL(15,2) NOT NULL,
    status_kampanye ENUM('aktif', 'selesai', 'batal') DEFAULT 'aktif',
    deadline DATE NOT NULL,
    FOREIGN KEY (brand_id) REFERENCES brand(brand_id),
    FOREIGN KEY (kreator_id) REFERENCES kreator(kreator_id)
);

-- 4. Tabel Produksi Konten
CREATE TABLE produksi_konten (
    konten_id INT AUTO_INCREMENT PRIMARY KEY,
    kontrak_id INT NOT NULL,
    judul_konten VARCHAR(150) NOT NULL,
    platform ENUM('TikTok', 'Instagram Reels', 'YouTube Shorts'),
    status_konten ENUM('draft', 'revisi', 'approved', 'published') DEFAULT 'draft',
    FOREIGN KEY (kontrak_id) REFERENCES kontrak(kontrak_id)
);

-- 5. Tabel Bagi Hasil (Revenue Share)
CREATE TABLE bagi_hasil (
    bagi_hasil_id INT AUTO_INCREMENT PRIMARY KEY,
    kontrak_id INT NOT NULL,
    nominal_kreator DECIMAL(15,2) NOT NULL,
    nominal_agensi DECIMAL(15,2) NOT NULL,
    tanggal_bayar DATE NULL,
    FOREIGN KEY (kontrak_id) REFERENCES kontrak(kontrak_id)
);

-- ==========================================
-- DATA DUMMY (SEEDER)
-- ==========================================

INSERT INTO brand (nama_brand, industri, email_pic) VALUES
('Kopi Senja Nusantara', 'F&B', 'marketing@kopisenja.id'),
('GlowUp Skincare', 'Kecantikan', 'collab@glowup.co.id'),
('TechNova Gadget', 'Elektronik', 'pr@technova.id'),
('UrbanWear ID', 'Fashion', 'brand@urbanwear.id');

INSERT INTO kreator (nama_kreator, username_sosmed, persentase_bagi_hasil) VALUES
('Raka Pratama', '@rakatech', 75.00),
('Nadia Putri', '@nadiaglow', 70.00),
('Dimas Anggara', '@dimasvlogs', 70.00),
('Salsa Amelia', '@salsacooks', 65.00); -- Sengaja belum punya kontrak untuk Query 3

INSERT INTO kontrak (brand_id, kreator_id, judul_kampanye, nilai_kontrak, status_kampanye, deadline) VALUES
(1, 2, 'Promo Kopi Susu Gula Aren', 8000000.00, 'aktif', '2026-11-30'),
(2, 2, 'Review Serum Ceramide 7 Hari', 15000000.00, 'aktif', '2026-12-05'),
(3, 1, 'Unboxing Smartwatch X1', 20000000.00, 'aktif', '2026-12-01'),
(4, 1, 'OOTD Jaket Streetwear', 12000000.00, 'selesai', '2026-11-15'),
(1, 3, 'Vlog Nongkrong di Kopi Senja', 6000000.00, 'aktif', '2026-12-10');

INSERT INTO produksi_konten (kontrak_id, judul_konten, platform, status_konten) VALUES
(1, 'Teaser Kopi Senja 15 Detik', 'TikTok', 'published'),
(1, 'ASMR Seduh Kopi', 'Instagram Reels', 'draft'),
(2, 'Before After Pemakaian Serum', 'TikTok', 'revisi'),
(3, 'Tes Ketahanan Air Smartwatch', 'YouTube Shorts', 'draft'),
(4, 'Mix and Match Hoodie', 'Instagram Reels', 'approved');

INSERT INTO bagi_hasil (kontrak_id, nominal_kreator, nominal_agensi, tanggal_bayar) VALUES
(1, 5600000.00, 2400000.00, NULL),        -- Belum dibayar
(2, 10500000.00, 4500000.00, NULL),       -- Belum dibayar
(3, 15000000.00, 5000000.00, '2026-11-20'), -- Sudah dibayar
(4, 9000000.00, 3000000.00, '2026-11-18'),  -- Sudah dibayar
(5, 4200000.00, 1800000.00, NULL);        -- Belum dibayar
