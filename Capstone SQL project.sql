Create DATABASE Amazon1;
use amazon1;
create table amazon_sales(invoice_id VARCHAR(30), branch VARCHAR(5), city VARCHAR(30), 
customer_type VARCHAR(30), gender VARCHAR(10), product_line VARCHAR(100), unit_price DECIMAL(10, 2), 
quantity INT, VAT FLOAT(6, 4),total DECIMAL(10, 2), date VARCHAR(30), time VARCHAR(30), payment_method VARCHAR(200),
cogs DECIMAL(10, 2),gross_margin_percentage FLOAT(11, 9), gross_income DECIMAL(10, 2), rating FLOAT(11,9))
select * from amazon_sales;
select * from amazon_salesinfo;

INSERT INTO amazon_sales
SELECT * FROM amazon_salesinfo;

Alter table amazon_sales    # new column added
add column timeofday varchar(15);

update amazon_sales    # updated as per quetion required
set timeofday = case 
                   when hour(time) >=0 and hour(time) < 12 then "Morning"
                   when hour(time) >=12 and hour(time) < 0 then "Afternoon"
                   else "Evening"
				end;
                
ALTER table amazon_sales    # added new column
add column dayname varchar(15);

update amazon_sales     # updated per que
set dayname = case dayofweek(date)
                when 1 then 'Sun'
                when 2 then 'Mon'
                when 3 then 'tue'
                when 4 then 'Web'
                when 5 then 'Thur'
                when 6 then 'Fri'
                else 'Sat'
              END;  

ALTER table amazon_sales   # added new column
add column monthname VARCHAR(15);

update amazon_sales    # updated as per que
 set monthname = case month(date)
                    when 1 then 'Jan'
                    when 2 then 'Feb'
                    when 3 then 'Mar'
                    when 4 then 'April'
                    when 5 then 'May'
                    when 6 then 'June'
                    when 7 then 'July'
                    when 8 then 'Aug'
                    when 9 then 'Sep'
                    when 10 then 'Oct'
                    when 11 then 'Nov'
                    else 'Dec'
				   end;
-------------------------------------------------------------------------------------                   
# 1. What is the count of distinct cities in the dataset?
select count(DISTINCT city) as city_count from amazon_sales;
 
# 2. For each branch, what is the corresponding city?
select DISTINCT branch,city from amazon_sales;

# 3. What is the count of distinct product lines in the dataset?
select count(DISTINCT product_line) as prod_count from amazon_sales;

# 4. Which payment method occurs most frequently?
select payment_method, count(*) as pay_count from amazon_sales
GROUP BY payment_method
order by pay_count desc
limit 1;

# 5. Which product line has the highest sales?
select product_line,count(invoice_id) as high_sales from amazon_sales
group by product_line
order by high_sales desc
limit 1;

# 6. How much revenue is generated each month?
select monthname as month, sum(total) as total_rev from amazon_sales
group by monthname
order by total_rev desc;

# 7. In which month did the cost of goods sold reach its peak?
select monthname as month, sum(cogs) as cogs_sum from amazon_sales
group by monthname
order by cogs_sum desc
limit 1;

# 8. Which product line generated the highest revenue?
select product_line, sum(total) as high_rev from amazon_sales
group by product_line
order by high_rev desc
limit 1;

# 9. In which city was the highest revenue recorded?
Select city, sum(total) as high_rev from amazon_sales
group by city
order by high_rev desc
limit 1;

# 10. Which product line incurred the highest Value Added Tax?
select product_line, sum(vat) as high_vat from amazon_sales
group by product_line
order by high_vat
limit 1;

# 11. For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."
Select product_line, 
                    case
                     when gross_income > (select avg(gross_income) from amazon_sales) then 'Good'
                     else 'Bad'
					end as sales_performance
from amazon_sales;

# 12. Identify the branch that exceeded the average number of products sold.
Select branch, sum(quantity) as total_quantity from amazon_sales
group by branch
having sum(quantity) > (select avg(quantity) from amazon_sales)
limit 1;

# 13. Which product line is most frequently associated with each gender?
select product_line, gender, count(*) as frequency
from amazon_sales
group by gender, product_line
order by gender, frequency DESC;

# 14. Calculate the average rating for each product line.
select round(avg(rating),2) as avg_rating, product_line from amazon_sales
group by product_line
order by avg_rating;

# 15. Count the sales occurrences for each time of day on every weekday.
select dayname(date) as weekday,
                               case
                                when hour(time) >= 6 and hour(time) <= 12 then 'Morning'
                                when hour(time) >= 12 and hour(time) <= 18 then 'Afternoon'
                                else 'Evening'
							   end as timeof_day,
                               count(*) as sales_occurance
from amazon_sales
group by weekday,timeof_day
order by sales_occurance desc;

# 16. Identify the customer type contributing the highest revenue.
select customer_type, sum(total) as total_rev from amazon_sales
group by customer_type
order by total_rev desc
limit 1;
                          
# 17. Determine the city with the highest VAT percentage.
select city, max(vat/total)*100 as high_vat from amazon_sales
group by city
order by high_vat desc
limit 1;

# 18. Identify the customer type with the highest VAT payments.
select customer_type, max(vat) as high_vat from amazon_sales
group by customer_type
order by high_vat desc
limit 1;

# 19. What is the count of distinct customer types in the dataset?
select count(distinct customer_type) as diff_cust 
from amazon_sales;

# 20. What is the count of distinct payment methods in the dataset?
select count(DISTINCT payment_method) as disc_paymethod
from amazon_sales;
select payment_method from amazon_sales;

# 21. Which customer type occurs most frequently?
Select customer_type, count(invoice_id) as freq from amazon_sales
group by customer_type
order by freq desc
limit 1;

# 22. Identify the customer type with the highest purchase frequency.
select customer_type, count(*) as high_freq from amazon_sales
group by customer_type
order by high_freq desc
limit 1;

# 23. Determine the predominant gender among customers.
SELECT gender, count(*) as high_freq from amazon_sales
group by gender
order by high_freq desc
limit 1;

# 24. Examine the distribution of genders within each branch.
select branch,gender,count('Invoice_id') as freq_inv from amazon_sales
group by branch,gender
order by branch,freq_inv desc;

# 25. Identify the time of day when customers provide the most ratings.
select dayname,time, count(rating) as most_rating from amazon_sales
group by dayname,time
order by most_rating desc
limit 1;


# 26. Determine the time of day with the highest customer ratings for each branch.
select dayname,time, branch, max(rating) as high_rating from amazon_sales
group by dayname,time, branch
order by high_rating desc
limit 1;

# 27. Identify the day of the week with the highest average ratings.
select dayname, avg(rating) as high_rate from amazon_sales
group by dayname
order by high_rate desc
limit 1;

# 28. Determine the day of the week with the highest average ratings for each branch.
Select dayname,branch, avg(rating) as high_rate from amazon_sales
group by dayname,branch
order by high_rate desc
limit 1;



