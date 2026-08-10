-- Calculate total revenue charged, total insurance collected, and total patient collections.

SELECT SUM(total_charged) AS 'total revenue charged',
	   SUM(insurance_paid) AS 'total insurance collected',
       SUM(patient_paid) AS 'total patient collections'
FROM bills