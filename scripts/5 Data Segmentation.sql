/*
Data Segmentation

Amaç:
- Ürünleri maliyet aralıklarına bölerek adetlerini saymak.
- Müşterileri harcama davranışı ve süre (lifespan) temelinde segmentlere (VIP/Regular/New) ayırmak.

Kullanım:
1) product_segments CTE:
   - cost → CASE ile bantlara ayrılır (Below 100, 100–500, 500–1000, Above 1000).
   - Sonuç: her maliyet aralığında kaç ürün var.

2) customer_spending CTE:
   - Müşteri başına toplam harcama, ilk/son sipariş tarihi ve
     DATEDIFF(MONTH, first_order, last_order) ile lifespan hesaplanır.
   - İç sorguda CASE ile segment atanır:
     - VIP    : lifespan ≥ 12 ve total_spending > 5000
     - Regular: lifespan ≥ 12 ve total_spending ≤ 5000
     - New    : lifespan < 12
   - Dış sorgu: segment başına müşteri sayısı.

Dikkat:
- Para birimini netleştirin (örn. EUR). Eşikler (100, 500, 1000; 5000) ihtiyaca göre parametrize edilebilir.
- Tarihler string ise TRY_CONVERT/CONVERT ile tarihe çevirin; NULL tarihleri hariç tutun.
- Lifespan “ay farkı” tam yıl değildir; davranışa uygunluğu kontrol edin.
- Çakışan segment koşullarında sınırlar dâhil mi? (≤ / <) netleştirildi.
- Kategori/isim/cost NULL ise COALESCE ile “Unknown” vb. atama yapılabilir.
*/



-- Data Segmentation

/* Segment products into cost ranges and 
count how many products fall into each segment */

WITH product_segments AS
(
	SELECT
		product_key,
		product_name,
		cost,
		CASE WHEN cost < 100 THEN 'Below  100'
			 WHEN cost BETWEEN 100 AND 500 THEN '100-500'
			 WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
			 ELSE 'Above 1000'
		END cost_range
	FROM gold.dim_products
)
SELECT 
	cost_range,
	COUNT(product_key) AS total_products
FROM product_segments
GROUP BY cost_range
ORDER BY total_products DESC

/* Group customers into three segments based on their spending behaviour:
	- VIP: Customers with at least 12 months of history and spending more than €5.000
	- Regular: Customers with at least 12 months of history but spending €5.000 or less.
	- New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group.
*/

WITH customer_spending AS
(
	SELECT 
		c.customer_key,
		SUM(f.sales_amount) AS total_spending,
		MIN(order_date) AS first_order,
		MAX(order_date) AS last_order,
		DATEDIFF( MONTH, MIN(order_date), MAX(order_date)) AS lifespan
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_customers c ON f.customer_key = c.customer_key
	GROUP BY c.customer_key
)
SELECT
customer_segment,
COUNT(customer_key) AS customer_count
FROM
(
	SELECT
	customer_key,
	total_spending,
	lifespan,
	CASE WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
		 WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
		 ELSE 'New'
	END AS customer_segment
	FROM customer_spending
) AS t
GROUP BY customer_segment


