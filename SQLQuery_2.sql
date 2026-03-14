-- Query 1 -> the query return the order amount for each costomer that is bigger then the avg amonut of all ordres:
SELECT (c.FirstName +' '+ c.LastName) as FullName,
        o.Amount as OrderAmount,
                    (SELECT AVG(Amount) 
                     FROM Orders) as AvgAmount
FROM Customers c
    JOIN Orders o 
        ON c.CustomerID = o.CustomerID
WHERE o.Amount > (
                        SELECT AVG(Amount) 
                        FROM Orders)
GROUP BY (c.FirstName +' '+ c.LastName), o.Amount;

-- Query 2 -> the query return for each product if it is in stok and how many from each product:
SELECT ProductName,
    (SELECT 
        CASE
            WHEN QuantityOnHand > 0 THEN 'In Stok'
            ELSE 'Not In Stok'
        END
    FROM Inventory I
    WHERE P.ProductID = I.ProductID)
FROM Products P
    JOIN Inventory I
        ON P.ProductID = I.ProductID ;

-- Query 3-> who is the manager of each emploeey:
SELECT e.EmployeeID,
      (e.FirstName +' '+ e.LastName) as FullName,
       e.Position,
       d.DepartmentName,
       d.ManagerID,
           (SELECT (e.FirstName +' '+ e.LastName) as FullName
            FROM Employees e
            WHERE e.EmployeeID = d.ManagerID) as ManagerName
FROM Employees e
    JOIN Departments d 
        ON e.DepartmentID = d.DepartmentID
ORDER BY d.DepartmentID;


-- Query 4 -> avg of salery of emploees located in New York:
SELECT (e.FirstName +' '+ e.LastName) as FullName,
        e.Position,
        e.Salary,
        d.LOCATION
FROM Employees e
    JOIN Departments d 
        ON e.DepartmentID = d.DepartmentID
WHERE e.Salary <= (
                    SELECT AVG(Salary) 
                    FROM Employees ep)
       AND d.LOCATION = 'New York'
GROUP BY (e.FirstName +' '+ e.LastName),
        e.Position,
        e.Salary,
        d.LOCATION;

-- Query 5 -> supplier transact status:
SELECT s.SupplierID,
       s.SupplierName,
       COUNT(st.TransactionID) AS TotalTransactions,
       SUM(st.Amount) AS TotalAmountSpent,
       AVG(st.Amount) AS AverageTransactionAmount,
       MAX(st.TransactionDate) AS LatestTransactionDate,
       COUNT(CASE 
            WHEN st.IsPaid = 0 
            THEN 1 ELSE NULL 
        END) AS UnpaidTransactions
FROM FitMeDataBase.dbo.Suppliers s
    LEFT JOIN WorkDataBase.dbo.SupplierTransactions st 
        ON s.SupplierID = st.SupplierID
GROUP BY s.SupplierID, s.SupplierName
ORDER BY TotalAmountSpent DESC;

-- Query 5 -> This query provides a summary of customer purchasing behavior by calculating various metrics related to their orders.
SELECT 
    c.CustomerID,
    CONCAT(c.FirstName, ' ', c.LastName) AS FullName,
    SUM(o.Amount) AS TotalAmountSpent,
    COUNT(o.OrderID) AS TotalOrders,
    AVG(o.Amount) AS AvgOrderAmount,
    MIN(o.Amount) AS MinOrderAmount,
    MAX(o.Amount) AS MaxOrderAmount,
    DATEDIFF(DAY, MAX(o2.OrderDate), MAX(o.OrderDate)) AS DaysBetweenLastTwoOrders,
    DATEDIFF(DAY, MAX(o.OrderDate), GETDATE()) AS DaysSinceLastOrder,
    COUNT(DISTINCT p.ProductID) AS UniqueProductsOrdered
FROM Customers c
    JOIN Orders o 
        ON c.CustomerID = o.CustomerID
    JOIN Products p 
        ON o.ProductID = p.ProductID
    LEFT JOIN Orders o2 
        ON c.CustomerID = o2.CustomerID AND o.OrderDate > o2.OrderDate
GROUP BY c.CustomerID, c.FirstName, c.LastName
HAVING COUNT(o.OrderID) > 1
ORDER BY TotalAmountSpent DESC;

-- Query 6 -> The query retrieves data from the "Suppliers" and "Products" tables, calculates the total sales amount for each supplier, and presents the results in descending order of sales.:
SELECT s.SupplierID,
       s.SupplierName, 
       SUM(p.Price) AS Total_Sales_Amount,
       COUNT(p.ProductID) AS Number_of_Products_Sold
FROM Suppliers s
    JOIN Products p 
        ON s.SupplierID = p.SupplierID
GROUP BY s.SupplierID, s.SupplierName
ORDER BY Total_Sales_Amount DESC;


-- Query ? -> this query filter out order by order dates that was made between the selected years max-->min (could calculate on year or orders between Multiple years)
SELECT c.CustomerID, c.FirstName, c.LastName, o.OrderDate
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE c.CustomerID IN (
    SELECT o.CustomerID
    FROM Orders o
    GROUP BY o.CustomerID
    HAVING MAX(YEAR(o.OrderDate)) = 2022 AND MIN(YEAR(o.OrderDate)) = 2022
)
ORDER BY o.OrderDate ASC;

