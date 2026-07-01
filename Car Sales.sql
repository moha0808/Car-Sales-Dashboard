-- ========================================
-- CAR SALES DATABASE - Complete Setup
-- ========================================

-- Create Database
CREATE DATABASE IF NOT EXISTS CarSalesDB;
USE CarSalesDB;

-- ========================================
-- TABLE 1: CARS (Master list of car models)
-- ========================================
CREATE TABLE Cars (
    CarID INT PRIMARY KEY AUTO_INCREMENT,
    CarModel VARCHAR(100) NOT NULL,
    Brand VARCHAR(50) NOT NULL,
    Year INT NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    Category VARCHAR(50) NOT NULL
);

-- ========================================
-- TABLE 2: DEALERS (Sales dealers)
-- ========================================
CREATE TABLE Dealers (
    DealerID INT PRIMARY KEY AUTO_INCREMENT,
    DealerName VARCHAR(100) NOT NULL,
    City VARCHAR(50) NOT NULL,
    State VARCHAR(50) NOT NULL,
    Phone VARCHAR(15)
);

-- ========================================
-- TABLE 3: SALES (Main sales transactions)
-- ========================================
CREATE TABLE Sales (
    SalesID INT PRIMARY KEY AUTO_INCREMENT,
    CarID INT NOT NULL,
    DealerID INT NOT NULL,
    SaleDate DATE NOT NULL,
    Quantity INT NOT NULL,
    TotalPrice DECIMAL(12, 2) NOT NULL,
    CustomerName VARCHAR(100) NOT NULL,
    FOREIGN KEY (CarID) REFERENCES Cars(CarID),
    FOREIGN KEY (DealerID) REFERENCES Dealers(DealerID)
);

-- ========================================
-- INSERT SAMPLE DATA - CARS
-- ========================================
INSERT INTO Cars (CarModel, Brand, Year, Price, Category) VALUES
('Civic', 'Honda', 2023, 25000, 'Sedan'),
('Accord', 'Honda', 2023, 32000, 'Sedan'),
('CR-V', 'Honda', 2023, 35000, 'SUV'),
('Camry', 'Toyota', 2023, 28000, 'Sedan'),
('RAV4', 'Toyota', 2023, 33000, 'SUV'),
('Corolla', 'Toyota', 2023, 23000, 'Sedan'),
('Mustang', 'Ford', 2023, 40000, 'Sports'),
('F-150', 'Ford', 2023, 45000, 'Truck'),
('Focus', 'Ford', 2023, 22000, 'Sedan'),
('3 Series', 'BMW', 2023, 50000, 'Sedan'),
('X5', 'BMW', 2023, 65000, 'SUV'),
('C-Class', 'Mercedes', 2023, 55000, 'Sedan'),
('A4', 'Audi', 2023, 48000, 'Sedan'),
('Q5', 'Audi', 2023, 62000, 'SUV'),
('Model 3', 'Tesla', 2023, 52000, 'Electric'),
('Model Y', 'Tesla', 2023, 68000, 'Electric'),
('Elantra', 'Hyundai', 2023, 21000, 'Sedan'),
('Tucson', 'Hyundai', 2023, 29000, 'SUV'),
('Sportage', 'Kia', 2023, 30000, 'SUV'),
('Optima', 'Kia', 2023, 26000, 'Sedan');

-- ========================================
-- INSERT SAMPLE DATA - DEALERS
-- ========================================
INSERT INTO Dealers (DealerName, City, State, Phone) VALUES
('Downtown Motors', 'New York', 'NY', '212-555-0001'),
('Sunshine Auto', 'Miami', 'FL', '305-555-0002'),
('West Coast Autos', 'Los Angeles', 'CA', '213-555-0003'),
('North Star Motors', 'Minneapolis', 'MN', '612-555-0004'),
('Texas Auto Sales', 'Houston', 'TX', '713-555-0005'),
('Chicago Motors', 'Chicago', 'IL', '312-555-0006'),
('Arizona Auto Group', 'Phoenix', 'AZ', '602-555-0007'),
('Boston Auto Hub', 'Boston', 'MA', '617-555-0008'),
('Denver Motors', 'Denver', 'CO', '303-555-0009'),
('Seattle Auto', 'Seattle', 'WA', '206-555-0010');

-- ========================================
-- INSERT 1000 SAMPLE SALES RECORDS
-- ========================================
-- This generates 1000 sales records with realistic data
INSERT INTO Sales (CarID, DealerID, SaleDate, Quantity, TotalPrice, CustomerName)
SELECT 
    FLOOR(RAND() * 20) + 1 AS CarID,
    FLOOR(RAND() * 10) + 1 AS DealerID,
    DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 365) DAY) AS SaleDate,
    FLOOR(RAND() * 5) + 1 AS Quantity,
    (FLOOR(RAND() * 20) + 1) * (FLOOR(RAND() * 50000) + 20000) AS TotalPrice,
    CONCAT('Customer_', FLOOR(RAND() * 10000)) AS CustomerName
FROM (
    SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 
    UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10
) t1,
(
    SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 
    UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10
) t2,
(
    SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 
    UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10
) t3
LIMIT 1000;

-- ========================================
-- TOTAL QUERIES FOR CAR SALES ANALYSIS
-- ========================================

-- QUERY 1: Get Total Sales Count
SELECT COUNT(*) AS TotalSalesTransactions FROM Sales;

-- QUERY 2: Total Revenue
SELECT ROUND(SUM(TotalPrice), 2) AS TotalRevenue FROM Sales;

