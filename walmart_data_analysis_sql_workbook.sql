create database if not exists salesDataWalmart;

create table if not exists sales(
	invoice_id varchar(30) not null primary key,
    branch varchar(5) not null,
    city varchar(30) not null,
    customer_type varchar(30) not null,
    gender varchar(10) not null,
    product_line varchar(100) not null,
    unit_price decimal(10,2) not null,
    quantity int not null,
    VAT float(6,4) not null,
    total Decimal(12,4) not null,
    date DATETIME not null,
    time TIME not null,
    payment_method varchar(15) not null,
    cogs DECIMAL(10,2) not null,
    gross_margin_pct float(11,9) not null,
    gross_income decimal(12,4) not null,
    rating float(2,1) 
    );
    
#feature engineering
#time_of_day

alter table sales add column time_of_day Varchar(20);

update sales
set time_of_day = (case
    when `time` between "00:00:00" and "12:00:00" then "Morning"
    when `time` between "12:01:00" and "16:00:00" then "Afternoon"
    else "Evening"
    end
);

#day_name: weekdays

alter table sales add column day_name varchar(10);

update sales
set day_name= dayname(date);

#month_column
alter table sales add column month_name varchar(10);

update sales
set month_name= monthname(date);

#Generic
#how many unique cities does data have?

select distinct city
from sales;

#how many unique branches are there in a city?
select distinct branch
from sales;

select distinct city,branch
from sales;

#how many unique product lines does data have?
select COunt(distinct product_line);

#what is the most common payment method?
select payment_method,
count(payment_method) as cnt
from sales
group by payment_method
order by cnt desc;

select product_line,
count(product_line) as cnt
from sales
group by product_line
order by cnt desc;

#what is the total revenue by month?
select month_name, sum(total) as cnt
from sales
group by month_name
order by cnt desc;

#what month had largest cogs?
select month_name as month,sum(cogs) as cogs
from sales 
group by month_name
order by cogs desc;

#what product line as largest revenue?
select product_line, sum(total) as revenue
from sales
group by product_line
order by revenue;

#what is the city with the largest revenue?
select branch, city, sum(total) as revenue
from sales
group by city, branch
order by revenue;

#what product line had the largest VAT?
select product_line, avg(VAT) as avg_tax
from sales
group by product_line
order by avg_tax desc;

#which branch sold more product than average product sold?
select branch,
sum(quantity) as qty
from sales
group by branch
having sum(quantity) > (select avg(quantity) from sales);

#what is the most common product line by gender?
select gender, product_line, count(gender) as total_cnt
from sales
group by gender,product_line
order by total_cnt desc;

#what is the average rating of each product line?
select round(avg(rating),2) as avg_rating, product_line 
from sales
group by product_line
order by avg_rating desc;

#Sales Questions
#number of sales made in each time of the day per weekday
select time_of_day,count(*) as total_sales
from sales
where day_name ="Monday"
group by time_of_day
order by total_sales desc;

#which of the customer bring more revenue
select customer_type,sum(total) as revenue
from sales
group by customer_type
order by customer_type desc;

#which city has the largest tax percent?
select city, sum(VAT) as vat
from sales
group by city
order by vat desc;

#which customer type pays the most in VAT?
select customer_type, sum(VAT) as vat
from sales
group by customer_type
order by vat desc;

#customers
#how many unique customer types does the data have?
select distinct customer_type
from sales;

#how many unique payment methods does the data have?
select distinct payment_method
from sales;

#what is the most common customer type?
select customer_type, count(customer_type) as cnt
from sales
group by customer_type
order by cnt desc;

#which customer type buys the most?
select customer_type,
count(*) as cst_cnt
from sales
group by customer_type ;

#what is gender of most of the customer
select gender,
count(*) as gen_cnt
from sales
group by gender 
order by gen_cnt desc;

#what is the gender distribution per branch?
select gender, count(*) as gen
from sales
where branch = "A"
group by gender
order by gen;

#what time of day customer give most rating?
select time_of_day, avg(rating) as rate
from sales
group by time_of_day
order by rate desc; 

#what time of day customer give most rating per branch?
select time_of_day,  count(rating)as rate
from sales
where branch="C"
group by time_of_day, branch
order by rate desc; 

#which day of the week has the best avg rating?
select day_name, avg(rating) as rate
from sales
group by day_name
order by rate desc;

#which day of the week has the best avg ratings per branch?
select day_name, avg(rating) as rate
from sales
where branch='A'
group by day_name
order by rate desc;