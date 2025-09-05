/*
Part-to-Whole Analysis

Amaç:
- Toplam satış içinde her kategorinin payını (yüzdesini) görmek.

Kullanım:
- CTE `category_sales` ile kategori bazında toplam satış hesaplanır.
- Dış sorguda:
  - SUM(total_sales) OVER () → genel toplam
  - CAST/ROUND → yüzde hesabında sayısal doğruluk
  - CONCAT → yüzdeyi metin olarak sunum (örn. "12.34 %")

Dikkat:
- Kategori adı NULL ise “(Unknown)” gibi bir değerle COALESCE kullanmayı düşünün.
- Yüzdeyi sayısal tutmak istiyorsanız CONCAT yerine saf oran (0–100) döndürün.
- Büyük veri setlerinde `SUM(...) OVER ()` tek bir tam tarama yapar; kabul edilebilir ama maliyeti bilin.
- `ORDER BY total_sales DESC` en çok katkı yapan kategorileri üstte gösterir.
*/


-- Part-to-Whole Analysis

-- Which categories contribute the most to overall sales?

WITH category_sales AS 
(
	SELECT
		category,
		SUM(sales_amount) AS total_sales
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p ON p.product_key = f.product_key
	GROUP BY category
)
SELECT 
	category,
	total_sales,
	SUM(total_sales) OVER () AS overall_sales,
	CONCAT(ROUND((CAST(total_sales AS FLOAT) / SUM(total_sales) OVER ()) * 100, 2), ' %') AS percentage_of_total
FROM category_sales

ORDER BY total_sales DESC
