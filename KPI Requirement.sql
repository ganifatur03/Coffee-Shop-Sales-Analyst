SELECT * FROM coffee_shop_sales;

# 1. Menghitung Total Sales per bulan
SELECT ROUND(SUM(unit_price * transaction_qty),1) AS total_sales
FROM coffee_shop_sales
WHERE MONTH(transaction_date) = 5;		-- May Month

# Menghitung Perbedaan Sales antar bulan ini dengan bulan sebelumnya dalam persentase
SELECT 
	MONTH(transaction_date) AS month_sales,		-- displaying number month in calculation
    ROUND(SUM(unit_price * transaction_qty)) AS total_sales,	-- displaying total sales for selected month
    (SUM(unit_price * transaction_qty) - 						
    LAG(SUM(unit_price * transaction_qty), 1) OVER (ORDER BY MONTH(transaction_date))) / 		-- displaying the difference of sales between current and previous month
    LAG(SUM(unit_price * transaction_qty), 1) OVER (ORDER BY MONTH(transaction_date)) * 100 	-- the sales difference divide by sales this month and multiplied by 100, this will give the difference sales in percentage
    AS mom_increase_percentage		

FROM 
	coffee_shop_sales
WHERE 
	MONTH(transaction_date) IN (3, 4, 5)    -- for month of April (Previous Month) and May (Current Month)
GROUP BY
	MONTH(transaction_date)
ORDER BY
	MONTH(transaction_date);

# 2. Menghitung total order per bulan
SELECT
	MONTH(transaction_date) AS month_sales,
    COUNT(transaction_id) AS total_order
FROM 
	coffee_shop_sales
WHERE 
	MONTH(transaction_date) = 5;
 
# Menghitung perbedaan jumlah order bulan ini dengan bulan sebelumnya dalam persentase
SELECT 
	MONTH(transaction_date) AS month_sales,
    COUNT(transaction_id) AS number_order,
    COUNT(transaction_id) - LAG(COUNT(transaction_id),1) OVER (ORDER BY MONTH(transaction_date)) AS prev_month_order_difference,
    (COUNT(transaction_id) - 
    LAG(COUNT(transaction_id),1) OVER (ORDER BY MONTH(transaction_date))) /
    LAG(COUNT(transaction_id),1) OVER (ORDER BY MONTH(transaction_date)) * 100 AS mom_order_difference
FROM
	coffee_shop_sales
WHERE
	MONTH(transaction_date) IN (4, 5)
GROUP BY
	MONTH(transaction_date)
ORDER BY
	MONTH(transaction_date);
    
# 3. Menghitung Total Quantity sold per bulan
SELECT 
	MONTH(transaction_date) AS month_sales,
	SUM(transaction_qty) AS total_order
FROM
	coffee_shop_sales
WHERE
	MONTH(transaction_date) = 6;
    
# Menghitung Perbedaan jumlah Quantity Sold bulan ini dengan bulan sebelumnya dalam persentase
SELECT 
	MONTH(transaction_date) AS month_sales,		-- displaying number month in calculation
    SUM(transaction_qty) AS total_quantity_sold,	-- displaying total sales for selected month
    SUM(transaction_qty) - LAG(SUM(transaction_qty), 1) OVER (ORDER BY MONTH(transaction_date)) AS prev_month_difference,
    (SUM(transaction_qty) - 
    LAG(SUM(transaction_qty), 1) OVER (ORDER BY MONTH(transaction_date))) /
    LAG(SUM(transaction_qty), 1) OVER (ORDER BY MONTH(transaction_date))  * 100 
    AS mom_quantity_sold_percentage
FROM
	coffee_shop_sales
WHERE
	MONTH(transaction_date) IN (4, 5)
GROUP BY
	MONTH(transaction_date)
ORDER BY
	MONTH(transaction_date);