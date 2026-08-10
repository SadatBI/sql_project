-- Write a query showing Patient Full Name, Visit Date, Doctor Last Name, and Primary Diagnosis.

SELECT
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    e.visit_date,
    CONCAT('Dr. ', d.last_name) AS attending_physician,
    e.primary_diagnosis
FROM Encounters e
JOIN Patients p ON e.patient_id = p.patient_id
JOIN Doctors d ON e.doctor_id = d.doctor_id
ORDER BY e.visit_date DESC
;
