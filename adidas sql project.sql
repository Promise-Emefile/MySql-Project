create database adidas_sales;
use adidas_sales;

#Retrieve all data
select * from adidas;

#retrieve southeast region
select region from adidas
where region = "southeast";

#show all sales record by retailer "Foot Locker"
select retailer, units_sold, total_sales, sales_method
from adidas
where retailer = "Foot Locker";

#Calculate the total sales of "Total_sales for each retailer
select distinct retailer as DR, sum(total_sales) from adidas
group by DR;

#find the average price_per_unit of each product
select distinct product as DP, avg(price_per_unit) from adidas
group by DP;

#determine which product had the highest total_sales
select distinct product as DP, max(total_sales) as MTS
from adidas
group by DP
order by MTS
desc limit 1;

#calculate the sum of operating_profit of each region
select distinct region as DR, sum(operating_profit) from adidas
group by DR;

#display all records where the invoice_date falls between 2021-03-01 and 2021-06-01
select * from adidas
where str_to_date(invoice_date, "%m/%d/%y") between "2020-01-03" and "2020-06-01";

