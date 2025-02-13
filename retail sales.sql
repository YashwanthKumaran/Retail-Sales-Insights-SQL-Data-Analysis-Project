USE retail_sales


-- Create Table
CREATE TABLE retail_sales
			(
				transactions_id	INT PRIMARY KEY,
                sale_date DATE,
                sale_time TIME,
                customer_id INT,
                gender VARCHAR(25),
                age	INT,
                category VARCHAR(15),
                quantity INT,
                price_per_unit FLOAT,
                cogs FLOAT,
                total_sale FLOAT
                );


-- Data Cleaning
DELETE FROM retail_sales
WHERE 
transactions_id IS NULL
OR
sale_date IS NULL
OR
sale_time IS NULL
OR
gender IS NULL
OR
quantity IS NULL
OR
price_per_unit IS NULL
OR
cogs IS NULL
OR
total_sale IS NULL;

-- Data Exploration

-- Total number of sales
SELECT COUNT(*) AS TOTAL_SALES FROM retail_sales

-- Total number of customers we have
SELECT COUNT(DISTINCT customer_id) AS TOTAL_CUSTOMERS FROM retail_sales

-- Total number of categories we have
SELECT count(DISTINCT category) FROM retail_sales

-- What are the categories
SELECT DISTINCT category FROM retail_sales


-- Data Analysis & Business Key Problems and Answers
-- Q1 Write a SQL query to retrieve all columns for sales made on 1900-03-22:
SELECT * 
FROM retail_sales
WHERE sale_date = "1900-03-22";

-- Q2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of March-1900:
SELECT *
FROM retail_sales
WHERE category = "clothing"
AND quantity > 3
AND sale_date >= "1900-03-01" AND sale_date <= "1900-03-31"

-- Q3 Write a SQL query to calculate the total sales (total_sale) for each category.:
SELECT category, SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY 1

-- Q4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
SELECT 	AVG(age)
FROM retail_sales
WHERE category = "Beauty"

-- Q5 Write a SQL query to find all transactions where the total_sale is greater than 1000.:
SELECT *
FROM retail_sales
WHERE total_sale > 1000

-- Q6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
SELECT category, gender,count(*) as total_transaction
FROM retail_sales
GROUP BY category, gender
ORDER BY 1

-- Q7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
SELECT * FROM 
(
SELECT 
extract(YEAR FROM sale_date) AS year,
extract(MONTH FROM sale_date) AS month,
AVG(total_sale) AS avg_sale,
RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank_
FROM retail_sales
GROUP BY 1,2
) AS t1
WHERE rank_ = 1

-- Q8 Write a SQL query to find the top 5 customers based on the highest total sales :
SELECT customer_id, SUM(total_sale)
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5
    
-- Q9 Write a SQL query to find the number of unique customers who purchased items from each category.:
SELECT category, COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY 1

-- Q10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
SELECT
	CASE 
		WHEN HOUR(sale_time) <12 THEN "Morning"
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN "Afternoon"
        ELSE "Evening"
        END AS shift,
        count(*)
	FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC

-- End of project