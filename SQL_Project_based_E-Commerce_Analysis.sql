use [E comm];

--- CREATING TABLES AS PER DESIRED SCHEMA ---
CREATE TABLE Suppliers(
SupplierID int PRIMARY KEY NOT NULL,
CompanyName	varchar(50) NOT NULL,
Address	varchar(50) NOT NULL,
City varchar(50) NOT NULL,
State varchar (30) NOT NULL,
PostalCode varchar(60) NOT NULL,
Country varchar(50) NOT NULL,
Phone varchar(15) NOT NULL,
Email varchar(25) NOT NULL);
--- CHECKING CREATED TABLE
SELECT * FROM Suppliers;

--- CREATING TABLES
CREATE TABLE Payments(
PaymentID int PRIMARY KEY,
PaymentType	varchar(50) NOT NULL,
Allowed	bit NOT NULL);
--- CHECKING CREATED TABLE
SELECT * FROM Payments;


--- CREATING TABLES
CREATE TABLE Shippers(
ShipperID int Primary Key,
CompanyName	varchar(50) NOT NULL,
Phone varchar(25) NOT NULL);
--- CHECKING CREATED TABLE
SELECT * FROM Shippers;

--- CREATING TABLES
CREATE TABLE Category(
CategoryID int PRIMARY KEY,
CategoryName varchar(50) NOT NULL,
Active varchar(3) NOT NULL);
--- CHECKING CREATED TABLE
SELECT * FROM Category;

--- CREATING TABLES
CREATE TABLE Customers(
CustomerID int Primary Key,
FirstName varchar(50) NOT NULL,
LastName varchar(50) NOT NULL,
City varchar(50) NOT NULL,
State varchar(30) NOT NULL,
Country	varchar(60) NOT NULL,
PostalCode varchar(50) NOT NULL,
Phone varchar(15) NOT NULL,
Email varchar(25) NOT NULL,
DateEntered varchar(15) NOT NULL);
--- CHECKING CREATED TABLE
SELECT * FROM Customers;

--- CREATING TABLES
CREATE TABLE Products(
ProductID int PRIMARY KEY,
Product varchar(100) NOT NULL,
CategoryID int NOT NULL,
Sub_Category varchar(50) NOT NULL,
Brand varchar(50) NOT NULL,
Sale_Price float NOT NULL,
Market_Price float NOT NULL,
Type varchar(50) NOT NULL,
Rating varchar(25) NOT NULL
CONSTRAINT For_key3 Foreign Key (CategoryID) REFERENCES Category(CategoryID));
--- CHECKING CREATED TABLE
SELECT * FROM Products;

--- CREATING TABLES
CREATE TABLE Orders(
OrderID int PRIMARY KEY,
CustomerID int Foreign Key (CustomerID) REFERENCES Customers(CustomerID),
PaymentID int Foreign Key (PaymentID) REFERENCES Payments(PaymentID),
OrderDate datetime NOT NULL,
ShipperID int Foreign Key (ShipperID) REFERENCES Shippers(ShipperID),
ShipDate datetime NOT NULL,
DeliveryDate datetime NOT NULL,
Total_order_amount Float NOT NULL);
--- CHECKING CREATED TABLE
SELECT * FROM Orders;

--- CREATING TABLES
CREATE TABLE OrderDetails(
OrderDetailID int PRIMARY KEY,
OrderID	int Foreign Key (OrderID) REFERENCES Orders(OrderID),
ProductID int Foreign Key (ProductID) REFERENCES Products(ProductID),
Quantity int NOT NULL,
SupplierID int Foreign Key (SupplierID) REFERENCES Suppliers(SupplierID));
--- CHECKING CREATED TABLE
SELECT * FROM OrderDetails;

--- Basic KPIs ---

--- Realated to ORDERS ---

--- Minimum Order Value-----
SELECT ROUND(MIN(Total_order_amount),2) FROM Orders;

--- Maximum Order Value
SELECT ROUND(MAX(Total_order_amount),2) FROM Orders;

--- Total Revenue Generated
SELECT ROUND(SUM(Total_order_amount),2) FROM Orders;

--- Average Order Value--------
SELECT ROUND(AVG(Total_order_amount),2) FROM Orders;

--- Orders are from DATES as follows-------
SELECT MIN(OrderDate), MAX(OrderDate) FROM Orders;

--- Count of Customers who Ordered------
SELECT COUNT(DISTINCT(CustomerID)) FROM Orders;

