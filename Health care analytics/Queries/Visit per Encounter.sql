-- Count how many visits occurred per encounter type (Inpatient, Outpatient, ER).

SELECT encounter_type, 
	   COUNT(encounter_id) AS total_visits
FROM encounters
GROUP BY encounter_type
ORDER BY total_visits DESC;