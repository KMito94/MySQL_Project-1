-- SQL Retail Sales Analysis Project 1

-- Creating Database
CREATE database MySQL_ProjectP1;

-- Create Table and import the data into the database

CREATE TABLE retail_sales 
		(
				transactions_id INT PRIMARY KEY,
				sale_date DATE,
                sale_time TIME,
                customer_id INT,
                gender VARCHAR(15),
                age INT,
                category VARCHAR(15),
                quantity INT,
                price_per_unit FLOAT,
                cogs FLOAT,
                total_sale FLOAT 
		)
SELECT * FROM retail_sales;

-- checking that all the information is correctly imported

SELECT COUNT(*) from retail_sales;

-- we can check if we have null values and deal with them 

SELECT * FROM retail_sales 
WHERE 
	transactions_id IS NULL
    or
    sale_date IS NULL 
    or
    sale_time IS NULL 
    or
    gender IS NULL 
    or
    category IS NULL 
    or
    quantity IS NULL
    or 
    cogs IS NULL 
    or
    total_sale is NULL;
-- 	In this case we have no null values in our dataset 

-- Data Exploration 
-- Q1. How many sales do we have 

SELECT COUNT(*) as total_sales FROM retail_sales;

-- Q2. How many unique customers do we have 

SELECT COUNT(DISTINCT customer_id) as number_of_customers  FROM retail_sales;

-- Q3. How many unique categories do we have 

SELECT COUNT(DISTINCT category) as unique_categres  FROM retail_sales;

-- BUSINESS RELATED PROBLEMS 
-- Q1. The sales made on specific date e.g '2022-11-05'
SELECT * FROM retail_sales 
	WHERE sale_date = '2022-11-05';  
    
-- Q2. Write an SQL query where the category is Beauty  and the quantity is more than or equal to 4 in the month of Novemer 2022
    
    SELECT * FROM retail_sales 
    WHERE category = 'Beauty' 
		AND YEAR(sale_date) = '2022' 
        AND MONTH(sale_date) = '11'
        AND quantity >=4 ;

-- Q3.Write a SQL query to calculate the total sale for each categotry and total number of orders 
SELECT category,sum(total_sale) as category_sale, COUNT(*) as total_orders 
	FROM retail_sales
	group by 1;
    
-- Q4. Write and SQL query to get the average age of customers who bought from the beauty category
SELECT ROUND(AVG(age), 2) as avg_age
	FROM retail_sales
    WHERE category = 'Beauty';
    
-- Q5. Write an SQL query find all the transactions where the total_sale is greater than 1000
SELECT 
	* FROM retail_sales
    WHERE total_sale > 1000;
-- Q6. Write an SQL query to find the total number of transactions made by each gender in each category

SELECT category, gender, COUNT(*) as total_transactions 
	FROM retail_sales
    GROUP BY gender, category
    ORDER BY gender;
-- Q7. Write a SQL query to calculate the average sale for each month. Find out the best selling month in each year 
SELECT year,
	month,
    avg_sale 
FROM
(
	SELECT  YEAR(sale_date) as year , MONTH(sale_date) as month, 
	AVG(total_sale) as avg_sale,
	RANK() over (PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) as rnk
	FROM retail_sales
	GROUP BY 1,2 
) as t1 WHERE rnk  =1;

-- Q8. Write a query to find top five customers based on total sales
 SELECT * FROM retail_sales
	LIMIT 10;

SELECT DISTINCT customer_id , SUM(total_sale ) as total_customer_sale
	FROM retail_sales
    GROUP BY customer_id
    ORDER BY SUM(total_sale) DESC
    LIMIT 5;
-- Q9. Write a SQL query to find the number of unique customers who purchased items from each category

SELECT  category, COUNT( DISTINCT customer_id) AS total_customers 
	FROM retail_sales
    GROUP BY category;

-- Q10.Write a SQL query to create each shift and number of orders ( Example morning <=12,
-- afternoon between 12 and 17 ockclock and  evevening greater than 17 oclock;)

WITH sales_per_hour
AS 
(
SELECT 	 
    CASE 
    WHEN HOUR(sale_time) <= 12 THEN 'Morning'
    WHEN HOUR(sale_time)  BETWEEN 12 AND 17 THEN 'Afternoon'
    ELSE 'Evening' END as Shift 
    FROM retail_sales 
)
SELECT Shift,
	COUNT(*) AS total_sales
FROM sales_per_hour
GROUP BY Shift;
	
    
    

