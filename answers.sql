-- Question 1: Achieving 1NF (First Normal Form)
-- Task: Transform ProductDetail table to eliminate multi-valued attributes
-- Step 1: Create the original table with unnormalized data
CREATE TABLE ProductDetail_Original (
    OrderID INT,
    CustomerName VARCHAR(100),
    Products VARCHAR(255)
);

-- Insert the original data
INSERT INTO ProductDetail_Original (OrderID, CustomerName, Products) VALUES
(101, 'John Doe', 'Laptop, Mouse'),
(102, 'Jane Smith', 'Tablet, Keyboard, Mouse'),
(103, 'Emily Clark', 'Phone');

-- Step 2: Create the normalized table structure (1NF)
CREATE TABLE ProductDetail_1NF (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100)
);

-- Step 3: Insert normalized data - each product gets its own row
INSERT INTO ProductDetail_1NF (OrderID, CustomerName, Product) VALUES
-- Order 101 - John Doe
(101, 'John Doe', 'Laptop'),
(101, 'John Doe', 'Mouse'),

-- Order 102 - Jane Smith
(102, 'Jane Smith', 'Tablet'),
(102, 'Jane Smith', 'Keyboard'),
(102, 'Jane Smith', 'Mouse'),

-- Order 103 - Emily Clark
(103, 'Emily Clark', 'Phone');

-- Step 4: Query to display the 1NF table
SELECT * FROM ProductDetail_1NF
ORDER BY OrderID, Product;

-- Question 2: Achieving 2NF (Second Normal Form)
-- Task: Remove partial dependencies from OrderDetails table

-- Step 1: Create the original 1NF table with partial dependencies
CREATE TABLE OrderDetails_1NF (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product)  -- Composite primary key
);

-- Insert the original 1NF data
INSERT INTO OrderDetails_1NF (OrderID, CustomerName, Product, Quantity) VALUES
(101, 'John Doe', 'Laptop', 2),
(101, 'John Doe', 'Mouse', 1),
(102, 'Jane Smith', 'Tablet', 3),
(102, 'Jane Smith', 'Keyboard', 1),
(102, 'Jane Smith', 'Mouse', 2),
(103, 'Emily Clark', 'Phone', 1);

-- Step 2: Create 2NF tables by separating partial dependencies

-- Table 1: Orders - Contains data that depends only on OrderID
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

-- Table 2: OrderItems - Contains data that depends on the full composite key (OrderID + Product)
CREATE TABLE OrderItems (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Step 3: Populate the 2NF tables

-- Insert unique orders (removing CustomerName redundancy)
INSERT INTO Orders (OrderID, CustomerName) VALUES
(101, 'John Doe'),
(102, 'Jane Smith'),
(103, 'Emily Clark');

-- Insert order items (data that depends on full composite key)
INSERT INTO OrderItems (OrderID, Product, Quantity) VALUES
(101, 'Laptop', 2),
(101, 'Mouse', 1),
(102, 'Tablet', 3),
(102, 'Keyboard', 1),
(102, 'Mouse', 2),
(103, 'Phone', 1);

-- Step 4: Query to verify the 2NF transformation
-- This recreates the original view using JOINs
SELECT 
    Orders.OrderID,
    Orders.CustomerName,
    OrderItems.Product,
    OrderItems.Quantity
FROM Orders
JOIN OrderItems ON Orders.OrderID = OrderItems.OrderID
ORDER BY Orders.OrderID, OrderItems.Product;