# AutoPartsDB

This project sets up a database for managing auto parts, inventory, customers, and orders. 
The database is created using MySQL and includes tables for parts, inventory, customers, and orders. 

## Database Structure

### Tables

1. **Parts**
   - `part_id`: INT, AUTO_INCREMENT, PRIMARY KEY
   - `part_name`: VARCHAR(100), NOT NULL
   - `part_description`: VARCHAR(100)
   - `price`: DECIMAL(10, 2)

2. **Inventory**
   - `inventory_id`: INT, AUTO_INCREMENT, PRIMARY KEY
   - `part_id`: INT, FOREIGN KEY REFERENCES `Parts(part_id)`
   - `quantity`: INT
   - `threshold`: INT

3. **Customers**
   - `customer_id`: INT, AUTO_INCREMENT, PRIMARY KEY
   - `customer_name`: VARCHAR(45)
   - `contact_email`: VARCHAR(100)

4. **Orders**
   - `order_id`: INT, AUTO_INCREMENT, PRIMARY KEY
   - `customer_id`: INT, FOREIGN KEY REFERENCES `Customers(customer_id)`
   - `part_id`: INT, FOREIGN KEY REFERENCES `Parts(part_id)`
   - `order_date`: DATETIME
   - `quantity`: INT
   - `status`: VARCHAR(45)

### Sample Data

The database is pre-populated with sample data for parts, inventory, customers, and orders.

**Parts:**
- `Window Regulator`, `Durable Window Regulator`, `$50.99`
- `Hood Latch`, `Easy installation Hood Latch`, `$6.49`
- `Door Handle`, `Chrome Door Handle`, `$15.00`

**Inventory:**
- Part ID 1, Quantity 100, Threshold 20
- Part ID 2, Quantity 200, Threshold 50
- Part ID 3, Quantity 150, Threshold 30

**Customers:**
- `Scott Williams`, `ScottWilliams@autozone.com`
- `Jane Smith`, `jane@goodforparts.com`

**Orders:**
- Customer ID 1, Part ID 1, `2024-03-21`, Quantity 5, Status `Shipped`
- Customer ID 2, Part ID 2, `2024-04-20`, Quantity 10, Status `Pending`

## SQL Scripts

### Create Database and Tables

```sql
USE AutoPartsDB;

CREATE TABLE Parts (
    part_id INT AUTO_INCREMENT PRIMARY KEY,
    part_name VARCHAR(100) NOT NULL,
    part_description VARCHAR(100),
    price DECIMAL(10, 2)
);

CREATE TABLE Inventory (
    inventory_id INT AUTO_INCREMENT PRIMARY KEY,
    part_id INT,
    quantity INT,
    threshold INT,
    FOREIGN KEY (part_id) REFERENCES Parts(part_id)
);

CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(45),
    contact_email VARCHAR(100)
);

CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    part_id INT,
    order_date DATETIME,
    quantity INT,
    status VARCHAR(45),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (part_id) REFERENCES Parts(part_id)
);


-- Insert Sample Data

INSERT INTO Parts (part_name, part_description, price) VALUES
('Window Regulator', 'Durable Window Regulator', 50.99),
('Hood Latch', 'Easy installation Hood Latch', 6.49),
('Door Handle', 'Chrome Door Handle', 15.00);

INSERT INTO Inventory (part_id, quantity, threshold) VALUES
(1, 100, 20),
(2, 200, 50),
(3, 150, 30);

INSERT INTO Customers (customer_name, contact_email) VALUES
('Scott Williams', 'ScottWilliams@autozone.com'),
('Jane Smith', 'jane@goodforparts.com');

INSERT INTO Orders (customer_id, part_id, order_date, quantity, status) VALUES
(1, 1, '2024-03-21', 5, 'Shipped'),
(2, 2, '2024-04-20', 10, 'Pending');


-- Check for Low Inventory:

SELECT Parts.part_name, Inventory.quantity
FROM Inventory
INNER JOIN Parts ON Inventory.part_id = Parts.part_id
WHERE Inventory.quantity < Inventory.threshold;

-- Generate Sales Report:

SELECT Parts.part_name, SUM(Orders.quantity) AS total_sold
FROM Orders
LEFT JOIN Parts ON Orders.part_id = Parts.part_id
GROUP BY Parts.part_name;

-- Yearly Demand Forecast:

SELECT part_id, 
FLOOR(AVG(quantity)) AS avg_monthly_sales
FROM Orders
WHERE order_date > DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY part_id;

Usage
1. Create the database and tables using the provided SQL scripts.
2. Insert the sample data.
3. Run the queries to manage and analyze your auto parts inventory, sales, and customer orders.

License
This project is licensed under the MIT License.

Author
ARIEL KUO