-- this query filter out order by order dates by years and quarters (you can select and type for example 2022/2023 and the quarter 1,2,3,4)and see the Results 

SELECT c.CustomerID, c.FirstName, c.LastName, o.OrderDate
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE YEAR(o.OrderDate) = 2022
  AND DATEPART(QUARTER, o.OrderDate) = 1
ORDER BY o.OrderDate ASC;


SELECT c.CustomerID,
       c.FirstName,
       c.LastName,
       c.country,
       sum(t.TotalTransactionAmount)  AS TotalTransactionAmount
FROM Customers c
JOIN (
    SELECT o.CustomerID,
           o.OrderID,
        (
            SELECT t.Amount
            FROM Transactions t
            WHERE t.OrderID = o.OrderID 
        ) AS TotalTransactionAmount
    FROM
        Orders o
    ) t ON c.CustomerID = t.CustomerID
JOIN Transactions tr
    ON tr.customerID = c.CustomerID
WHERE c.country = 'USA' AND tr.TransactionType = 'Purchase'
GROUP BY  c.CustomerID, c.FirstName, c.LastName, c.country
ORDER BY c.customerID;




SELECT 
    SupplierID,
    SupplierName,
    TotalProductsSold,
    TotalRevenue,
    AvgRevenuePerProduct,
    RevenueContributionPercentage,
    TotalCustomers,
    AvgOrderValue
FROM (
    SELECT 
        SupplierID,
        SupplierName,
        TotalProductsSold,
        TotalRevenue,
        AvgRevenuePerProduct,
        RevenueContributionPercentage,
        TotalCustomers,
        AvgOrderValue,
        ROW_NUMBER() OVER (ORDER BY TotalRevenue DESC) AS Rank
    FROM (
        SELECT 
            s.SupplierID,
            s.SupplierName,
            COUNT(p.ProductID) AS TotalProductsSold,
            SUM(p.Price) AS TotalRevenue,
            CASE 
                WHEN COUNT(p.ProductID) > 0 THEN SUM(p.Price) / COUNT(p.ProductID) 
                ELSE 0 
            END AS AvgRevenuePerProduct,
            SUM(p.Price) * 100.0 / SUM(SUM(p.Price)) OVER () AS RevenueContributionPercentage,
            COUNT(DISTINCT c.CustomerID) AS TotalCustomers,
            AVG(o.Amount) AS AvgOrderValue
        FROM 
            Suppliers s
        JOIN 
            Products p ON s.SupplierID = p.SupplierID
        JOIN 
            Orders o ON p.ProductID = o.ProductID
        JOIN 
            Customers c ON o.CustomerID = c.CustomerID
        GROUP BY 
            s.SupplierID, s.SupplierName
    ) AS SupplierPerformanceMetrics
) AS RankedSuppliers
WHERE Rank <= 10; -- You can adjust this number to show top N suppliers





SELECT 
    SupplierID,--מספר זהות ספק
    SupplierName,--שם החברה של הספק
    TotalProductsSold,--מספר מוצרים שנרכשו ממנו
    MostPurchasedProduct,--המוצר שרכשנו הכי הרבה ממנו
    TotalRevenue,-- הרווח שלו על סך המכירות שלו   
    AvgRevenuePerProduct,--רווח ממוצע מכל עסקה
    RevenueContributionPercentage,--כמה באחוזים הוא ספק מועדף/נצרך על ידינו
    TotalCustomers,--לכמה יחודיים לקוחות מכר הספק
    AvgOrderValue-- שווי ממוצע של כל עסקה שנעשתה עם מוצרים של ספק זה
FROM (
    SELECT 
        SupplierID,
        SupplierName,
        TotalProductsSold,
        MostPurchasedProduct,
        TotalRevenue,
        AvgRevenuePerProduct,
        RevenueContributionPercentage,
        TotalCustomers,
        AvgOrderValue,
        ROW_NUMBER() OVER (ORDER BY TotalRevenue DESC) AS Rank
    FROM (
        SELECT 
            s.SupplierID,
            s.SupplierName,
            COUNT(p.ProductID) AS TotalProductsSold,
            (
                SELECT TOP 1
                    p.ProductName
                FROM 
                    Products p
                WHERE 
                    p.SupplierID = s.SupplierID
                GROUP BY 
                    p.ProductName
                ORDER BY 
                    COUNT(*) DESC
            ) AS MostPurchasedProduct,
            SUM(p.Price) AS TotalRevenue,
            CASE 
                WHEN COUNT(p.ProductID) > 0 THEN SUM(p.Price) / COUNT(p.ProductID) 
                ELSE 0 
            END AS AvgRevenuePerProduct,
            SUM(p.Price) * 100.0 / SUM(SUM(p.Price)) OVER () AS RevenueContributionPercentage,
            COUNT(DISTINCT c.CustomerID) AS TotalCustomers,
            AVG(o.Amount) AS AvgOrderValue
        FROM 
            Suppliers s
        JOIN 
            Products p ON s.SupplierID = p.SupplierID
        JOIN 
            Orders o ON p.ProductID = o.ProductID
        JOIN 
            Customers c ON o.CustomerID = c.CustomerID
        GROUP BY 
            s.SupplierID, s.SupplierName
    ) AS SupplierPerformanceMetrics
) AS RankedSuppliers
WHERE Rank <= 50; -- You can adjust this number to show top N suppliers
