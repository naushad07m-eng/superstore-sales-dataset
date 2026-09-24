

CREATE TABLE sales (
    order_id VARCHAR(50),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(50),
    customer_id VARCHAR(50),
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    region VARCHAR(50),
    category VARCHAR(100),
    sub_category VARCHAR(100),
    product_name TEXT,
    sales NUMERIC(12,2),
    quantity INT,
    discount NUMERIC(5,2),
    profit NUMERIC(12,2),
    order_year INT,
    order_month INT,
    order_month_name VARCHAR(20),
    order_quarter INT,
    order_day INT,
    order_weekday VARCHAR(20),
    shipping_days INT
);

SELECT * FROM sales;

SELECT *
FROM sales
LIMIT 10;

SELECT 
   COUNT(*) AS total_rows
   FROM sales;

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'sales'
ORDER BY ordinal_position;

-- Total Sales | Total Profit | Total Quantity
SELECT 
       SUM(sales) AS total_sales,
	   SUM(profit) AS total_profit,
	   SUM(quantity) AS total_quantity
FROM sales ;

-- Category-wise Sales
SELECT 
      Category,
	  SUM(sales) AS total_sales
FROM sales
GROUP BY category
ORDER BY total_sales DESC ;

-- Category-wise Profit
SELECT 
      Category,
	  SUM(sales) AS total_sales
FROM sales
GROUP BY category
ORDER BY total_sales DESC ;

-- Category-wise Profit
SELECT
      category,
	  SUM(profit) AS total_profit
FROM sales
GROUP BY category
ORDER BY total_profit DESC;

-- Region-wise Sales
SELECT 
      region,
	  SUM(sales) AS total_sales
FROM sales
GROUP BY region
ORDER BY total_sales DESC;
 
 -- we only want those categories whose total sales are greater than 100,000 
SELECT 
      category,
	  SUM(sales) AS total_sales
FROM sales
GROUP BY category
HAVING SUM(sales) > 100000
ORDER BY total_sales DESC;

-- CREATEAD A CUSTOMER TABLE 
CREATE TABLE customers AS
SELECT DISTINCT
    customer_id,
    customer_name,
    segment,
    region
FROM sales;

-- CREATED A PRODUCTS TABLE 
CREATE TABLE products AS
SELECT DISTINCT
    product_name,
    category,
    sub_category
FROM sales;

-- Customer + Sales JOIN
SELECT
    c.customer_name,
    c.segment,
    c.region,
    s.order_id,
    s.sales,
    s.profit
FROM sales s
JOIN customers c
    ON s.customer_id = c.customer_id
LIMIT 10;

-- Sales + Products JOIN
SELECT
    s.order_id,
    p.product_name,
    p.category,
    p.sub_category,
    s.sales,
    s.quantity,
    s.profit
FROM sales s
JOIN products p
    ON s.product_name = p.product_name
LIMIT 10;

-- Three-table JOIN
SELECT
    s.order_id,
    c.customer_name,
    c.segment,
    p.product_name,
    p.category,
    s.region,
    s.sales,
    s.quantity,
    s.profit
FROM sales s
JOIN customers c
    ON s.customer_id = c.customer_id
JOIN products p
    ON s.product_name = p.product_name
LIMIT 10;

-- INNER JOIN
SELECT
    c.customer_name,
    s.order_id,
    s.sales
FROM customers c
INNER JOIN sales s
    ON c.customer_id = s.customer_id
LIMIT 10;

-- LEFT JOIN
SELECT
    c.customer_name,
    s.order_id,
    s.sales
FROM customers c
LEFT JOIN sales s
    ON c.customer_id = s.customer_id
LIMIT 10;

 -- we only want those region whose total sales are greater than 100,000 
SELECT
      region,
	  SUM(sales) AS total_sales
FROM sales
GROUP BY region
HAVING SUM(sales) > 100000
ORDER BY total_sales DESC ;

         -- Subqueries aur Common Table Expressions (CTEs)
		 
-- Which orders have sales higher than the average sales
SELECT 
     order_id,
	 sales,
	 profit
FROM sales
WHERE sales > (
     SELECT
     AVG(sales) 
	 FROM sales
);

-- Average profit se zyada profit wale orders find karo.
SELECT
     order_id,
	 profit,
	 sales 
FROM sales
WHERE sales > (
     SELECT 
	 AVG(profit)
	 FROM sales
);

    -- WINDOWS FUNCTION
-- Find the top 20 orders based on sales and assign a rank to each order, with the highest sales receiving Rank 1.
SELECT
     order_id,
	 sales,
	 product_name,
	 RANK() OVER(
	 ORDER BY sales DESC
	 ) AS sales_rank
FROM sales
LIMIT 20 ;
	 
     -- SQL Views
-- Create a view that shows total sales and total profit for each product category.
CREATE VIEW category_sales_profit AS
SELECT
    category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM sales
GROUP BY category;
-- call this 
SELECT *
FROM category_sales_profit
ORDER BY total_sales DESC;

-- Create a view that shows total sales and total profit for each region.
CREATE VIEW region_sales_profit AS
SELECT 
     region,
	 SUM(sales) AS total_sales,
	 SUM(profit) AS total_profit
