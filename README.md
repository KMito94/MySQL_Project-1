# MySQL_Project-1
The project uses Mysql to do an Exploratory Data Analysis of a sales dataset 

**Introduction **
The following is an Exploratory Data Analysis (EDA) of sales data using MySQL. The aim of the analysis is to retrieve some insights about the data set so that we can advise business owners  the best strategies to implement to improve sales and customer service in their enterprises.
**Creation Of Database and Sales Table** 
First, we create a database and a table where the data is to be stored. After the table is creating the dataset downloaded from Kaggle is then import into MySQL table for exploration.
	CREATE database MySQL_ProjectP1;


CREATE TABLE retail sales 
		(
				transactions_id INT PRIMARY KEY,
				sale_date DATE,
                sale_time TIME,
                customer_id INT,
                gender VARCHAR (15),
                age INT,
                category VARCHAR (15),
                quantity INT,
                price_per_unit FLOAT,
                cogs FLOAT,
                total sale FLOAT 
		)
Checking That the Data Is Correctly Imported 
To ensure all the records are correctly imported, we check the number of records
SELECT COUNT(*) from retail_sales;
In this case, we have a total of 1987 records 
Check For the Null in The Dataset  
Null values interfere with proper data analysis, so they must be checked and deleted from the data set if they do not significantly affect the analysis.
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
There are no null values in the dataset set and therefore we can proceed to answer some business-related problems 
BUSINESS RELATED PROBLEMS 
Q1. What are the sales made on ‘2022-11-06’
	SELECT * FROM retail_sales 
	WHERE sale_date = '2022-11-05';  
This gives all the transactions the happened on that specific date.
Q2. Write an SQL query where the category is Beauty and the quantity is more 4 in the month of November 2022.
	SELECT * FROM retail_sales 
    WHERE category = 'Beauty' 
		AND YEAR(sale_date) = '2022' 
        AND MONTH(sale_date) = '11'
        AND quantity >=4 ;
In in the dataset only six transactions meet all the criteria listed
Q3. Write a SQL query to calculate the total sale for each category and total number of orders
	ELECT category,sum(total_sale) as category_sale, COUNT(*) as total_orders 
	FROM retail_sales
	group by 1;
Q4. Write an SQl query to get the average age of customers who bought from the beauty category 
'''SQL
 	SELECT ROUND(AVG(age), 2) as avg_age
	FROM retail_sales
    WHERE category = 'Beauty';
'''
And this case the average age for a person buying from beauty category is 40 years 
Q5. Write an SQL query find all the transactions where the total_sale is greater than 1000
	SELECT 
	* FROM retail_sales
    WHERE total_sale > 1000;
Q6. Write an SQL query to find the total number of transactions made by each gender in each category 
	SELECT category, gender, COUNT(*) as total_transactions 
	FROM retail_sales
    GROUP BY gender, category
    ORDER BY gender;

Q7. Write a SQL query to calculate the average sale for each month. Find out the best selling month in each year 
In this case we have to use the window function Rank() to get the best selling month in each year 
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

Q8. Write a query to find the top five customers based on total sales 
	SELECT DISTINCT customer_id , SUM(total_sale ) as total_customer_sale
	FROM retail_sales
    GROUP BY customer_id
    ORDER BY SUM(total_sale) DESC
    LIMIT 5;
Q9. Write a SQL query to find the number of unique customers who purchased items from each category
	SELECT  category, COUNT( DISTINCT customer_id) AS total_customers 
	FROM retail_sales
    GROUP BY category;
Q10. Write a SQL query to create each shift and the number of sales in each shift (Morning, Afternoon and Evening)
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
We determine that the evening shift has the highest number of orders 

