# 🏦 Banking Analytics System

A production-ready multi-database ecosystem engineered working within a modern retail banking enterprise. Management required an optimized, multi-database relational schema to process daily cash movements, protect user credentials, and evaluate institutional liquidity performance across multiple banking departments.
The system is split into three isolated databases to ensure speed, security, and data integrity: `UserManagementDB`, `CoreBankingDB` and `AnalyticsDB`

---

## 🏗️ Relational Architecture & Business Logic

It is designed for **MySQL Workbench** using the reliable **InnoDB** engine, enforcing strict transactional integrity via primary and foreign key constraints:
* **Roles ➔ Users:** One-to-Many. One authorization tier handles multiple active banking credentials.
* **Users ➔ Customers:** One-to-One. Each unique identity login maps to exactly one verified real-world personal profile.
* **Customers ➔ Accounts:** One-to-Many. A single customer can own multiple account types like checking, savings, or loans. 
* **AccountTypes ➔ Accounts:** One-to-Many. An individual account category sets default yield parameters for hundreds of unique account numbers.
* **Accounts ➔ Transactions:** One-to-Many. A liquid banking account builds a historical timeline of multiple deposit, withdrawal, and transfer events over time.

<img src="Retail_banking_analytics/Schema/Schema.png">

---

## 📊 Analytical Tasks & SQL Solutions

Here are the exact SQL queries I wrote to answer everyday questions an analytics team would face.

#### Task 1: Extract all customers with negative balance 

```sql
SELECT c.customer_id, c.first_name, c.last_name,
	   a.account_number, 
       a.balance AS negative_balance
FROM customers AS c
JOIN accounts AS a
	ON c.customer_id = a.customer_id
WHERE a.balance < 0
;
```

#### Task 2: Extract all customer's accounts containing operational assets 

```sql
SELECT  u.user_id,
		concat(c.first_name, ' ', c.last_name) AS full_name, 
        u.username,
        a.status AS account_status
FROM usermanagementdb.users AS u
JOIN corebankingdb.customers AS c
 ON u.user_id = c.user_id_ref
JOIN corebankingdb.accounts AS a
	ON a.customer_id = c.customer_id
WHERE a.status = 'Active'
 ;
```

#### Task 3: Cross-Schema Identity Mapping

```sql
SELECT u.user_id, u.username, u.email,
	   c.city, c.country
FROM usermanagementdb.users AS u
LEFT JOIN corebankingdb.customers AS c
	ON u.user_id = c.user_id_ref
;
```

#### Task 4: calculate an estimated annual payout value using the asset interest_rate for all accounts holding a balance greater than $100,000

```sql
SELECT  a.customer_id,
		concat(first_name, ' ', last_name) AS full_name,
        a.balance,
	   act.type_name,
       round(
        balance * ( 1 + interest_rate), 2) AS Estimated_Payout
FROM accounts AS a
JOIN accounttypes AS act
	USING (account_type_id)
JOIN customers
	USING (customer_id)
WHERE a.balance > 100000
ORDER BY balance DESC
;
```

#### Task 5: Identify customers with failed transactions

```sql
SELECT concat(first_name, ' ', last_name) AS full_name,
	   t.amount, t.transaction_type, t.reference_memo,
       t.created_at
FROM transactions AS t
JOIN accounts AS a
	ON t.source_account_id = a.account_id
JOIN customers AS c
	USING (customer_id)
WHERE t.status = 'Failed'
ORDER BY t.amount DESC
;
```

#### Task 6: Identify customers flagged in the 'High-Value' risk segment and  thier total transaction frequency count.

```sql
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
```

#### Task 7: Calculate total transaction metrics for Year 2026

```sql
SELECT distinct transaction_type, 
				sum(amount) AS Total 
FROM transactions
WHERE created_at >= '2026-01-01'
GROUP BY transaction_type
ORDER BY Total DESC
;
```

---

## 🚀 How to Run This Project
1. Copy `main SQL script`, [multi_db_banking_schema.sql](Database/multi_db_banking_schema.sql) containing the schema and sample data.
2. Open **MySQL Workbench** and connect to your local server.
3. Paste the code into a new query tab and hit **Execute** (the lightning bolt icon).
4. Drop any of the analysis queries above into a new tab to test them out!
