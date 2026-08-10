-- Identify doctors who have managed more than 1 encounter.

SELECT 
    e.doctor_id,
    CONCAT(d.first_name, ' ', d.last_name) AS doctor_name,
    COUNT(e.encounter_id) AS encounter_count
FROM Encounters e
JOIN Doctors d 
	ON e.doctor_id = d.doctor_id
GROUP BY e.doctor_id, doctor_name
HAVING COUNT(e.encounter_id) > 1
;