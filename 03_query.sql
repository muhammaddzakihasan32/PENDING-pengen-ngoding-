--Query 1
-- Pertanyaan bisnis : Daftar seluruh kontrak brand beserta nama brand/klien dan nama kreator yang ditugaskan, diurutkan dari tenggat (deadline) terdekat.
-- Halaman / Fitur   : Halaman Daftar Kontrak / Dashboard Agensi
-- Teknik            : JOIN 3 tabel (kontrak, brand, kreator) + ORDER BY


SELECT 
    k.kontrak_id,
    k.judul_kampanye,
    b.nama_brand,
    cr.nama_kreator,
    k.nilai_kontrak,
    k.deadline
FROM kontrak k
JOIN brand b ON k.brand_id = b.brand_id
JOIN kreator cr ON k.kreator_id = cr.kreator_id
ORDER BY k.deadline ASC;



-- Query 2
-- Pertanyaan bisnis : Konten produksi mana saja yang statusnya masih draft atau revisi beserta judul kampanye dan nama kreatornya?
-- Halaman / Fitur   : Halaman Manajemen Produksi Konten
-- Teknik            : JOIN 3 tabel + WHERE ... IN (...)

SELECT 
    pk.konten_id,
    pk.judul_konten,
    pk.platform,
    pk.status_konten,
    k.judul_kampanye,
    cr.nama_kreator
FROM produksi_konten pk
JOIN kontrak k ON pk.kontrak_id = k.kontrak_id
JOIN kreator cr ON k.kreator_id = cr.kreator_id
WHERE pk.status_konten IN ('draft', 'revisi');



-- Query 3
-- Pertanyaan bisnis : Siapa saja kreator yang terdaftar di agensi tetapi belum pernah mendapatkan kontrak kerja sama sama sekali?
-- Halaman / Fitur   : Fitur Rekomendasi / Distribusi Job Kreator
-- Teknik            : LEFT JOIN + IS NULL

SELECT 
    cr.kreator_id,
    cr.nama_kreator,
    cr.username_sosmed
FROM kreator cr
LEFT JOIN kontrak k ON cr.kreator_id = k.kreator_id
WHERE k.kontrak_id IS NULL;



-- Query 4
-- Pertanyaan bisnis : Total nilai kontrak dan jumlah proyek yang ditangani oleh masing-masing kreator, khusus untuk kreator yang memiliki lebih dari 1 kontrak.
-- Halaman / Fitur   : Halaman Laporan Performa & Bagi Hasil Kreator
-- Teknik            : JOIN + GROUP BY + HAVING COUNT(...) > 1 + SUM()

SELECT 
    cr.kreator_id,
    cr.nama_kreator,
    COUNT(k.kontrak_id) AS jumlah_kontrak,
    SUM(k.nilai_kontrak) AS total_nilai_kontrak,
    SUM(k.nilai_kontrak * (cr.persentase_bagi_hasil / 100)) AS total_bagi_hasil_kreator
FROM kreator cr
JOIN kontrak k ON cr.kreator_id = k.kreator_id
GROUP BY cr.kreator_id, cr.nama_kreator
HAVING COUNT(k.kontrak_id) > 1
ORDER BY total_nilai_kontrak DESC;


-- Query 5
-- Pertanyaan bisnis : Kontrak mana saja yang nilai kesepakatannya berada di atas rata-rata nilai seluruh kontrak di agensi?
-- Halaman / Fitur   : Halaman Analitik Pendapatan / Kontrak Prioritas
-- Teknik            : Subquery pada WHERE (> (SELECT AVG(...)))


SELECT 
    k.kontrak_id,
    k.judul_kampanye,
    b.nama_brand,
    k.nilai_kontrak
FROM kontrak k
JOIN brand b ON k.brand_id = b.brand_id
WHERE k.nilai_kontrak > (
    SELECT AVG(nilai_kontrak) 
    FROM kontrak
)
ORDER BY k.nilai_kontrak DESC;


-- Query 6
-- Pertanyaan bisnis : Brand mana saja yang memiliki kampanye aktif dengan pembayaran bagi hasil (revenue share) yang belum dilunasi (tanggal_bayar IS NULL)?
-- Halaman / Fitur   : Halaman Keuangan & Tagihan (Invoice)
-- Teknik            : JOIN + WHERE ... IS NULL

SELECT 
    b.brand_id,
    b.nama_brand,
    k.judul_kampanye,
    bh.nominal_kreator,
    bh.nominal_agensi,
    bh.tanggal_bayar
FROM brand b
JOIN kontrak k ON b.brand_id = k.brand_id
JOIN bagi_hasil bh ON k.kontrak_id = bh.kontrak_id
WHERE k.status_kampanye = 'aktif' 
  AND bh.tanggal_bayar IS NULL;