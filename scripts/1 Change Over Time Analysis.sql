/*
Change Over Time Analysis

Amaç:
- Satışların zaman içindeki değişimini görmek (yıl/ay bazında).

Kullanım:
- YEAR/MONTH ile gruplayarak hızlı özet alınır.
- DATETRUNC (SQL 2022+) ile dönem başına göre gruplama yapılabilir.
- FORMAT ile etiketlenmiş tarih gösterimi sağlanır (örn. 2025-Jan).

Dikkat:
- FORMAT performans açısından pahalıdır, sadece gösterim için kullanın. (SQL’de “pahalı” = hızlı ama basit alternatiflere göre daha yavaş / daha çok kaynak tüketen demektir.)
- Tarih alanında NULL değerler filtrelenmelidir.
*/

-- Change Over Time Analysis
SELECT 
	YEAR(order_date) AS order_year,
	MONTH(order_date) AS order_month,
	SUM (sales_amount) AS total_sales,
	COUNT(DISTINCT customer_key) AS total_customers,
	SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date)



SELECT 
	DATETRUNC( YEAR, order_date) AS order_date,
	SUM (sales_amount) AS total_sales,
	COUNT(DISTINCT customer_key) AS total_customers,
	SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC( YEAR, order_date)
ORDER BY DATETRUNC( YEAR, order_date)



SELECT 
	FORMAT( order_date, 'yyyy-MMM') as order_date, 
	SUM (sales_amount) AS total_sales,
	COUNT(DISTINCT customer_key) AS total_customers,
	SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY FORMAT( order_date, 'yyyy-MMM')
ORDER BY FORMAT( order_date, 'yyyy-MMM')