-- QUERY 3: Total Cars Sold
SELECT SUM(Quantity) AS TotalCarsSold FROM Sales;

-- QUERY 4: Sales by Brand
SELECT 
    c.Brand,
    COUNT(s.SalesID) AS TotalSales,
    SUM(s.Quantity) AS CarsSold,
    ROUND(SUM(s.TotalPrice), 2) AS Revenue
FROM Sales s
JOIN Cars c ON s.CarID = c.CarID
GROUP BY c.Brand
ORDER BY Revenue DESC;

-- QUERY 5: Sales by Dealer
SELECT 
    d.DealerName,
    d.City,
    COUNT(s.SalesID) AS TotalSales,
    SUM(s.Quantity) AS CarsSold,
    ROUND(SUM(s.TotalPrice), 2) AS Revenue
FROM Sales s
JOIN Dealers d ON s.DealerID = d.DealerID
GROUP BY d.DealerID, d.DealerName, d.City
ORDER BY Revenue DESC;

-- QUERY 6: Sales by Car Category
SELECT 
    c.Category,
    COUNT(s.SalesID) AS TotalSales,
    SUM(s.Quantity) AS CarsSold,
    ROUND(SUM(s.TotalPrice), 2) AS Revenue,
    ROUND(AVG(s.TotalPrice), 2) AS AvgSalePrice
FROM Sales s
JOIN Cars c ON s.CarID = c.CarID
GROUP BY c.Category
ORDER BY Revenue DESC;

-- QUERY 7: Top 10 Most Sold Cars
SELECT 
    c.CarModel,
    c.Brand,
    COUNT(s.SalesID) AS SalesCount,
    SUM(s.Quantity) AS CarsSold,
    ROUND(SUM(s.TotalPrice), 2) AS TotalRevenue
FROM Sales s
JOIN Cars c ON s.CarID = c.CarID
GROUP BY c.CarID, c.CarModel, c.Brand
ORDER BY CarsSold DESC
LIMIT 10;

-- QUERY 8: Monthly Sales Trend
SELECT 
    DATE_FORMAT(s.SaleDate, '%Y-%m') AS Month,
    COUNT(s.SalesID) AS TransactionCount,
    SUM(s.Quantity) AS CarsSold,
    ROUND(SUM(s.TotalPrice), 2) AS MonthlyRevenue
FROM Sales s
GROUP BY DATE_FORMAT(s.SaleDate, '%Y-%m')
ORDER BY Month DESC;

-- QUERY 9: Average Sale Price by Brand
SELECT 
    c.Brand,
    ROUND(AVG(s.TotalPrice), 2) AS AvgSalePrice,
    MIN(s.TotalPrice) AS MinPrice,
    MAX(s.TotalPrice) AS MaxPrice
FROM Sales s
JOIN Cars c ON s.CarID = c.CarID
GROUP BY c.Brand
ORDER BY AvgSalePrice DESC;

-- QUERY 10: Sales Performance by Dealer and Brand
SELECT 
    d.DealerName,
    c.Brand,
    COUNT(s.SalesID) AS SalesCount,
    SUM(s.Quantity) AS CarsSold,
    ROUND(SUM(s.TotalPrice), 2) AS Revenue
FROM Sales s
JOIN Dealers d ON s.DealerID = d.DealerID
JOIN Cars c ON s.CarID = c.CarID
GROUP BY d.DealerID, d.DealerName, c.Brand
ORDER BY Revenue DESC
LIMIT 50;

-- QUERY 11: Dealer Performance Ranking
SELECT 
    d.DealerName,
    d.City,
    COUNT(s.SalesID) AS TotalTransactions,
    SUM(s.Quantity) AS TotalCarsSold,
    ROUND(SUM(s.TotalPrice), 2) AS TotalRevenue,
    ROUND(AVG(s.TotalPrice), 2) AS AvgTransactionValue,
    DENSE_RANK() OVER (ORDER BY SUM(s.TotalPrice) DESC) AS PerformanceRank
FROM Sales s
JOIN Dealers d ON s.DealerID = d.DealerID
GROUP BY d.DealerID, d.DealerName, d.City
ORDER BY PerformanceRank;

-- QUERY 12: Complete Sales Details
SELECT 
    s.SalesID,
    s.SaleDate,
    s.CustomerName,
    c.CarModel,
    c.Brand,
    c.Year,
    s.Quantity,
    c.Price,
    s.TotalPrice,
    d.DealerName,
    d.City
FROM Sales s
JOIN Cars c ON s.CarID = c.CarID
JOIN Dealers d ON s.DealerID = d.DealerID
ORDER BY s.SaleDate DESC
LIMIT 1000;

-- ========================================
-- SUMMARY STATISTICS
-- ========================================
SELECT 
    'Total Sales Transactions' AS Metric,
    COUNT(*) AS Value
FROM Sales
UNION ALL
SELECT 'Total Cars Sold', SUM(Quantity) FROM Sales
UNION ALL
SELECT 'Total Revenue', ROUND(SUM(TotalPrice), 2) FROM Sales
UNION ALL
SELECT 'Average Sale Value', ROUND(AVG(TotalPrice), 2) FROM Sales
UNION ALL
SELECT 'Unique Customers', COUNT(DISTINCT CustomerName) FROM Sales
UNION ALL
SELECT 'Active Dealers', COUNT(DISTINCT DealerID) FROM Sales
UNION ALL
SELECT 'Car Models Available', COUNT(DISTINCT CarID) FROM Cars;