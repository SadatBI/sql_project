SELECT concat(first_name, ' ', last_name) AS full_name,
	   t.amount, t.transaction_type, t.reference_memo,
       t.created_at
FROM transactions AS t
JOIN accounts AS a
	ON t.source_account_id = a.account_id
JOIN customers AS c
	USING (customer_id)
WHERE t.status = 'Failed'
ORDER BY t.amount DESC
;