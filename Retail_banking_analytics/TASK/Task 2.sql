

SELECT  u.user_id,
		concat(c.first_name, ' ', c.last_name) AS full_name, 
        u.username,
        a.status AS account_status
FROM usermanagementdb.users AS u
JOIN corebankingdb.customers AS c
 ON u.user_id = c.user_id_ref
JOIN corebankingdb.accounts AS a
	ON a.customer_id = c.customer_id
WHERE a.status = 'Active'
 ;
 