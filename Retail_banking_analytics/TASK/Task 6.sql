-- Query the data warehouse subsystem (AnalyticsDB). 
-- Target customers flagged in the 'High-Value' risk segment and  thier total transaction frequency count.

SELECT	 dc.full_name,
		 count(t.transaction_type) AS transaction_frequency_count
FROM analyticsdb.dimcustomersummary AS dc
JOIN corebankingdb.accounts AS a
	ON dc.customer_id_ref = a.customer_id
JOIN corebankingdb.transactions AS t
	ON a.account_id = t.source_account_id
WHERE dc.risk_segment = 'High-Value' 
GROUP BY dc.full_name
ORDER BY transaction_frequency_count DESC
;
