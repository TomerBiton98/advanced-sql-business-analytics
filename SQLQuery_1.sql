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


