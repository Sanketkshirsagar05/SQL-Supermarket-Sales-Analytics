CREATE DATABASE IF NOT EXISTS supermarket;
USE supermarket;

DROP TABLE IF EXISTS sales;
CREATE TABLE sales (
  InvoiceID VARCHAR(20),
  Branch CHAR(1),
  City VARCHAR(50),
  CustomerType VARCHAR(20),
  Gender VARCHAR(10),
  ProductLine VARCHAR(50),
  UnitPrice DECIMAL(10,2),
  Quantity INT,
  Tax DECIMAL(10,2),
  Total DECIMAL(10,2),
  Date Date,
  Time TIME,
  Payment VARCHAR(20),
  COGS DECIMAL(10,2),
  GrossMarginPct DECIMAL(5,2),
  GrossIncome DECIMAL(10,2),
  Rating DECIMAL(3,1)
);



#####################################################
# Done on Command Prompt

# mysql --local-infile=1 -u root -p --port=330

LOAD DATA LOCAL INFILE 'Path'
INTO TABLE sales
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(InvoiceID, Branch, City, CustomerType, Gender, ProductLine, UnitPrice, Quantity, Tax, Total, Date, Time, Payment, COGS, GrossMarginPct, GrossIncome, Rating);

#######################################################

Select * From sales;

#Total Revenue
SELECT ROUND(SUM(Total), 2) AS TotalRevenue FROM sales;

#Revenue by Customer Type
SELECT CustomerType, ROUND(SUM(Total), 2) AS Revenue
FROM sales
GROUP BY CustomerType
ORDER BY Revenue DESC;

#Average Sale per Invoice
SELECT ROUND(AVG(Total), 2) AS AvgInvoiceTotal FROM sales;

#Revenue by City
SELECT City, ROUND(SUM(Total), 2) AS Revenue
FROM sales
GROUP BY City
ORDER BY Revenue DESC;

#Revenue by Branch
SELECT Branch, ROUND(SUM(Total), 2) AS TotalSales
FROM sales
GROUP BY Branch
ORDER BY TotalSales DESC;

#Customer Distribution by Gender
SELECT Gender, COUNT(*) AS TotalCustomers
FROM sales
GROUP BY Gender;

#Most Sold Products (by Quantity)
SELECT ProductLine, SUM(Quantity) AS TotalSold
FROM sales
GROUP BY ProductLine
ORDER BY TotalSold DESC;

#Product Lines by Revenue
SELECT ProductLine, ROUND(SUM(Total), 2) AS Revenue
FROM sales
GROUP BY ProductLine
ORDER BY Revenue DESC;

#Sales by Day of the Week
SELECT DAYNAME(Date) AS DayOfWeek, ROUND(SUM(Total), 2) AS Revenue
FROM sales
GROUP BY DayOfWeek
ORDER BY FIELD(DayOfWeek, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');

#Sales by Hour
SELECT HOUR(Time) AS Hour, ROUND(SUM(Total), 2) AS Revenue
FROM sales
GROUP BY Hour
ORDER BY Hour;

#Payment Method Popularity
SELECT Payment, COUNT(*) AS Frequency
FROM sales
GROUP BY Payment
ORDER BY Frequency DESC;

#Average Gross Income per Product Line
SELECT ProductLine, ROUND(AVG(GrossIncome), 2) AS AvgGrossIncome
FROM sales
GROUP BY ProductLine
ORDER BY AvgGrossIncome DESC;

#Average Rating per Product Line
SELECT ProductLine, ROUND(AVG(Rating), 2) AS AvgRating
FROM sales
GROUP BY ProductLine
ORDER BY AvgRating DESC;

#Daily Revenue Trend
SELECT Date, ROUND(SUM(Total), 2) AS DailyRevenue
FROM sales
GROUP BY Date
ORDER BY Date;

#High-Value Transactions (> $100)
SELECT * FROM sales WHERE Total > 100 ORDER BY Total DESC;

#Gender-wise Avg Spending per Transaction
SELECT Gender, ROUND(AVG(Total), 2) AS AvgSpending
FROM sales
GROUP BY Gender;

#Most Common Product Line by Gender
SELECT Gender, ProductLine, COUNT(*) AS Count
FROM sales
GROUP BY Gender, ProductLine
ORDER BY Gender, Count DESC;

#Best-Selling Product by Branch
SELECT Branch, ProductLine, SUM(Quantity) AS TotalSold
FROM sales
GROUP BY Branch, ProductLine
ORDER BY Branch, TotalSold DESC;

#Monthly Sales Summary
SELECT DATE_FORMAT(Date, '%Y-%m') AS Month, ROUND(SUM(Total), 2) AS Revenue
FROM sales
GROUP BY Month
ORDER BY Month;

#Top 5 Invoices with Highest Total Amount
SELECT InvoiceID, ROUND(Total, 2) AS TotalAmount
FROM sales
ORDER BY Total DESC
LIMIT 5;

#Average Quantity per Transaction
SELECT ROUND(AVG(Quantity), 2) AS AvgQuantity FROM sales;


#Which day of the week has the highest average revenue per transaction
SELECT 
  DAYNAME(Date) AS Day,
  ROUND(AVG(Total), 2) AS AvgRevenuePerTransaction
FROM sales
GROUP BY Day
ORDER BY AvgRevenuePerTransaction DESC;

#What is the most preferred product line for female customers
SELECT ProductLine, COUNT(*) AS Frequency
FROM sales
WHERE Gender = 'Female'
GROUP BY ProductLine
ORDER BY Frequency DESC
LIMIT 1;

#Which branch sells the most on weekends
SELECT Branch, SUM(Total) AS WeekendRevenue
FROM sales
WHERE DAYNAME(Date) IN ('Saturday', 'Sunday')
GROUP BY Branch
ORDER BY WeekendRevenue DESC;

#Which city has the highest average gross income per sale
SELECT City, ROUND(AVG(GrossIncome), 2) AS AvgGrossIncome
FROM sales
GROUP BY City
ORDER BY AvgGrossIncome DESC;

#Which product line has the highest tax-to-sale ratio
SELECT ProductLine,
       ROUND(SUM(Tax) / SUM(Total), 4) AS TaxToSaleRatio
FROM sales
GROUP BY ProductLine
ORDER BY TaxToSaleRatio DESC;

#What is the least popular product line among members
SELECT ProductLine, COUNT(*) AS PurchaseCount
FROM sales
WHERE CustomerType = 'Member'
GROUP BY ProductLine
ORDER BY PurchaseCount ASC
LIMIT 1;

#Find the revenue generated during business hours (e.g., 9 AM to 5 PM) vs non-business hours.
SELECT 
  CASE 
    WHEN HOUR(Time) BETWEEN 9 AND 17 THEN 'Business Hours'
    ELSE 'Off Hours'
  END AS TimeCategory,
  ROUND(SUM(Total), 2) AS Revenue
FROM sales
GROUP BY TimeCategory;

#Find out which product line has the highest average rating per dollar spent.
SELECT ProductLine,
       ROUND(SUM(Rating) / SUM(Total), 4) AS RatingPerDollar
FROM sales
GROUP BY ProductLine
ORDER BY RatingPerDollar DESC;









