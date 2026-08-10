-- Find all hospital encounters that generated a total charge greater than $500.

SELECT *
FROM encounters AS e
JOIN bills AS b
USING (encounter_id)
WHERE b.total_charged >= 500
ORDER BY total_charged DESC
;