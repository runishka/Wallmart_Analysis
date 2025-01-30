USE WALLMART;
CREATE TABLE WALLMART_ANALYSIS
    (
        invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
        branch VARCHAR(5) NOT NULL,
        city VARCHAR(30) NOT NULL,
        customer_type VARCHAR(30) NOT NULL,
        gender VARCHAR(30) NOT NULL,
        product_line VARCHAR(100) NOT NULL,
        unit_price DECIMAL(10, 2) NOT NULL,
        quantity INT NOT NULL,
        tax_pct FLOAT (6, 4) NOT NULL,
        total DECIMAL(12, 4) NOT NULL,
        date DATETIME NOT NULL,
        time TIME NOT NULL,
        payment VARCHAR(15) NOT NULL,
        cogs DECIMAL(10, 2) NOT NULL,
        gross_margin_pct FLOAT (11, 9),
        gross_income DECIMAL(12, 4),
        rating FLOAT (2, 1));
        
-- displaying the column names          
SELECT * from wallmart_analysis;

                    -- -- -- -- --  Feature Engineering -- -- -- -- --

-- Time of Day
SELECT
    time,
    CASE
        WHEN `time` >= "00:00:00" AND `time` < "12:00:00" THEN "Morning"
        WHEN `time` >= "12:00:00" AND `time` < "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END AS time_of_day
FROM wallmart_analysis;-- 



-- Adding column day name 
ALTER TABLE wallmart_analysis 
ADD COLUMN day_name VARCHAR(10);
UPDATE wallmart_analysis 
SET day_name = DAYNAME(date);


--  Adding column month name 
ALTER TABLE wallmart_analysis ADD column month_name VARCHAR(10);
UPDATe wallmart_analysis SET month_name =MONTHNAME(DATE);

--  Q1How many unique cities does the data have?
SELECT DISTINCT city FROM wallmart_analysis;

--  Q2 In which city is each branch?
SELECT DISTINCT city,branch FROM wallmart_analysis;

-- ---------------------------------------------------------------------
-- ---------------------------- Product --------------------------------
-- ---------------------------------------------------------------------

-- Q3 How many unique product lines does the data have?
SELECT DISTINCT PRODUCT_LINE FROM WALLMART_ANALYSIS ;

-- Q4 What is the most common payment method?
SELECT PAYMENT,COUNT(PAYMENT)AS PAYMENT_COUNT 
FROM WALLMART_ANALYSIS 
GROUP BY PAYMENT
ORDER BY PAYMENT_COUNT DESC; 

-- Q5 Which selling product line is the most ?
SELECT PRODUCT_LINE,COUNT(PRODUCT_LINE)AS PRODUCT_LINE_COUNT  
FROM WALLMART_ANALYSIS 
GROUP BY PRODUCT_LINE
ORDER BY PRODUCT_LINE_COUNT DESC; 

-- Q6 What is the most selling product line
 
SELECT
	SUM(quantity) as qty,
    product_line
FROM WALLMART_ANALYSIS
GROUP BY product_line
ORDER BY qty DESC;

-- Q7 What is the total revenue by month?
SELECT month_name as month , sum(total) as total_revenue 
from wallmart_analysis group by month order by total_revenue desc;  

-- Q8 What month had the largest COGS?
select month_name,sum(cogs) as largest_cogs from wallmart_analysis
group by month_name
order by largest_cogs desc; 

-- Q9 What product line had the largest revenue?
select product_line, sum(total) as total_Revenue 
from wallmart.wallmart_analysis
group by product_line 
order by  total_Revenue desc;

-- Q10 What is the city with the largest revenue?
select city , branch , sum(total)as total_Revenue 
from wallmart.wallmart_analysis
group by city, branch 
order by  total_Revenue desc;
 

-- Q11 What product line had the largest VAT?
SELECT
    product_line,
    SUM(0.05 * cogs) AS total_vat
FROM wallmart.wallmart_analysis
GROUP BY product_line
ORDER BY total_vat DESC
LIMIT 1;

-- Q12 Fetch each product line and add a column to those product line 
-- showing "Good", "Bad". Good if its greater than average sales 
select avg(quantity) from wallmart_analysis;
SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 5.49 THEN "Good"
        ELSE "Bad"
    END AS remark
    FROM wallmart.wallmart_analysis

