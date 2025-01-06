-- Active: 1736183703121@@127.0.0.1@3306@bills

-- Customer Analysis Queries

-- 1. Top 5 customers with the highest total bill amount
SELECT b.CustomerID, c.customerName, 
       SUM(b.TotalAmount) AS TotalBillAmount 
FROM bills b
JOIN customer c ON b.CustomerID = c.customerID
GROUP BY b.CustomerID, c.customerName
ORDER BY TotalBillAmount DESC 
LIMIT 5;

-- 2. Average time taken to pay a bill for each customer
SELECT b.CustomerID, c.customerName, 
       AVG(DATEDIFF(p.PaymentDate, b.DueDate)) AS AvgPaymentDays 
FROM bills b
JOIN payments p ON b.BillID = p.BillID
JOIN customer c ON b.CustomerID = c.customerID
GROUP BY b.CustomerID, c.customerName;

-- 3. Customers who have never made a late payment
SELECT DISTINCT b.CustomerID, c.customerName
FROM bills b
JOIN customer c ON b.CustomerID = c.customerID
WHERE b.Status = 'Paid'
  AND NOT EXISTS (
    SELECT 1 
    FROM bills late 
    WHERE late.CustomerID = b.CustomerID 
      AND late.Status = 'Late'
  );

-- Bill Analysis Queries
-- Note: Assuming Bill_Items table exists with LineTotal column

-- 4. Total amount generated from bill items
SELECT SUM(LineTotal) AS TotalBillItemAmount 
FROM bill_items;

-- 5. Item with the highest LineTotal
SELECT BillItemID, ItemDescription, LineTotal AS HighestLineTotal 
FROM bill_items 
ORDER BY LineTotal DESC 
LIMIT 1;

-- 6. Item with the minimum LineTotal
SELECT BillItemID, ItemDescription, LineTotal AS MinimumLineTotal 
FROM bill_items 
ORDER BY LineTotal ASC 
LIMIT 1;

-- Payment Analysis Queries
-- Note: Assuming Payment table exists

-- 7. Most popular payment method
SELECT PaymentMethod, 
       COUNT(*) AS MethodCount 
FROM payments 
GROUP BY PaymentMethod 
ORDER BY MethodCount DESC 
LIMIT 1;

-- 8. Total revenue by payment method
SELECT PaymentMethod, 
       SUM(PaymentAmount) AS TotalRevenue 
FROM payments 
GROUP BY PaymentMethod;

-- 9. Average payment amount
SELECT AVG(PaymentAmount) AS AveragePaymentAmount 
FROM payments;

-- Data Analysis and Insights Queries

-- 10. Top 3 categories with highest total revenue
SELECT b.CategoryID, c.categoryName, 
       SUM(b.TotalAmount) AS CategoryRevenue 
FROM bills b
JOIN categories c ON b.CategoryID = c.categoryID
GROUP BY b.CategoryID, c.categoryName
ORDER BY CategoryRevenue DESC 
LIMIT 3;

-- 11. Customer with the highest number of unpaid bills
SELECT b.CustomerID, c.customerName, 
       COUNT(*) AS UnpaidBillCount 
FROM bills b
JOIN customer c ON b.CustomerID = c.customerID
WHERE b.Status = 'Unpaid' 
GROUP BY b.CustomerID, c.customerName
ORDER BY UnpaidBillCount DESC 
LIMIT 1;
