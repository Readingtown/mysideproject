# AutoPartsDB

This project sets up a database for managing auto parts, inventory, customers, and orders. 
The database is created using MySQL and includes tables for parts, inventory, customers, and orders. 

## Database Structure
![Autopart stock management ERD diagram](https://github.com/Readingtown/mysql-scripts/assets/167072737/ddbe345d-e32a-4c45-9f7a-af3c1e18ed86)



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

The database is pre-produce with sample data for parts, inventory, customers, and orders.

**Parts:**
- `Window Regulator`, `Durable Window Regulator`, `$50.99`
- `Hood Latch`, `Easy installation Hood Latch`, `$6.49`
- `Door Handle`, `Chrome Door Handle`, `$15.00`

**Inventory:**
- `Part ID 1`, `Quantity 100`, `Threshold 20`
- `Part ID 2`, `Quantity 200`, `Threshold 50`
- `Part ID 3`, `Quantity 150`, `Threshold 30`

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

```

### Insert Sample Data

```sql

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

```

 ### Check for Low Inventory:

```sql
SELECT Parts.part_name, Inventory.quantity
FROM Inventory
INNER JOIN Parts ON Inventory.part_id = Parts.part_id
WHERE Inventory.quantity < Inventory.threshold;

```

### Generate Sales Report:
```sql
SELECT Parts.part_name, SUM(Orders.quantity) AS total_sold
FROM Orders
LEFT JOIN Parts ON Orders.part_id = Parts.part_id
GROUP BY Parts.part_name;
```

### Yearly Demand Forecast:
```sql
SELECT part_id, 
FLOOR(AVG(quantity)) AS avg_monthly_sales
FROM Orders
WHERE order_date > DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY part_id;
```

# Insert data to matplotlib and create bar chart
```python
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from sqlalchemy import create_engine
```

### Create SQLAlchemy Engine
```python
engine = create_engine('mysql+pymysql://username:password@localhost:portnumber/AutoPartsDB')
```

### Define SQL query
```python
data = "SELECT part_name, SUM(quantity) AS total_sold 
	FROM Orders 
	INNER JOIN Parts 
	ON Orders.part_id = Parts.part_id 
	GROUP BY part_name"
```


### Use Pandas to read data from SQL
```python
df = pd.read_sql(data, engine)
```

### Use matplotlib to create barchart
```python
plt.figure(figsize=(10, 6))
sns.barplot(x='part_name', y='total_sold', data=df)
plt.title('Sales Quantity',fontsize =24)
plt.xlabel('Part Name',fontsize =16)
plt.ylabel('Total Sold',fontsize =16)
plt.savefig("Sales Quantity")
plt.show()
```
## Bar chart 
![Sales Quantity](https://github.com/Readingtown/mysideproject/assets/167072737/54c14dc3-c388-4291-a5ae-383576103bfc)

### Usage
1. Create the database and tables using the provided SQL scripts.
2. Insert the sample data.
3. Run the queries to manage and analyze auto parts inventory, sales, and forecast prediction.

### License
This project is licensed under the ARIEL KUO YU SHAN License.


### Author
ARIEL KUO YU SHAN

