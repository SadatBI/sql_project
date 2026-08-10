-- Find all outstanding balances where the bill is 'Unpaid' or 'Partially Paid'. 
-- Calculate the remaining balance (Total Charged - Insurance Paid - Patient Paid).

SELECT *, 
	   (total_charged - insurance_paid - patient_paid) AS Remaing_balance
FROM bills 
WHERE billing_status IN ('Partially Paid', 'Unpaid')
;