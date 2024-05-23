use AutoPartsDB;

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

INSERT INTO Parts (part_name, part_description, price) VALUES
('Window Regulator', 'Durable Window Regulator', 50.99),
('Hood Latch', 'Easy installation Hood Latch', 6.49),
('Door Handle', 'Chrome Door Handle', 15.00);

INSERT INTO Inventory (part_id, quantity, threshold) VALUES
(1, 100, 20),
(2, 200, 50),
(3, 150, 30);

INSERT INTO Customers (customer_name, contact_email) VALUES
('Scott Williams', 'Scott Williams@autozone.com'),
('Jane Smith', 'jane@goodforparts.com');

INSERT INTO Orders (customer_id, part_id, order_date, quantity, status) VALUES
(1, 1, '2024-03-21', 5, 'Shipped'),
(2, 2, '2024-04-20', 10, 'Pending');

-- 查詢庫存不足的零件
SELECT Parts.part_name, Inventory.quantity
FROM Inventory
INNER JOIN Parts ON Inventory.part_id = Parts.part_id
WHERE Inventory.quantity < Inventory.threshold;

-- 產出銷售報告
SELECT Parts.part_name, SUM(Orders.quantity) AS total_sold
FROM Orders
LEFT JOIN Parts ON Orders.part_id = Parts.part_id
GROUP BY Parts.part_name;

-- 需求預測查詢
SELECT part_id, 
FLOOR(AVG(quantity)) AS avg_monthly_sales
FROM Orders
WHERE order_date > DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY part_id;

import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from sqlalchemy import create_engine


# 創建 SQLAlchemy 引擎
engine = create_engine('mysql+pymysql://username:password@localhost:portnumber/AutoPartsDB')

# 定義 SQL 查詢
data = "SELECT part_name, SUM(quantity) AS total_sold 
	FROM Orders 
	INNER JOIN Parts 
	ON Orders.part_id = Parts.part_id 
	GROUP BY part_name"


# 使用 Pandas 讀取資料庫中的資料
df = pd.read_sql(data, engine)
	
# 使用matplotlib製作圖表
plt.figure(figsize=(10, 6))
sns.barplot(x='part_name', y='total_sold', data=df)
plt.title('Sales Quantity',fontsize =24)
plt.xlabel('Part Name',fontsize =16)
plt.ylabel('Total Sold',fontsize =16)
plt.savefig("Sales Quantity")
plt.show()