--- Payment method used for Orders are as follows:
SELECT DISTINCT(A.PaymentID), B.PaymentType FROM Orders A
INNER JOIN Payments B ON A.PaymentID = B.PaymentID
WHERE B.Allowed = 1;

--- Returning Customers
SELECT A.CustomerID, B.FirstName, B.LastName, B.Country, COUNT(A.CustomerID) AS Nos_Orders
FROM Orders A INNER JOIN Customers B ON A.CustomerID = B.CustomerID 
GROUP BY A.CustomerID, B.FirstName, B.LastName, B.Country
HAVING COUNT(A.CustomerID) > 1;

--- Non-Returning Customers--
SELECT A.CustomerID, B.FirstName, B.LastName, B.Country, COUNT(A.CustomerID) AS Nos_Orders
FROM Orders A INNER JOIN Customers B ON A.CustomerID = B.CustomerID 
GROUP BY A.CustomerID, B.FirstName, B.LastName, B.Country
HAVING COUNT(A.CustomerID) = 1;

--- Shippers Associated with the orders
SELECT DISTINCT(A.ShipperID ), B.CompanyName, B.Phone
FROM Orders A INNER JOIN Shippers B ON A.ShipperID = B.ShipperID

--- Shipper with along the numbers of Orders they have shipped
SELECT A.ShipperID, B.CompanyName, COUNT(A.OrderID) AS Nos_Orders_Shipped
FROM Orders A INNER JOIN Shippers B ON A.ShipperID = B.ShipperID
GROUP BY A.ShipperID, B.CompanyName
ORDER BY Nos_Orders_Shipped DESC;

--- Day on which we have received most numbers of orders
SELECT OrderDate, COUNT(OrderID) AS Nos_Orders_Received FROM Orders
GROUP BY OrderDate
ORDER BY Nos_Orders_Received DESC;

--- Day on which we have delivered maximum numbers of orders
SELECT DeliveryDate, COUNT(OrderID) AS Nos_Orders_Received FROM Orders
GROUP BY DeliveryDate
ORDER BY Nos_Orders_Received DESC;

--- Day on which we have shipped maximum numbers of orders
SELECT ShipDate, COUNT(OrderID) AS Nos_Orders_Received FROM Orders
GROUP BY ShipDate
ORDER BY Nos_Orders_Received DESC;

--- Day on which we have generated maximum revenue
SELECT TOP 1 OrderDate, COUNT(OrderID) AS Nos_Orders_Received, ROUND(SUM(Total_order_amount), 2) AS Revenue
FROM Orders
GROUP BY OrderDate
ORDER BY Revenue DESC;

--- Day on which we have generated minimum revenue
SELECT TOP 1 OrderDate, COUNT(OrderID) AS Nos_Orders_Received, ROUND(SUM(Total_order_amount), 2) AS Revenue
FROM Orders
GROUP BY OrderDate
ORDER BY Revenue;

--- RELATED TO CUSTOMERS ---

--- Total numbers of customers connnected with us
SELECT COUNT(DISTINCT(CustomerID)) AS Total_Customers FROM Customers;

--- Customer base by country
SELECT Country,COUNT(CustomerID) AS Total_Customers
FROM Customers GROUP BY Country
ORDER BY Total_Customers DESC;

--- Number of cutomers eneterd by date
SELECT DateEntered, COUNT(CustomerID) AS Cust_Connected
FROM Customers
GROUP BY DateEntered ORDER BY Cust_Connected DESC;

--- Number of cutomers by postalcode where number of customers is more than 5
SELECT PostalCode, COUNT(CustomerID) AS Nos_Cust
FROM Customers
GROUP BY PostalCode HAVING COUNT(CustomerID) > 5
ORDER BY Nos_Cust DESC;

--- REALTED TO PRODUCTS ---

--- Number of products under each category
SELECT Category_ID, COUNT(ProductID) AS Nos_Products
FROM Products GROUP BY Category_ID
ORDER BY Nos_Products DESC;

--- PRODUCT WITH MORE THAN 3 RATING
SELECT ProductID, Product, Rating FROM Productss
WHERE Rating IS NOT NULL AND Rating > 3
ORDER BY Rating DESC;

--- NUMBER OF PRODUCTS WITH LESS THAN 2.1 RATING
SELECT Rating, COUNT(*) AS Nos_Low_Ratng FROM Productss
WHERE Rating IS NOT NULL AND Rating < 2.1
GROUP BY Rating;

--- NUMBER OF PRODUCTS WITH NO RATING
SELECT COUNT(*) AS NOT_RATED FROM Products
WHERE Rating IS NULL
GROUP BY Rating;

