use adidas_sales;

#retrieve all records from the dataset
SELECT * FROM adidas;

#Get unique retailers from the dataset
SELECT distinct(retailer) FROM adidas;

#Find all sales Transactions where retailer is walmart
SELECT * FROM adidas
WHERE retailer = "Walmart";

#Checking the Data type of the date column
SELECT DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'adidas' AND COLUMN_NAME = "invoice_date";

#Find all sales Trasactions that occurred in 2021
SELECT invoice_date FROM adidas
WHERE invoice_date Between "1/1/2021" AND  "12/31/2021";

#find the total sales amount for each retailer.
SELECT retailer, sum(total_sales) as total_sales
FROM adidas
GROUP BY retailer;

#Find the average price per unit for each product category
SELECT product, AVG(price_per_unit)
FROM adidas
GROUP BY product;

#Find the total unit sold for each state.
SELECT state, sum(units_sold)
FROM adidas
GROUP BY state;

#Find the retailer with the hightest total sales
SELECT retailer, MAX(total_sales)
FROM adidas 
GROUP BY retailer
limit 1;

#Get the total operating Profit for each retailer
SELECT retailer, SUM(operating_profit) AS Total_Operating_Profit
FROM adidas 
GROUP BY retailer;

#Rank retailers by their total sales using RANK() or DENSE RANK()
SELECT retailer, SUM(total_sales),
RANK () OVER (ORDER BY SUM(total_sales) DESC) as Total_sale_Rank
FROM adidas 
GROUP BY retailer
Order by Total_sale_Rank;

#Find the top 5 cities with the highest sales
SELECT city, MAX(total_sales),
DENSE_RANK () OVER (ORDER BY MAX(total_sales) DESC) AS Highest_sales
FROM adidas 
Group by city
Order by Highest_sales
LIMIT 5;

#Find the Retailer that sold the most unit in New York
SELECT retailer, state, SUM(units_sold) AS Total_Unit_Sold
FROM adidas
WHERE state = "New York" 
GROUP BY retailer
ORDER BY Total_Unit_Sold DESC
LIMIT 1;

#Compare the sales performance of "Online" VS "OUTLET" sales methods.
SELECT sales_method, SUM(total_sales) as Total_sales, count(*) AS Total_transaction,AVG(total_sales) AS Average_sales_amount
FROM adidas 
WHERE sales_method IN ('Online','Outlet')
GROUP BY sales_method;

#Calculate a running total sales for each retailer
SELECT sales_id, retailer, invoice_date,total_sales,
SUM(total_sales) OVER (PARTITION BY retailer ORDER BY invoice_date) AS TotalRunningSales
FROM adidas;

#Find the percentage contribution of each retailer to the total sales. 
SELECT retailer, count(total_sales) * 100.0 / (SELECT count(total_sales) FROM adidas) AS PercentageContribution,
DENSE_RANK () OVER (ORDER BY count(total_sales) * 100.0 / (SELECT count(total_sales) FROM adidas) DESC) AS SalesRank
FROM adidas
GROUP BY retailer
ORDER BY PercentageContribution DESC;

#Find the highest and lowest priced product sold per retailer
CREATE TEMPORARY TABLE Temp_highest AS
select retailer,product, max(price_per_unit) as HighestPrice
from adidas
GROUP BY retailer, product
order by HighestPrice DESC;

CREATE TEMPORARY TABLE Temp_lowest AS
select retailer, product,min(price_per_unit) as LowestPrice
from adidas
GROUP BY retailer, product
order by LowestPrice ASC;

SELECT Temp_highest.retailer, Temp_highest.product, Temp_highest.HighestPrice,
		Temp_Lowest.LowestPrice
FROM Temp_highest
INNER JOIN Temp_Lowest ON Temp_highest.retailer = Temp_Lowest.retailer;
        




