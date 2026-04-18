
-- SUPERSTORE SALES ANALYSIS
-- Author: Muskan Prajapati

 
CREATE DATABASE IF NOT EXISTS superstore_db; #Database setup
USE superstore_db;

CREATE TABLE orders (                       # table created 
    Row_ID INT,
    Order_ID VARCHAR(20),
    Order_Date VARCHAR(20),
    Ship_Date VARCHAR(20),
    Ship_Mode VARCHAR(30),
    Customer_ID VARCHAR(20),
    Customer_Name VARCHAR(50),
    Segment VARCHAR(20),
    Country VARCHAR(30),
    City VARCHAR(50),
    State VARCHAR(30),
    Postal_Code VARCHAR(10),
    Region VARCHAR(20),
    Product_ID VARCHAR(20),
    Category VARCHAR(30),
    Sub_Category VARCHAR(30),
    Product_Name VARCHAR(200),
    Sales DECIMAL(10,4),
    Quantity INT,
    Discount DECIMAL(4,2),
    Profit DECIMAL(10,4)
);
LOAD DATA LOCAL INFILE '/path/to/superstore_utf8.csv' #filed loaded
INTO TABLE orders
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SET SQL_SAFE_UPDATES = 0;

ALTER TABLE orders                                    
ADD COLUMN Order_Date_Clean DATE,
ADD COLUMN Ship_Date_Clean DATE;

UPDATE orders
SET Order_Date_Clean = STR_TO_DATE(Order_Date, '%m/%d/%Y'),
    Ship_Date_Clean  = STR_TO_DATE(Ship_Date,  '%m/%d/%Y');

SET SQL_SAFE_UPDATES = 1;

SELECT Order_Date, Order_Date_Clean, Sales, Profit     
FROM orders 
LIMIT 5;
													  #EXPLOARATION & ANALYSIS 
-- QUERY 1: Total Revenue, Profit and Orders (Overall KPIs)

SELECT 
    COUNT(DISTINCT Order_ID)AS Total_Orders,
    ROUND(SUM(Sales),2)AS Total_Revenue,
    ROUND(SUM(Profit),2)AS Total_Profit,
    ROUND(SUM(Profit)/SUM(Sales)*100, 2) AS Profit_Margin_Pct
FROM orders;
 

-- QUERY 2: Revenue and Profit by Category

SELECT 
    Category,
    ROUND(SUM(Sales), 2)AS Total_Sales,
    ROUND(SUM(Profit), 2)AS Total_Profit,
    ROUND(SUM(Profit)/SUM(Sales)*100, 2)AS Profit_Margin_Pct
FROM orders
GROUP BY Category
ORDER BY Total_Sales DESC;
 
 
-- QUERY 3: Top 10 Best-Selling Sub-Categories

SELECT 
    Sub_Category,
    ROUND(SUM(Sales),2) AS Total_Sales,
    ROUND(SUM(Profit),2) AS Total_Profit,
    SUM(Quantity)AS Units_Sold
FROM orders
GROUP BY Sub_Category
ORDER BY Total_Sales DESC
LIMIT 10;



-- QUERY 4: Monthly Revenue Trend (Year-wise)

SELECT 
    YEAR(Order_Date_Clean)  AS Year,
    MONTH(Order_Date_Clean) AS Month,
    MONTHNAME(Order_Date_Clean) AS Month_Name,
    ROUND(SUM(Sales), 2) AS Monthly_Revenue,
    ROUND(SUM(Profit), 2) AS Monthly_Profit
FROM orders
GROUP BY YEAR(Order_Date_Clean), MONTH(Order_Date_Clean), MONTHNAME(Order_Date_Clean)
ORDER BY Year, Month;
 
-- QUERY 5: Revenue and Profit by Region

SELECT 
    Region,
    COUNT(DISTINCT Order_ID)     AS Total_Orders,
    ROUND(SUM(Sales), 2)         AS Total_Revenue,
    ROUND(SUM(Profit), 2)        AS Total_Profit,
    ROUND(AVG(Sales), 2)         AS Avg_Order_Value
FROM orders
GROUP BY Region
ORDER BY Total_Revenue DESC;
 

-- QUERY 6: Top 10 Most Profitable Customers

SELECT 
    Customer_Name,
    Segment,
    Region,
    ROUND(SUM(Sales), 2)  AS Total_Spent,
    ROUND(SUM(Profit), 2) AS Total_Profit_Generated,
    COUNT(DISTINCT Order_ID) AS Number_of_Orders
FROM orders
GROUP BY Customer_Name, Segment, Region
ORDER BY Total_Profit_Generated DESC
LIMIT 10;
 
 

-- QUERY 7: Loss-Making Products (Where Discounts Hurt Profit)

SELECT 
    Product_Name,
    Category,
    Sub_Category,
    ROUND(SUM(Sales), 2)AS Total_Sales,
    ROUND(SUM(Profit), 2)AS Total_Profit,
    ROUND(AVG(Discount)*100, 1)AS Avg_Discount_Pct
FROM orders
GROUP BY Product_Name, Category, Sub_Category
HAVING Total_Profit < 0
ORDER BY Total_Profit ASC
LIMIT 10;
 
-- QUERY 8: Impact of Discount on Profit Margin


SELECT 
    CASE 
        WHEN Discount = 0 THEN '0% - No Discount'
        WHEN Discount <= 0.10 THEN '1-10% Discount'
        WHEN Discount <= 0.20 THEN '11-20% Discount'
        WHEN Discount <= 0.30 THEN '21-30% Discount'
        ELSE 'Above 30% Discount'
    END AS Discount_Band,
    COUNT(*) AS Number_of_Orders,
    ROUND(SUM(Sales), 2)AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(SUM(Profit)/SUM(Sales)*100, 2)AS Profit_Margin_Pct
FROM orders
GROUP BY Discount_Band
ORDER BY Profit_Margin_Pct DESC;
 
 
-- QUERY 9: Shipping Mode vs Delivery Speed vs Sales


SELECT 
    Ship_Mode,
    COUNT(DISTINCT Order_ID)AS Total_Orders,
    ROUND(SUM(Sales), 2)AS Total_Revenue,
    ROUND(AVG(DATEDIFF(Ship_Date_Clean, Order_Date_Clean)), 1) AS Avg_Days_to_Ship
FROM orders
GROUP BY Ship_Mode
ORDER BY Total_Orders DESC;
 

 
-- QUERY 10: Customer Segment Performance

SELECT 
    Segment,
    COUNT(DISTINCT Customer_ID) AS Total_Customers,
    COUNT(DISTINCT Order_ID)AS Total_Orders,
    ROUND(SUM(Sales), 2)AS Total_Revenue,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(AVG(Sales), 2)AS Avg_Order_Value
FROM orders
GROUP BY Segment
ORDER BY Total_Revenue DESC;
 