--- BUSINESS REALATED KPIs

--- Identifying the distinct orders for which the PaymentID is “2”
SELECT DISTINCT(OrderID),* FROM Orders WHERE PaymentID = 2;

--- Identifying the total numbers of orders placed for each PaymentID for order placed between “5/02/2020 and 30/04/2020”
SELECT COUNT(OrderID) AS tOTAL_Order, PaymentID FROM Orders WHERE OrderDate BETWEEN '2020-02-05' AND
'2020-04-30' GROUP BY PaymentID ORDER BY PaymentID ASC;

--- Identifying all the categories which are currently active
SELECT CategoryName,* FROM Category WHERE Active = 1;

--- Identifying the different Payment methods which the company is accepting.
SELECT PaymentType FROM Payments WHERE Allowed = 1;

---- Identifying the customers who belong to Wisconsin and NewYork
SELECT * FROM Customers WHERE City = 'Wisconsin' OR City = 'New York';

--- Identifying the distinct State and City combinations where the customers belong to.
SELECT DISTINCT CustomerID, CITY, STATE FROM Customers;

--- Identifying all the customers whose length of the first name is 6 and the last name begins with “A”.

SELECT * FROM Customers WHERE FirstName LIKE '______' AND LastName LIKE 'A%';

--- Identifying all the Products for the brand “Cadbury”
SELECT DISTINCT(Product) FROM Products WHERE Brand = 'CADBURY';

--- Identifying all the products whose name contains “a” after 3rd place.
SELECT DISTINCT(Product) FROM Products WHERE Product LIKE '__a%';


--- Identifying the count of customers connected with the company each year
SELECT YEAR (orderdate) AS Year,
COUNT(DISTINCT CustomerID) AS Total_Customer from orders
group by YEAR (orderdate);

--- Identifying the count of customers in each State
SELECT State,
COUNT(CustomerID), COUNT(DISTINCT(CustomerID)) AS Total_Customer
FROM Customers
GROUP BY State;

/* Segment the customers into “New” and “Old” categories. Tag the customer as “New” if his database stored date 
is greater than “1st July 2020” else tag the customer as “Old”. Also, find the count of customers in both
the categories. */
SELECT CASE
WHEN DateEntered > '2020-07-01' THEN 'NEW'
ELSE 'OLD'
END AS TAG_NEW_OLD,
COUNT(CUSTOMERID) AS Total_Customer FROM Customers
GROUP BY CASE
WHEN DateEntered > '2020-07-01' THEN 'NEW'
ELSE 'OLD' END;
--- OR
WITH CTE1 AS(
SELECT *, CASE
WHEN DateEntered > '2020-07-01' THEN 'NEW'
ELSE 'OLD'
END AS TAG
FROM Customers)
SELECT TAG,COUNT(*) FROM CTE1 GROUP BY TAG;

--- Identifying the count of distinct products that the company sells within each category
SELECT Category_ID, COUNT(ProductID) AS TOTAL_PRODUCTS
FROM Products
GROUP BY Category_ID
ORDER BY Category_ID;

--- Identifying the number of orders in each month of the year “2021”
SELECT MONTH (OrderDate) AS MONTH, COUNT(OrderID) AS TOTAL_ORDERS
FROM Orders WHERE YEAR(OrderDate) ='2021'
GROUP BY MONTH (OrderDate)
ORDER BY MONTH (OrderDate);

--- Identifying the average order amount by each CustomerID in each month of Year “2020”
SELECT DISTINCT(CustomerID), MONTH(OrderDate) AS MONTH, 
AVG(Total_order_amount) AS Avg_Order_Amount FROM Orders 
WHERE YEAR(OrderDate) = '2020'
GROUP BY CustomerID, MONTH(OrderDate)
ORDER BY CustomerID;

--- Identifying the Month-Year combinations which had the highest customer acquisition
SELECT TOP 1 MONTH(DateEntered) AS MONTH, YEAR(DateEntered) AS YEAR, 
COUNT (*) AS TOTAL_CUSTOMERS FROM Customers
GROUP BY MONTH(DateEntered), YEAR(DateEntered)
ORDER BY TOTAL_CUSTOMERS DESC;

--- Identifying the most selling ProductID in 2021
SELECT TOP 1 ProductID, SUM(Quantity) AS TOTAL_QUANTITY
FROM OrderDetails 
GROUP BY ProductID
ORDER BY TOTAL_QUANTITY DESC;

