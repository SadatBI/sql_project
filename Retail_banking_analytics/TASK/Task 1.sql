-- customers with negative balance

SELECT c.customer_id, c.first_name, c.last_name,
	   a.account_number, 
       a.balance AS negative_balance
FROM customers AS c
JOIN accounts AS a
	ON c.customer_id = a.customer_id
WHERE a.balance < 0