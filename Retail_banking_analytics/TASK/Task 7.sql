SELECT distinct transaction_type, sum(amount)
FROM transactions
WHERE transaction_type REGEXP 'Withdrawal|Deposit'
GROUP BY transaction_type
;