--- Identifying which Supplier ID supplied the least number of products
SELECT TOP 1 SupplierID, COUNT(DISTINCT(ProductID)) AS TOTAL_PRODUCTS
FROM OrderDetails
GROUP BY SupplierID
ORDER BY TOTAL_PRODUCTS;

--- Identifying the OrderIDs which were delivered exactly after 15 days.
SELECT OrderID, DATEDIFF(DAY,OrderDate, DeliveryDate) AS Total_Days
FROM Orders GROUP BY OrderID, DATEDIFF(DAY,ORDERDATE, DeliveryDate)
HAVING DATEDIFF(DAY,OrderDate, DeliveryDate) = 15;

/* The company is tying up with a Bank for providing offers to a certain set of premium customers only. 
We want to know those CustomerIDs who have ordered for a total amount of more than 7000 in the past 3 months. */
SELECT CustomerID, SUM(Total_order_amount) AS Total_AMOUNT
FROM ORDERS WHERE CUSTOMERID IN
(SELECT CustomerID
FROM Orders GROUP BY CustomerID HAVING SUM(Total_order_amount) >7000)
AND DATEDIFF(MONTH,OrderDate,GETDATE()) <= 3
GROUP BY CustomerID
ORDER BY CustomerID;

--- Identify if there are any ShipperIDs that got associated with us in 2021 only.
WITH CTE1 AS(
SELECT DISTINCT(ShipperID) FROM Orders where datepart(year,ShipDate)=2020),
CTE2 AS(
SELECT DISTINCT(ShipperID) FROM Shippers),
CTE3 AS(
SELECT CTE2.ShipperID, Shippers.CompanyName FROM CTE2 INNER JOIN Shippers ON CTE2.ShipperID = Shippers.ShipperID)
SELECT * FROM CTE3 WHERE ShipperID NOT IN (SELECT * FROM CTE1);

/* The leadership wants to know the customer base who have ordered only once in the past 6 months such that 
they can be provided with certain offers to prevent customer churn. Also, find the number of purchases in 
each category for these customers.*/
SELECT * FROM Customers WHERE CustomerID IN 
(SELECT CustomerID FROM Orders WHERE DATEDIFF(MONTH,OrderDate,GETDATE()) <= 6 
GROUP BY CustomerID HAVING COUNT(CustomerID) = 1);

--- PART B
SELECT C.CustomerID, C.FirstName,C.LastName, C.City, C.State, C.Country,
ROUND(SUM(O.total_order_amount),2) AS Total_Amount_Spend, COUNT(O.OrderID) AS Nos_Orders
FROM Customers C INNER JOIN Orders as O 
ON C.customerid = O.customerid and O.orderdate >= DATEADD(MONTH,-6,GETDATE())
GROUP BY C.CustomerID, C.FirstName,C.LastName, C.City, C.State, C.Country
HAVING COUNT(O.OrderID) = 1;

/* The company is tying up with a Bank for providing offers to a certain set of premium customers only. 
We want to know those customers who have ordered for a total amount of more than 7000 in the past 3 months.
*/
SELECT O.CustomerID, C.FirstName, C.LastName, SUM(O.Total_order_amount) AS Total_order_amount
FROM Orders O INNER JOIN Customers C  ON O.CustomerID = C.CustomerID
WHERE DATEDIFF(MONTH,OrderDate,GETDATE()) <= 3
GROUP BY O.CustomerID, C.FirstName, C.LastName
HAVING SUM(O.Total_order_amount) > 7000;

--- The leadership wants to know which is their top-selling category and least-selling category in 2021
--- TOP-SELLING CATEGORY
SELECT TOP 1 C.CategoryName, SUM(QUANTITY) AS MOST_SOLD FROM Orders O
LEFT JOIN OrderDetails A ON O.OrderID = A.OrderID
LEFT JOIN Products B ON A.ProductID = B.ProductID
LEFT JOIN Category C ON B.Category_ID = C.CategoryID
WHERE C.Active = 1 AND YEAR(O.OrderDate) = 2021
GROUP BY C.CategoryName, C.CategoryID
ORDER BY MOST_SOLD DESC;

--- LEAST-SELLING CATEGORY
SELECT TOP 1 C.CategoryName, SUM(QUANTITY) AS MOST_SOLD FROM Orders O
LEFT JOIN OrderDetails A ON O.OrderID = A.OrderID
LEFT JOIN Products B ON A.ProductID = B.ProductID
LEFT JOIN Category C ON B.Category_ID = C.CategoryID
WHERE C.Active = 1 AND YEAR(O.OrderDate) = 2021
GROUP BY C.CategoryName, C.CategoryID
ORDER BY MOST_SOLD;

