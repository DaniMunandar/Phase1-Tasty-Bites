CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    position VARCHAR(255)
);

CREATE TABLE MenuItems (
    item_id INT PRIMARY KEY,
    name VARCHAR(255),
    description TEXT,
    price DECIMAL(10, 2),
    category VARCHAR(255)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    table_number INT,
    employee_id INT,
    order_date DATE,
    status VARCHAR(255),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
);

CREATE TABLE OrderItems (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    item_id INT,
    quantity INT,
    subtotal DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (item_id) REFERENCES MenuItems(item_id)
);

CREATE TABLE Payments (
    payment_id INT PRIMARY KEY,
    order_id INT,
    payment_date DATE,
    payment_method VARCHAR(255),
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

INSERT INTO Employees (employee_id, first_name, last_name, position)
VALUES
    (1, 'Jhon','Doe','Waiters');

INSERT INTO MenuItems (item_id, name, description, price, category)
VALUES
    (1, 'Steak','Grilled sirloin steak', 25.99, 'Main Course');

INSERT INTO Orders (order_id, table_number, employee_id, order_date, status)
VALUES
    (1, 5, 1, '2023-08-04', 'Pending');

INSERT INTO OrderItems (order_item_id, order_id, item_id, quantity, subtotal)
VALUES
    (1, 1, 1, 2, 51.98);

INSERT INTO Payments (payment_id, order_id, payment_date, payment_method, total_amount)
VALUES
    (1, 1, '2023-08-04', 'Credit Card', 51.98);


-- A. Retrieve all orders with their applied discounts (Mengambil semua pesanan beserta diskon yang diterapkan pada pesanan tersebut):
SELECT
    O.order_id,
    O.table_number,
    E.first_name AS employee_first_name,
    E.last_name AS employee_last_name,
    O.order_date,
    O.status,
    P.total_amount,
    (P.total_amount - (SELECT SUM(oi.subtotal) FROM OrderItems AS oi WHERE oi.order_id = O.order_id)) AS applied_discount
FROM
    Orders AS O
JOIN
    Employees AS E ON O.employee_id = E.employee_id
JOIN
    Payments AS P ON O.order_id = P.order_id;


-- B. Calculate the total revenue (including discounts) for a specific day (Menghitung total pendapatan, termasuk diskon, untuk hari tertentu):
SELECT
    SUM(P.total_amount - (SELECT SUM(oi.subtotal) FROM OrderItems AS oi WHERE oi.order_id = O.order_id)) AS total_revenue
FROM
    Orders AS O
JOIN
    Payments AS P ON O.order_id = P.order_id
WHERE
    O.order_date = '2023-08-04';