FROM sales
GROUP BY region ;
--call this
SELECT * 
FROM region_sales_profit
ORDER BY total_sales DESC ;

   -- Date & Time Functions  
-- Find the total sales for each order year using the existing order_year colum
SELECT 
      order_year,
	  SUM(sales) AS total_sales
FROM sales
GROUP BY order_year
ORDER BY total_sales ;

-- Find the total sales for each month using the existing order_month and order_month_name columns.
SELECT 
     order_month,
	 order_month_name,
	 SUM(sales) AS total_sales
FROM sales
GROUP BY  order_month , order_month_name
ORDER BY order_month ;

      -- KPI & Business Analysis Queries
-- Calculate the total number of orders, total sales, total profit, and total quantity sold.
SELECT 
     COUNT( DISTINCT order_id ) AS total_order,
	 SUM(sales) AS total_sales,
	 SUM(profit) AS total_profit,
	 SUM(quantity) AS total_quantity
FROM sales ;

-- Calculate the average sales value per order.
SELECT 
      SUM(sales) / COUNT(DISTINCT order_id) AS average_order_sales
FROM sales ;

-- Find the top 10 products based on total sales.
SELECT
      product_name,
	  SUM(sales) total_sales
FROM sales
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 10 ;

-- Find the top 10 products based on total profit.
SELECT
     product_name,
	 SUM(profit) AS total_profit
FROM sales
GROUP BY product_name
ORDER BY total_profit
LIMIT 10 ;

-- Find the category with the highest total sales.
SELECT 
      category,
	  SUM(sales) AS total_higest_sales
FROM sales
GROUP BY category
ORDER BY total_higest_sales DESC
LIMIT 1 ;

      -- Advanced Business Analysis
-- Find total sales, total profit, and total quantity for each customer segment.
SELECT
    segment,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(quantity) AS total_quantity
FROM sales
GROUP BY segment
ORDER BY total_sales DESC;

-- Find the products that generated a negative total profit.
SELECT
     product_name,
	 SUM(sales) AS total_sales,
	 SUM(profit) AS total_profit
FROM sales
GROUP BY product_name
HAVING SUM(profit) < 0
ORDER BY total_profit;

-- Find the average discount and total profit for each category.
SELECT 
      category,
	  SUM(profit) AS total_profit,
	  AVG(discount) AS average_discount
FROM sales 
GROUP BY category
ORDER BY average_discount DESC ;

-- Find the regions where total sales are greater than ₹100,000 and total profit is positive.
SELECT 
      region,
	  SUM(sales) AS total_sales,
	  SUM(profit) AS total_profit
FROM sales
GROUP BY region
HAVING SUM(sales) > 100000 AND SUM(profit) > 0
ORDER BY total_sales DESC ; 

    -- CASE 
-- Classify each order as "Profitable", "Loss", or "No Profit" based on its profit
SELECT 
      order_id,
	  profit,
	  sales,
	  CASE
	      WHEN profit > 0 THEN 'Profitable'
		  WHEN profit < 0 THEN 'Loss'
          ELSE 'No Profit'
	  END AS profit_status
FROM sales
LIMIT 12 ;
		  
''' Classify orders into three sales categories: "Low", "Medium", and "High".
 Consider sales below 100 as Low, sales from 100 to 500 as Medium, and sales above 500 as High.'''
SELECT 
      order_id,
	  sales,
	  CASE 
	  WHEN sales < 100 THEN 'Low'
	  WHEN sales <= 500 THEN 'Medium'
	  ELSE 'High'
	  END AS sale_category
FROM sales ;

-- Calculate how many orders are Profitable and how many are Loss-making.
SELECT
    CASE
        WHEN profit > 0 THEN 'Profitable'
        WHEN profit < 0 THEN 'Loss'
        ELSE 'No Profit'
    END AS profit_status,
    COUNT(*) AS order_count
FROM sales
GROUP BY
    CASE
        WHEN profit > 0 THEN 'Profitable'
        WHEN profit < 0 THEN 'Loss'
        ELSE 'No Profit'
    END;

     -- NULL Handling
-- Find the number of records where the customer name is missing.
SELECT COUNT(*) AS missing_customer_name
FROM sales
WHERE customer_name IS NULL ;

-- Find the number of records where the profit value is available.
SELECT COUNT(*) AS available_profit_records
FROM sales
WHERE profit IS NOT NULL;

-- Display the profit for each order, replacing any NULL profit with 0.
SELECT
    order_id,
    COALESCE(profit, 0) AS profit
FROM sales;

     -- Indexes & Query Performance
-- Create an index on the customer_id column to improve queries that search or join using customer IDs.
CREATE INDEX idx_sales_customer_id
ON sales(customer_id);

-- Create an index on the order_date column to improve date-based sales analysis.
CREATE INDEX idx_sales_order_date
ON sales(order_date);

-- List all indexes currently created on the sales table.
SELECT
    indexname,
    indexdef
FROM pg_indexes
WHERE tablename = 'sales';


select * from sales limit 4 ;






