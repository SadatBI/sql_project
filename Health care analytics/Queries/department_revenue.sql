-- Find the department name that has generated the highest total billing charges.

SELECT 
    dept.department_name,
    SUM(b.insurance_paid + b.patient_paid) AS total_revenue
FROM Bills b
JOIN Encounters e
	ON b.encounter_id = e.encounter_id
JOIN Doctors doc 
	ON e.doctor_id = doc.doctor_id
JOIN Departments dept 
	ON doc.department_id = dept.department_id
GROUP BY dept.department_name
ORDER BY total_revenue DESC
;