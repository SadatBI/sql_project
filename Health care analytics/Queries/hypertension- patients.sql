-- quick search to find any patient who has been diagnosed with "Hypertension"

SELECT DISTINCT 
    p.patient_id,
    p.first_name,
    p.last_name,
    e.primary_diagnosis
FROM Patients AS p
JOIN Encounters AS e 
	ON p.patient_id = e.patient_id
WHERE e.primary_diagnosis LIKE '%Hypertension%'
;