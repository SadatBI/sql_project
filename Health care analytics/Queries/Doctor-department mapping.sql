-- Return a list of all doctors, their specialties, and the name of their department.

SELECT doctor_id, first_name, last_name, specialty,
	   department_name, hire_date
FROM doctors 
JOIN departments
USING (department_id)
;