CREATE DATABASE CSV;
USE csv;
CREATE TABLE Books (Book_ID INT PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);

CREATE TABLE New_Customer (Customer_ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);

CREATE TABLE Orders (Order_ID INT PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);


ALTER TABLE books
ADD PRIMARY KEY (Book_ID);

ALTER TABLE new_customer
ADD PRIMARY KEY (Customer_ID);

ALTER TABLE orders
ADD PRIMARY KEY (Order_ID);

ALTER TABLE orders
ADD CONSTRAINT fk_orders_books
FOREIGN KEY (Book_ID)
REFERENCES books(Book_ID);

ALTER TABLE orders
ADD CONSTRAINT fk_orders_customers
FOREIGN KEY (Customer_ID)
REFERENCES new_customer(Customer_ID);

-- 1) Retrieve all books in the "Fiction" genre

SELECT * FROM books where genre='Fiction';

-- 2) Find books published after the year 1950

SELECT * FROM books where Published_year>'1950';

-- 3) List all customers from the Canada

SELECT * FROM new_customer WHERE city='Canada';

-- 4) Show orders placed in November 2023

SELECT * FROM orders WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

-- 5) Retrieve the total stock of books available

SELECT SUM(stock) AS total_stock 
FROM books;

-- 6) Find the details of the most expensive book

SELECT * FROM books WHERE Price= ( SELECT MAX(price) FROM books);

-- 7) Show all customers who ordered more than 1 quantity of a book

SELECT * FROM orders WHERE Quantity>'1';

SELECT c.Customer_ID,
       c.Name,
       c.Email,
       o.Order_ID,
       o.Book_ID,
       o.Quantity
FROM new_customer c
JOIN orders o
ON c.Customer_ID = o.Customer_ID
WHERE o.Quantity > 1;

-- 8) Retrieve all orders where the total amount exceeds $20

SELECT *
FROM orders
WHERE Total_Amount > 20;
-- 9) List all genres available in the Books table

SELECT DISTINCT Genre
FROM books;

-- 10) Find the book with the lowest stock

SELECT *
FROM books
WHERE Stock = (
    SELECT MIN(Stock)
    FROM books
);

-- 11) Calculate the total revenue generated from all orders

SELECT SUM(Total_Amount) AS Revenue_generated FROM orders;

-- 12) Retrieve the total number of books sold for each genre

SELECT b.genre,
	SUM(o.quantity) AS total_book_sold
    FROM books b
    JOIN orders o
    ON b.book_id=o.book_id
    GROUP BY b.genre;

-- 13) Find the average price of books in the "Fantasy" genre

SELECT genre,
	AVG(price) AS Avg_price
    FROM books 
    WHERE genre='Fantasy';
    
       
-- 14) List customers who have placed at least 2 orders

SELECT c.Customer_ID,
       c.Name,
       COUNT(o.Order_ID) AS Total_Orders
FROM new_customer c
JOIN orders o
ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.Name
HAVING COUNT(o.Order_ID) >= 2;

-- 15) Find the most frequently ordered book

SELECT b.book_ID,
       b.title,
       COUNT(o.Order_ID) AS times_ordered
FROM books b
JOIN orders o
ON b.book_ID = o.book_ID
GROUP BY b.book_ID, b.title
ORDER BY times_ordered DESC
LIMIT 1;

-- 16) Show the top 3 most expensive books of 'Fantasy' Genre 

SELECT * FROM books 
WHERE genre='fantasy'
ORDER BY price DESC
LIMIT 3;

-- 17) Retrieve the total quantity of books sold by each author

SELECT b.Author,
SUM(o.quantity) AS total_quantity
FROM books b
JOIN orders o
ON b.book_id=o.book_id
GROUP BY b.Author
ORDER BY total_quantity desc;

-- 18) List the cities where customers who spent over $30 are located

SELECT c.name,c.city
FROM new_customer c 
JOIN orders o
ON c.customer_id=o.book_id
WHERE o.total_amount>30;

-- 19) Find the customer who spent the most on orders

SELECT c.Customer_ID,
       c.Name,
       SUM(o.Total_Amount) AS Total_Spent
FROM new_customer c
JOIN orders o
ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.Name
ORDER BY Total_Spent DESC
LIMIT 1;
-- 20) Calculate the stock remaining after fulfilling all orders
SELECT b.Book_ID,
       b.Title,
       b.Stock AS Original_Stock,
       IFNULL(SUM(o.Quantity),0) AS Quantity_Sold,
       b.Stock - IFNULL(SUM(o.Quantity),0) AS Remaining_Stock
FROM books b
LEFT JOIN orders o
ON b.Book_ID = o.Book_ID
GROUP BY b.Book_ID, b.Title, b.Stock;