--- We need to flag the Shipper companies whose average delivery time is less than 3 days to incentivize them
SELECT SHIPPERID, CASE
WHEN AVG(DATEDIFF(DAY,ORDERDATE,DELIVERYDATE)) < 3 THEN '1'
ELSE '0' END AS TAG
FROM Orders
GROUP BY ShipperID;

--- Find out the Average delivery time for each category by each shipper
SELECT D.CategoryName, S.CompanyName ,AVG(DATEDIFF(DAY,ORDERDATE,DELIVERYDATE)) AS AVG_DELIVERY_TIME 
FROM Orders A
LEFT JOIN OrderDetails B ON A.OrderID = B.OrderID
LEFT JOIN Shippers S ON A.ShipperID = S.ShipperID
LEFT JOIN Products C ON B.ProductID = C.ProductID
LEFT JOIN Category D ON C.Category_ID = D.CategoryID
GROUP BY D.CategoryName, S.CompanyName
ORDER BY D.CategoryName, S.CompanyName;

/* We need to see the most used Payment method by customers such that we can tie-up with those Banks 
in order to attract more customers to our website. */
SELECT TOP 1 B.PaymentType, COUNT(*) AS TIMES_USED FROM Orders A 
LEFT JOIN Payments B ON A.PaymentID = B.PaymentID
GROUP BY B.PaymentType 
ORDER BY TIMES_USED DESC;


/* Write a query to show the number of customers, number of orders placed, and total order amount per month 
in the year 2021. Assume that we are only interested in the monthly reports for a single year (January-December). */
SELECT MONTH(ORDERDATE) AS MONTH_, COUNT(DISTINCT(CUSTOMERID)) AS TOTAL_CUSTOMERS, 
COUNT(*) AS TOTAL_ORDERS, ROUND(SUM(Total_order_amount),2) AS REVENUE 
FROM Orders WHERE YEAR(OrderDate) = 2021
GROUP BY MONTH(OrderDate)
ORDER BY MONTH_;

--- Find the numbers of orders fulfilled by Suppliers residing in the same Country as the customer.
SELECT COUNT(DISTINCT(A.OrderID)) AS Nos_Orders, 
('Orders Fulfilled by Suppliers residing in the same Country as the customer') AS REMARKS FROM Orders A
LEFT JOIN OrderDetails B ON A.OrderID = B.OrderID
LEFT JOIN Customers C ON A.CustomerID = C.CustomerID
LEFT JOIN Suppliers D ON B.SupplierID = D.SupplierID
WHERE C.Country = D.Country;


--- Find the cumulative sum of total order amount for the year 2021
WITH CTE1 AS(
SELECT OrderID, ROUND(Total_order_amount,2) AS Total_order_amount,
SUM(Total_order_amount) OVER(ORDER BY ORDERID) AS CUMMULATIVE_ORDER_AMOUNT
FROM Orders WHERE YEAR(OrderDate) = 2021)
SELECT OrderID, Total_order_amount, ROUND(CUMMULATIVE_ORDER_AMOUNT,2) FROM CTE1;


--- Find the cumulative sum of total orders placed for the year 2020
WITH CTE1 AS(
SELECT OrderID, ROUND(Total_order_amount,2) AS Total_order_amount,
SUM(Total_order_amount) OVER(ORDER BY ORDERID) AS CUMMULATIVE_ORDER_AMOUNT
FROM Orders WHERE YEAR(OrderDate) = 2020)
SELECT OrderID, Total_order_amount, ROUND(CUMMULATIVE_ORDER_AMOUNT,2) FROM CTE1;


--- MOST SOLD PRODUCT
SELECT TOP 1 C.Product, B.ProductID, SUM(B.Quantity) AS TOTAL FROM Orders A
LEFT JOIN OrderDetails B ON A.OrderID = B.OrderID
LEFT JOIN Products C ON B.ProductID = C.ProductID
GROUP BY C.Product, B.ProductID
ORDER BY TOTAL DESC;


/* Create a YOY analysis for the count of customers enrolled with the company each month.
Columns should be month year_n, year_m */
SELECT * FROM (
SELECT MONTH(DateEntered) AS MONTHS , YEAR(DateEntered) AS YEAR_,
COUNT(DISTINCT(CUSTOMERID)) AS TOTAL_CUST FROM Customers
GROUP BY MONTH(DateEntered), YEAR(DateEntered)) C
PIVOT( SUM(TOTAL_CUST) FOR YEAR_ IN ([2020],[2021])) AS T1;