GROUP BY product_line;


-- Q13 Which branch sold more products than average product sold 
Select branch, sum(quantity) as quantity_sold from wallmart.wallmart_analysis 
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM wallmart.wallmart_analysis);


-- Q14 What is the most common product line by gender?
SELECT
	gender,
    product_line,
    COUNT(gender) AS total_cnt
FROM wallmart.wallmart_analysis
GROUP BY gender, product_line
ORDER BY total_cnt DESC;

-- Q15 What is the average rating of each product line?
select product_line , round(avg(rating),2) as avg_rating
from wallmart.wallmart_analysis 
group by product_line 
order by  avg_rating;

-- --------------------------------------------------------------------
-- -------------------------- Sales -----------------------------------
-- --------------------------------------------------------------------
-- Q16 Number of sales made in each time of the day per weekday
SELECT
	time_of_day,
	COUNT(*) AS total_sales
FROM WALLMART.WALLMART_ANALYSIS
WHERE day_name = "Sunday"
GROUP BY time_of_day 
ORDER BY total_sales DESC;

-- Q17 Which of the customer types brings the most revenue?
SELECT
    customer_type,
    SUM(TOTAL) AS total_revenue
FROM
    wallmart.wallmart_analysis
GROUP BY
    customer_type
ORDER BY
    total_revenue DESC;

-- Q18 Which city has the largest tax percent/ VAT (Value Added Tax)?
select 
	city,
    ROUND(AVG(tax_pct), 2) AS avg_tax_pct
from wallmart.wallmart_analysis
group by city order by avg_tax_pct desc;

-- Q19 Which customer type pays the most in VAT?
	SELECT
		customer_type,
		round(Max(tax_pct),2) AS total_vat
	FROM
		wallmart.wallmart_analysis
	GROUP BY
		customer_type
	ORDER BY
		total_vat DESC;

-- --------------------------------------------------------------------
-- -------------------------- Customers -------------------------------
-- --------------------------------------------------------------------

-- Q20 How many unique customer types does the data have?
select distinct customer_type from wallmart.wallmart_analysis;

-- Q21 How many unique payment methods does the data have?
 select distinct payment as payment_method from wallmart.wallmart_analysis;

-- Q22 What is the most common customer type?
select
	customer_type,
	count(*) as count
FROM wallmart.wallmart_analysis
GROUP BY customer_type
ORDER BY count DESC;

-- Q23 Which customer type buys the most?
SELECT
    customer_type,
    round(SUM(total),2) AS total_purchases
FROM
    wallmart.wallmart_analysis
GROUP BY
    customer_type
ORDER BY
    total_purchases DESC;

-- Q24 What is the gender of most of the customers?
SELECT
    gender,
    COUNT(*) AS gender_cnt
FROM
    WALLMART.WALLMART_ANALYSIS
GROUP BY
    gender
ORDER BY
    gender_cnt DESC;

-- Q25 What is the gender distribution per branch?
select branch ,count(gender) as gendercount 
from wallmart.wallmart_analysis
group by branch
order by gendercount desc;

-- Q26 Which time of the day do customers give most ratings?
SELECT
	time_of_day,
	avg(rating) as avg_rating 
FROM wallmart.wallmart_analysis
GROUP BY time_of_day
ORDER BY avg_rating DESC ;

-- Q27 Which time of the day do customers give most ratings per branch?
SELECT
	time_of_day,branch,
	avg(rating) as avg_rating 
FROM wallmart.wallmart_analysis
GROUP BY time_of_day,branch
ORDER BY avg_rating DESC ; 

-- Q28 Which day of the week has the best avg ratings?
SELECT
day_name,
avg(rating) as avg_rating 
FROM wallmart.wallmart_analysis
GROUP BY day_name
ORDER BY avg_rating DESC ; 

-- Q29 Which day of the week has the best average ratings per branch?
select	day_name,
	COUNT(day_name) total_sales
FROM wallmart.wallmart_analysis
WHERE branch = "C"
GROUP BY day_name
ORDER BY total_sales DESC;



