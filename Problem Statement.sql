SELECT * FROM coffee_shop_sales;

# 1. Display detailed metrics for days in a month
SELECT 
	DAY(transaction_date) AS day_sales,					-- dalam sebulan menampilkan metric tiap hari yang tercata
    CONCAT(ROUND(SUM(unit_price * transaction_qty)/1000, 2), 'K') AS revenue,
    COUNT(transaction_id) AS orders,
    SUM(transaction_qty) AS quantity
FROM
	coffee_shop_sales
WHERE
	MONTH(transaction_date) = 4 
GROUP BY
	DAY(transaction_date)
ORDER BY
	DAY(transaction_date);

# 2a. Sales Analysis by Weekday and Weekend    
SELECT
	CONCAT(ROUND(SUM(transaction_qty * unit_price)/1000, 2), 'K') AS revenue,
    COUNT(transaction_id) AS orders,
    SUM(transaction_qty) AS quantity
FROM
	coffee_shop_sales
WHERE
	MONTH(transaction_date) = 4 AND
    WEEKDAY(transaction_date) BETWEEN 5 AND 6;			-- hanya menampilkan hari sabtu dan minggu saja (index 5 dan 6)

# 2a. Another version
SELECT 
	CASE WHEN DAYOFWEEK(transaction_date) IN (1, 7) THEN 'Weekend'
	ELSE 'Weekday'
    END AS day_type,
    CONCAT(ROUND(SUM(transaction_qty * unit_price)/1000, 2), 'K') AS revenue
FROM coffee_shop_sales
WHERE MONTH(transaction_date) = 5
GROUP BY 
	CASE WHEN DAYOFWEEK(transaction_date) IN (1, 7) THEN 'Weekend'			-- mengelompokkan berdasarkan kriteria weekday dan weekend
	ELSE 'Weekday'
    END;

# 3. Sales analysis by Store location
SELECT
	store_location,
    CONCAT(ROUND(SUM(unit_price * transaction_qty)/1000, 2), 'K') AS revenue
FROM coffee_shop_sales
WHERE MONTH(transaction_date) = 5
GROUP BY																	-- mengeompokkan hasil query berdasarkan lokasi toko
	store_location
ORDER BY revenue DESC;

# 4. Membuat average/rata-rata sales dalam satu bulan lalu membandingkannya dengan sales per hari
SELECT
	CONCAT(ROUND(AVG(total_sales)/1000,2), 'K') as Avg_Sales
FROM 
	(
	SELECT SUM(unit_price * transaction_qty) AS total_sales
    FROM coffee_shop_sales 
    WHERE MONTH(transaction_date) = 5
    GROUP BY transaction_date
    ) AS Internal_query;
    
SELECT
	DAY(transaction_date) AS day_of_month,
    CONCAT(ROUND(SUM(unit_price * transaction_qty)/1000,2), 'K') AS day_sales
FROM 
	coffee_shop_sales 
WHERE 
	MONTH(transaction_date) = 5
GROUP BY 
	DAY(transaction_date)
ORDER BY 
	DAY(transaction_date);

# 4b. Membandingkan penjualan harian dengan rata-rata sales pada bulan tersebut    
SELECT 
	day_of_month,
    CONCAT(ROUND(avg_sales/1000,2), 'K') AS average_sales,
    CASE WHEN day_sales > avg_sales THEN 'Above Average'
		 WHEN day_sales < avg_sales THEN 'Below Average'
         ELSE 'AVERAGE'
         END AS sales_status,
	day_sales
FROM 
	(
	SELECT	
		DAY(transaction_date) AS day_of_month, 
        SUM(unit_price * transaction_qty) AS day_sales,
        AVG(SUM(unit_price * transaction_qty)) OVER() AS avg_sales
	FROM 
		coffee_shop_sales 
	WHERE 
		MONTH(transaction_date) = 5
	GROUP BY 
		DAY(transaction_date)
    ) AS sales_data
ORDER BY day_of_month;

# 5. Sales analysis by Product category
SELECT
	product_category,
    ROUND(SUM(unit_price * transaction_qty), 2) AS revenue
FROM 
	coffee_shop_sales
WHERE 
	MONTH(transaction_date) = 5
GROUP BY 
	product_category
ORDER BY revenue DESC;

# 6. Top 10 product
SELECT
	product_type,
    product_category,
    ROUND(SUM(unit_price * transaction_qty), 2) AS revenue
FROM 
	coffee_shop_sales
WHERE
	MONTH(transaction_date) = 5 AND product_category = 'Coffee'
GROUP BY 
	product_type
ORDER BY 
	revenue DESC
LIMIT 10;

# 7. Sales analysis by days and hours
SELECT
    ROUND(SUM(unit_price * transaction_qty), 2) AS Revenue,
    SUM(transaction_qty) AS Total_Quantity,
    COUNT(*) AS Total_Order
FROM 
	coffee_shop_sales
WHERE
	MONTH(transaction_date) = 5
    AND WEEKDAY(transaction_date) = 6 			-- Weekday menggunakan sistem 0-6 (Senin - Minggu) sementara DAYOFWEEK menggunakan 1-7 (Minggu, Senin ... Sabtu)
    AND HOUR(transaction_time) = 14;
    
# 7b. Display Sales grouped by Hour 
SELECT
	HOUR(transaction_time) AS Operational_Hour,
    ROUND(SUM(unit_price * transaction_qty), 2) AS Revenue,
    SUM(transaction_qty) AS Total_Quantity,
    COUNT(*) AS Total_Order
FROM coffee_shop_sales
WHERE MONTH(transaction_date) = 5
GROUP BY HOUR(transaction_time)
ORDER BY HOUR(transaction_time);

# 7c. Display Sales grouped by Day (Per Hari seperti Senin, Selasa, Rabu ..., Minggu)
SELECT
	DAYNAME(transaction_date) AS Operational_Day,				-- DAYNAME merupakan fungsi yang mengambil data tanggal dan mengidentifikasi nama hari di tanggal tsb
    ROUND(SUM(unit_price * transaction_qty), 2) AS Revenue,
    SUM(transaction_qty) AS Total_Quantity,
    COUNT(*) AS Total_Order
FROM coffee_shop_sales
WHERE MONTH(transaction_date) = 5								-- Mencari data sales untuk bulan Mei
GROUP BY DAYNAME(transaction_date)

-- Dari Query 7c bisa didapat insight yaitu penjualan tertinggi ada pada hari senin, selasa, rabu dan sales terendah ada pada hari minggu
-- Mungkin dikarenakan pada weekday customer yang sering dilayani adalah pekerja kantoran sehingga ramai pada weekday
-- Terjadi penurunan pada kamis dan jumat bisa saja dikarenakan ada kebijakan beberapa kantor yang hanya bekerja 3 hari on site dan sisanya off site sehingga pelanggan menurun
-- Dari sana juga bisa juga mengusulkan untuk menambah shift karyawan yang bekerja di 3 hari tersebut karena pelanggan lebih ramai
-- Hal yang sama juga bisa berlaku pada bahan baku, disiapkan lebih banyak untuk 3 hari tersebut. Jika diperdalam bahkan juga bisa disiapkan bahan untuk item2 tertentu yang lebih laris