---A. Create a YOY analysis for the count of customers enrolled with the company each month. The output should look like:
select Months, sum([2020]) AS Year_2020,sum([2021]) as Year_2021
from 
(Select month(DateEntered) As Months , [2020] , [2021] 
from (Select * , Year(DateEntered) As year_  From Customers) dat
Pivot 
(Count(year_) for year_ in ([2020], [2021]) ) As pivt) fnl
group by fnl.Months;
----Using_Case
Select  month(DateEntered) As Months , 
Sum(Case When Year(DateEntered) = 2020 then 1
else 0 
end ) As Year_2020,
Sum(Case When Year(DateEntered) = 2021 then 1
else 0 
end ) As Year_2021
From Customers
group by month(DateEntered)

--B. Find out the top 3 best-selling products in each of the categories that are currently active on the Website
---IF we Consider number of times purchased than
Select * from
(select cat.CategoryID, pro.ProductID,  Sum(ordt.Quantity) As Qnty, 
Dense_Rank () Over(Partition by CategoryID Order by Sum(ordt.Quantity) Desc) As D_Rank
from Category As cat
inner join Products As pro 
on cat.CategoryID = pro.Category_ID
inner join OrderDetails As ordt 
on pro.ProductID = ordt.ProductID 
where cat.Active = 1
group by pro.ProductID, cat.CategoryID) new
where D_Rank between 1 and 3

--------C. Find the out the least selling products in each of the categories that are currently active on the website
Select * from
(select cat.CategoryID, pro.ProductID,Sum(ordt.Quantity) As Qnty, 
Dense_Rank () Over(Partition by CategoryID Order by Sum(ordt.Quantity)) As D_Rank
from Category As cat
inner join Products As pro 
on cat.CategoryID = pro.Category_ID
inner join OrderDetails As ordt 
on pro.ProductID = ordt.ProductID 
where cat.Active = 1
group by pro.ProductID, cat.CategoryID) new
where D_Rank = 1

------D. We are trying to find paired products that are often purchased together by the same user,
------such as chips and soft drinks, milk and curd etc.. 
------Find the top paired products names.
create view prd_ord5
As
(select ordtl.OrderDetailID, ordtl.OrderID, ordtl.ProductID,
prdt1.Product,prdt1.Category_ID,ords.CustomerID 
from OrderDetails As ordtl
inner join Products As prdt1 on ordtl.ProductID = prdt1.ProductID 
inner join Orders As ords on Ords.OrderID = ordtl.OrderID);

create view prd_ord6
As
(select ordtl2.OrderDetailID, ordtl2.OrderID, ordtl2.ProductID , prdt2.Product, prdt2.Category_ID , ords2.CustomerID 
from OrderDetails As ordtl2
inner join Products As prdt2 on ordtl2.ProductID = prdt2.ProductID
inner join Orders As ords2 on Ords2.OrderID = ordtl2.OrderID);

Select prd_ord5.ProductID , prd_ord6.CustomerID,prd_ord5.Product,prd_ord6.ProductID,prd_ord6.Product,
count(prd_ord5.ProductID) As number_of_times 
from prd_ord5 
inner join prd_ord6 
on prd_ord5.OrderID = prd_ord6.OrderID 
and prd_ord5.ProductID > prd_ord6.ProductID 
and prd_ord5.CustomerID = prd_ord6.CustomerID
group by prd_ord5.ProductID ,prd_ord6.ProductID ,
prd_ord5.Product,prd_ord6.Product,prd_ord6.CustomerID
Order by number_of_times Desc

---E. We want to understand the impact of running a campaign during July’21-Oct’21 
---what was the total sales generated for the categories“Beauty & Hygiene” and “Bevarages” by
--a. entire customer base
Alter Table orderdetails Alter column Quantity int;
Alter table products Alter column sale_price int;

Select SUM(OrderDetails.Quantity* Products.Sale_Price) As rev from Orders
inner Join Customers on Customers.CustomerID = Orders.CustomerID
inner Join OrderDetails on OrderDetails.OrderID = Orders.OrderID
inner join Products on Products.ProductID = OrderDetails.ProductID
inner Join Category on Category.CategoryID = Products.Category_ID
where (year(orderDate) = 2021) and (month(orderDate)  between 7 and 10 )
and (Category.CategoryName = 'Beauty & Hygiene' or Category.CategoryName = 'Beverages');

