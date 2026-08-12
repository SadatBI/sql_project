
SELECT  a.customer_id,
		concat(first_name, ' ', last_name) AS full_name,
        a.balance,
	   act.type_name,
       round(
        balance * ( 1 + interest_rate), 2) AS Estimated_Payout
FROM accounts AS a
JOIN accounttypes AS act
	USING (account_type_id)
JOIN customers
	USING (customer_id)
WHERE a.balance > 100000
ORDER BY balance DESC