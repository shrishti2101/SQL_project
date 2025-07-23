use client;

-- What is the total revenue generated so far?

SELECT SUM(amount) AS total_revenue
FROM payments;

-- Which 5 customers have contributed the highest revenue?

SELECT customerNumber, SUM(amount) AS revenue
FROM payments
GROUP BY customerNumber
ORDER BY revenue DESC
LIMIT 5;


-- Which product has generated the highest sales value?

SELECT productCode, SUM(quantityOrdered * priceEach) AS total_sales
FROM orderdetails
GROUP BY productCode
ORDER BY total_sales DESC
LIMIT 1;

-- What is the average order value across all orders?

SELECT AVG(order_total) AS avg_order_value FROM (
  SELECT orderNumber, SUM(quantityOrdered * priceEach) AS order_total
  FROM orderdetails
  GROUP BY orderNumber
) AS order_totals;

-- How much revenue is coming from each product line?
SELECT p.productLine, SUM(od.quantityOrdered * od.priceEach) AS revenue
FROM products p
JOIN orderdetails od ON p.productCode = od.productCode
GROUP BY p.productLine
ORDER BY revenue DESC;

-- Which country has the most customers?
SELECT country, COUNT(*) AS total_customers
FROM customers
GROUP BY country
ORDER BY total_customers DESC
LIMIT 1;

-- What is the average number of orders per customer?
SELECT AVG(order_count) AS avg_orders_per_customer FROM (
  SELECT customerNumber, COUNT(*) AS order_count
  FROM orders
  GROUP BY customerNumber
) AS order_summary;

-- Which customers have not placed any orders yet?
SELECT * FROM customers
WHERE customerNumber NOT IN (SELECT DISTINCT customerNumber FROM orders);


-- Which customers have made the highest single payment?
SELECT customerNumber, amount
FROM payments
ORDER BY amount DESC
LIMIT 1;

-- Which product lines are the least profitable (low total sales)?
SELECT p.productLine, SUM(od.quantityOrdered * od.priceEach) AS total_sales
FROM products p
JOIN orderdetails od ON p.productCode = od.productCode
GROUP BY p.productLine
ORDER BY total_sales ASC
LIMIT 3;

-- How many employees are in each office?
SELECT officeCode, COUNT(*) AS total_employees
FROM employees
GROUP BY officeCode;

-- How many orders are still in 'In Process' status?
SELECT COUNT(*) AS in_process_orders
FROM orders
WHERE status = 'In Process';
 
-- What is the average delivery time (orderDate to shippedDate)?
SELECT AVG(DATEDIFF(shippedDate, orderDate)) AS avg_delivery_days
FROM orders
WHERE shippedDate IS NOT NULL;

-- Which order had the highest value?
SELECT orderNumber, SUM(quantityOrdered * priceEach) AS order_value
FROM orderdetails
GROUP BY orderNumber
ORDER BY order_value DESC
LIMIT 1;


-- Are there any duplicate payments (same customer, amount, and date)?
SELECT customerNumber, amount, paymentDate, COUNT(*) AS count
FROM payments
GROUP BY customerNumber, amount, paymentDate
HAVING COUNT(*) > 1;


-- Which customers are at risk (placed orders but never paid)?
SELECT DISTINCT o.customerNumber
FROM orders o
LEFT JOIN payments p ON o.customerNumber = p.customerNumber
WHERE p.customerNumber IS NULL;



