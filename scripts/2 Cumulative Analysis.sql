/*
Cumulative Analysis

Amaç:
- Dönemsel toplam satış (aggregate) hesaplamak,
- Zaman içinde kümülatif satış (running total) görmek,
- Ortalama fiyat için hareketli ortalama (moving average) üretmek.

Kullanım:
- İç sorguda dönemsel özet: DATETRUNC(YEAR, order_date), SUM(sales_amount), AVG(price).
- Dış sorguda pencere fonksiyonları:
  - SUM(total_sales) OVER (ORDER BY order_date)  -- kümülatif toplam
  - AVG(avg_price)  OVER (ORDER BY order_date)   -- hareketli ortalama

Dikkat:
- SQL Server 2022+ gerektirir (DATETRUNC).
- Yıllık yerine aylık analiz istenirse: DATETRUNC(MONTH, order_date).
*/

-- Cumulative Analysis

-- Calculate the total sales per month
-- and the running total of sales over time
SELECT
	order_date,
	total_sales,
	SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales,
	AVG(avg_price) OVER (ORDER BY order_date) AS moving_average_price

FROM
(
	SELECT
		DATETRUNC( YEAR, order_date) AS order_date,
		SUM(sales_amount) AS total_sales,
		AVG(price) AS avg_price
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATETRUNC( YEAR, order_date) 

) AS t