---b. customers who enrolled with the company during the same period
Select Sum(products.Sale_Price * orderdetails.Quantity) 
as total_sale_from_Beauty_Hygiene_Bevarages_from_new_cust 
from Orders
inner Join Customers on Customers.CustomerID = Orders.CustomerID
inner Join OrderDetails on OrderDetails.OrderID = Orders.OrderID
inner join Products on Products.ProductID = OrderDetails.ProductID
inner Join Category on Category.CategoryID = Products.Category_ID
where year(orderDate) = 2021 and month(orderDate)  between 7 and 10
and (Category.CategoryName = 'Beauty & Hygiene' or Category.CategoryName = 'Beverages' )
and (year(customers.DateEntered) = 2021 and month(customers.DateEntered) between 7 and 10);

--F. Create a Quarter-wise ranking in terms of revenue generated in each category in Year 2020
Create View qf2 As
(Select Category.CategoryID, orders.Total_order_amount, 
Case 
When month(orderDate) between 1 and 3 then 'Q1'
when month(orderDate) between 4 and 6 then 'Q2'
when month(orderDate) between 7 and 9 then 'Q3'
When month(orderDate) between 9 and 12 then 'Q4'
end
As Qtr
from Orders
inner Join Customers on Customers.CustomerID = Orders.CustomerID
inner Join OrderDetails on OrderDetails.OrderID = Orders.OrderID
inner join Products on Products.ProductID = OrderDetails.ProductID
inner Join Category on Category.CategoryID = Products.Category_ID
where year(orderDate) = 2020)

Select *, Dense_RANK() OVER(Partition by Qtr order by TOTAL_amount Desc) from
(Select CategoryID,Qtr ,SUM(Total_order_amount) As TOTAL_amount from qf2
group by CategoryID,Qtr)C


--F. Create a Quarter-wise ranking in terms of revenue generated in each category in Year 2020

Select * , Rank() over(Partition by CategoryName order by Revenue) As Rank_ from (
Select DATEPART(q, OrderDate) As Qtr, CategoryName, Sum(products.Sale_Price * Quantity) 
As revenue from Orders
inner Join Customers on Customers.CustomerID = Orders.CustomerID
inner Join OrderDetails on OrderDetails.OrderID = Orders.OrderID
inner join Products on Products.ProductID = OrderDetails.ProductID
inner Join Category on Category.CategoryID = Products.Category_ID
where year(Orders.OrderDate) = 2020
Group by DATEPART(q, OrderDate), CategoryName)c
Order By Qtr;

------method 2
Select * , Rank() over(Partition by CategoryName order by Revenue) As Rank_ from (
Select DATEPART(q, OrderDate) As Qtr, CategoryName, Sum(products.Sale_Price * Quantity) As revenue from Orders
inner Join Customers on Customers.CustomerID = Orders.CustomerID
inner Join OrderDetails on OrderDetails.OrderID = Orders.OrderID
inner join Products on Products.ProductID = OrderDetails.ProductID
inner Join Category on Category.CategoryID = Products.Category_ID
where year(Orders.OrderDate) = 2020
Group by DATEPART(q, OrderDate), CategoryName)c
Order By Qtr;

---G. Find the top 3 Shipper companies in terms o
--a. Average delivery time for each category for the latest year
Select * from 
(Select * , ROw_number() over( Partition by Category_ID order by Avg_delvry_time ) Rank_Dns 
from (Select Products.Category_ID,ShipperID,
Avg(datediff(day, OrderDate, DeliveryDate)) As Avg_delvry_time 
from OrderDetails 
inner join Orders on OrderDetails.OrderID=orders.OrderID
inner join Products on Products.ProductID = OrderDetails.ProductID
where year(OrderDate) in (Select Year (MAx(OrderDate) )from orders) 
Group by ShipperID, Products.Category_ID)C)D
where Rank_Dns between 1 and 3;

---b. Volume for latest year
Select TOP 3 Shippers.ShipperID, CompanyName, Sum(Quantity) As total_volume from OrderDetails 
inner join Orders on OrderDetails.OrderID=orders.OrderID
inner join Products on Products.ProductID = OrderDetails.ProductID
inner join Shippers on Shippers.shipperID = orders.shipperID
where year(OrderDate) in (Select Year (MAx(OrderDate) )from orders) 
Group by Shippers.ShipperID, CompanyName
order by total_volume desc

