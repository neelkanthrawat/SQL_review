--  --
CREATE TEMPORARY TABLE orders_temp (
    order_id INT,
    customer_id INT,
    order_date DATE,
    amount INT
);
INSERT INTO orders_temp VALUES
(1, 101, '2024-01-10', 250),
(2, 102, '2024-01-15', 800),
(3, 101, '2024-02-05', 300),
(4, 103, '2024-03-12', 150),
(5, 101, '2024-04-01', 500),
(6, 102, '2024-04-03', 1000);

-- task: return customers who spent more than 1000 dollars in 2024.
-- step 1. create a temp table returning customer id, and total amount they spent
-- step 2. use the temp table in step 1 to find customer id of those who spent >1000.

CREATE TEMPORARY TABLE total_expense_each_customer_temp
SELECT customer_id, SUM(amount) AS total_expenses
FROM orders_temp
GROUP BY customer_id;

-- showing the result
select *
from total_expense_each_customer_temp;

-- now find the customers who spent >1000 
select customer_id
from total_expense_each_customer_temp
where total_expense_each_customer_temp.total_expenses > 1000;

DROP TABLE IF EXISTS total_expense_each_customer_temp;
DROP TABLE IF EXISTS orders_temp;