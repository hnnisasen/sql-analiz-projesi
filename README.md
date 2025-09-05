SQL Exploratory & Advanced Analysis
- Bu repo, Data with Baraa kanalındaki Exploratory Analysis ve Advanced Analysis SQL çalışmalarını birleştirerek oluşturduğum uygulamaları içerir.

- Amaç: Data with Baraa’dan esinlenen SQL tabanlı Exploratory ve Advanced Analysis çalışmalarını birleştirir. Veri keşfi ve özetlemeden; window functions, CTE, alt sorgular ve performans odaklı raporlamaya kadar uygulamalı örnekler sunar.

Yeni Öğrendiğim Terimler (Teknik Sözlük)
  - Exploratory Analysis (Keşifsel Analiz) → Veriyi anlamak için yapılan ilk inceleme, trend ve anormallik tespiti.
  - Advanced Analysis (İleri Analiz) → Daha karmaşık sorgularla iş için hazır içgörüler üretmek.
  - Fact Table (Olgu Tablosu) → Ölçülebilir olayların saklandığı tablo (ör. satışlar).
  - Dimension Table (Boyut Tablosu) → Tanımlayıcı bilgilerin tutulduğu tablo (ör. müşteri, ürün).
  - Star Schema (Yıldız Şeması) → Fact tablonun etrafında dimension tablolarla modellenmiş yapı.
  - CTE (Common Table Expression) → WITH ile tanımlanan, geçici ve isimlendirilmiş alt sorgu.
  - Window Function (Pencere Fonksiyonu) → Bir satırla ilişkili satırlar üzerinde hesaplama yapan fonksiyonlar.

Yeni Kullandığım Komutlar & Fonksiyonlar
  - INFORMATION_SCHEMA.TABLES → Tablo içeriklerini gösterir.
  - WITH ... AS (...) → CTE tanımlamak için kullanılır.
  - DATEDIFF(interval, start, end) → İki tarih arasındaki farkı hesaplar.
  - DATETRUNC(datepart, date) → Belirtilen tarih parçasına göre tarihi yuvarlar (örn. ayın başı, yılın başı).
  - FORMAT(value, format) → Tarih veya sayıları belirli bir formatta döndürür.
  - CONCAT(str1, str2, ...) → Stringleri birleştirir, NULL değerleri otomatik olarak boş kabul eder.
  - CAST(expression AS data_type) → Bir ifadeyi farklı bir veri tipine dönüştürür.

Repo Yapısı
  - datasets/ → Örnek veri setleri
  - scripts/ → Exploratory & Advanced Analysis SQL sorguları
  - docs/ → Project Roadmap
