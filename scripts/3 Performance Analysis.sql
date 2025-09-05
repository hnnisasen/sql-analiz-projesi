/*
Performance Analysis (Yıllık Ürün Performansı)

Amaç:
- Ürünlerin yıllık satışlarını hem kendi ürün ortalamasına hem de önceki yıla (YoY) göre karşılaştırmak.

Kullanım:
- CTE `yearly_product_sales` ile yıl+ürün bazında toplam satış (current_sales) üretilir.
- Pencere fonksiyonları:
  - AVG(current_sales) OVER (PARTITION BY product_name)  → ürünün yıllık ortalaması
  - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) → önceki yıl satış
- Çıktılar:
  - diff_avg / avg_change  → ürünün yıllık satışının kendi ortalamasına göre farkı/sınıflaması
  - diff_py  / py_change   → önceki yıla göre fark ve yön (Increase/Decrease/No Change)

Dikkat:
- İlk yıl için LAG() NULL döner; diff_py ve py_change hesapları buna göre NULL/“No Change” yorumlanabilir.
- `order_year` hesaplaması YEAR(order_date) ile yapılır; farklı dönem (ay/çeyrek) istenirse CTE’deki gruplama güncellenmelidir.
- `product_key`↔`product_name` eşleşmesi veri modeline uygun olmalı; isim değişkenliği varsa key ile çalışın.
*/


--	Performance Analysis

/* Analyze the yearly performance of products by comparing their sales 
to both the average sales performance of the product and the previous year's sales*/
WITH yearly_product_sales AS
(
	SELECT 
		YEAR(f.order_date) AS order_year,
		p.product_name,
		SUM(f.sales_amount) AS current_sales
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p ON f.product_key = p.product_key
	WHERE order_date IS NOT NULL 
	GROUP BY YEAR(f.order_date), p.product_name
)
SELECT 
	order_year,
	product_name,
	current_sales,
	AVG(current_sales) OVER (PARTITION BY product_name) AS avg_sales,
	current_sales - AVG(current_sales) OVER (PARTITION BY product_name) AS diff_avg,
	CASE WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Average'
		 WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Average'
		 ELSE 'Average'
	END avg_change,
	--Year-over-year Analysis
	LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS py_sales,
	current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS diff_py,
	CASE WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
		 WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
		 ELSE 'No Change'
	END py_change
FROM yearly_product_sales

ORDER BY product_name, order_year
