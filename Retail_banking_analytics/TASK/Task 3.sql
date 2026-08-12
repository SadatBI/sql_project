
SELECT u.user_id, u.username, u.email,
	   c.city, c.country
FROM usermanagementdb.users AS u
LEFT JOIN corebankingdb.customers AS c
	ON u.user_id = c.user_id_ref
;