---Short cut MEthod 2
SELECT * FROM 
(SELECT P.Category_ID,O.ShipperID,
AVG(DATEDIFF(DAY,O.OrderDate,O.DeliveryDate)) AS 'Delivery Period',
ROW_NUMBER() OVER(PARTITION BY P.Category_ID 
ORDER BY AVG(DATEDIFF(DAY,O.OrderDate,O.DeliveryDate))) AS 'Rank'
FROM Products AS P 
JOIN OrderDetails AS OD ON P.ProductID=OD.ProductID
JOIN Orders AS O ON OD.OrderID=O.OrderID
WHERE YEAR(O.OrderDate)=2021
GROUP BY P.Category_ID,O.ShipperID
)DT
WHERE DT.Rank<=3;

---H. Find the top 25 customers in terms of
--a. Total no. of orders placed for Year 2021
Select TOP 25 Orders.CustomerID,Customers.FirstName, Customers.LastName,
Count(orders.OrderID) As num_of_order from orders
inner join Customers on Customers.CustomerID = Orders.CustomerID
where year(OrderDate) = 2021
Group by Orders.CustomerID, Customers.FirstName, Customers.LastName
order by num_of_order Desc;

---Method 2
Select * from(
Select CustomerID,FirstName, LastName, No_order , rank() over (order by No_order DESC) As Rank_cust 
from (Select Customers.CustomerID , Customers.FirstName, Customers.LastName, Count(orders.OrderID) 
over (partition by Customers.CustomerID) No_order from orders
inner join Customers on Customers.CustomerID = Orders.CustomerID
where year(OrderDate) = 2021)C
Group by CustomerID, FirstName,LastName, No_order) d where d.Rank_cust <= 25;

---H. Find the top 25 customers in terms of
--b. Total Purchase Amount for the Year 2021
Select * from(
Select CustomerID,FirstName, LastName, Total_amount , rank() over (order by Total_amount DESC) As Rank_cust_amount from
(Select Customers.CustomerID , Customers.FirstName, Customers.LastName, Sum(orders.Total_order_amount) 
over (partition by Customers.CustomerID) Total_amount from orders
inner join Customers on Customers.CustomerID = Orders.CustomerID
where year(OrderDate) = 2021)C
Group by CustomerID, FirstName,LastName, Total_amount) D where D.Rank_cust_amount <= 25;

-----Method 2
Select TOP 25 Orders.CustomerID,Customers.FirstName, Customers.LastName,
Sum(orders.Total_order_amount) As num_of_order from orders
inner join Customers on Customers.CustomerID = Orders.CustomerID
where year(OrderDate) = 2021
Group by Orders.CustomerID, Customers.FirstName, Customers.LastName
order by num_of_order Desc;

--I. Find out the difference between the last two order dates for each of the
---customers and categorize the customers in two categories such that if the
---difference is less than 5 days tag the customer as “Frequent Buyer” else tag
---it as “Infrequent”.
Create View I_View
As	
(Select * from 
(Select CustomerID, OrderID, OrderDate, Rank_ 
from (select *, Dense_rank() OVER (partition by CustomerId Order by OrderDate Desc) As rank_ from Orders) c
group by CustomerID, OrderID, OrderDate,rank_) c 
where rank_ = 1 or rank_ = 2)

Select CustomerID, Case
When Datediff( day, Min(OrderDate) , Max(OrderDate)) < 5 then 'Frequent'
Else 'Infrequent'
End
 As  Tag_
from I_View
group by CustomerID

---J. Find the cumulative average order amount at a monthly level for year 2021
---a. Each category
Select *, Avg(monthly_total) Over (Partition by Category_ID order by months)As Cum_avg from 
(Select C.Category_ID, Month(OrderDate) As months, SUM(Sale_Price* Quantity) As monthly_total 
from Orders As A
inner Join OrderDetails As B
on A.OrderID = B.OrderID
inner join Products As C on C.ProductID = B.ProductID
where Year(OrderDate) = 2021
Group by C.Category_ID, Month(OrderDate))c

----b. Each customer
Select *, Avg(monthly_total) Over (Partition by CustomerID order by months)As Cum_avg from 
(Select A.CustomerID, Month(OrderDate) As months, SUM(Total_order_amount) As monthly_total from Orders As A
inner Join OrderDetails As B
on A.OrderID = B.OrderID
inner join Products As C on C.ProductID = B.ProductID
where Year(OrderDate) = 2021
Group by A.CustomerID, Month(OrderDate))c

---K. Find the 3-day rolling average for the total purchase amount by each customer.
Select * , AVG(Total_Order_amount) 
Over ( Partition by CustomerId Order by orderdate Rows 2 PRECEDING  ) As three_day_rolling 
from Orders
