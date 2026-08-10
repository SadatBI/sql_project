## 🏥 Healthcare Analytics Platform
 
This project simulates the real-world responsibilities of a Healthcare Data Analyst working within a regional hospital network. Management required an optimized relational database schema to monitor patient care pathways, track doctor performance, and evaluate revenue cycles across multiple clinical departments.

---

## 🏗️ Relational Architecture & Business Logic
It is designed for **MySQL Workbench** using the reliable **InnoDB** engine, enforcing strict transactional integrity via primary and foreign key constraints:
* **Departments ➔ Doctors:** One-to-Many. One department can host many doctors.
* **Patients ➔ Encounters:** One-to-Many. A single patient can have multiple hospital visits over time. 
* **Doctors ➔ Encounters:** One-to-Many. Tracks which physician was primary on record for a clinical visit.
* **Encounters ➔ Bills:** A strict 1-to-1 relationship ensures every medical visit has exactly one financial statement attached to it.

<img src="Schema/schema.png" width="60%">

---

## 📊 Analytical Tasks & SQL Solutions

Here are the exact SQL queries I wrote to answer everyday questions an analytics team would face.

### Task 1: Patient Demographics FilterProblem:
* **Goal:** Identify all female patients to assist the preventive medicine outreach team.
```sql
SELECT
     patient_id, 
    first_name, 
    last_name, 
    date_of_birth, 
    gender 
FROM patients 
WHERE gender = 'Female';
```

### 2. High-Value Encounters
* **Goal:** Filter out any hospital visits that cost more than \$500.
```sql
SELECT *
FROM encounters AS e
JOIN bills AS b
 ON e.encounter_id = b.encounter_id
WHERE b.total_charged >= 500
ORDER BY total_charged DESC
;
```

### 3. Revenue Leakage
* **Goal:** Calculate exactly how much money is sitting in "Unpaid" or "Partially Paid" bills.
```sql
SELECT *, 
	   (total_charged - insurance_paid - patient_paid) AS Remaing_balance
FROM bills 
WHERE billing_status IN ('Partially Paid', 'Unpaid')
;
```

### 4. Doctor-Department Mapping
* **Goal:** Create a simple directory of all operational doctors, their specific medical specialties, and their assigned functional departments.
```sql
SELECT 
    d.doctor_id,
    d.first_name,
    d.last_name,
    d.specialty,
    dept.department_name
FROM Doctors d
JOIN Departments dept
 ON d.department_id = dept.department_id;
```

### 5. Executive Summary Metrics
* **Goal:** Aggregate core financial performance indicators (KPIs) showing total gross charges versus actual collections.
```sql
SELECT 
    SUM(total_charged) AS total_revenue_charged,
    SUM(insurance_paid) AS total_insurance_collected,
    SUM(patient_paid) AS total_patient_collections
FROM Bills;
```

### 6. Volume by Encounter Type
* **Goal:** Find out where the hospital is the busiest (Inpatient, Outpatient, or the ER).
```sql
SELECT encounter_type, 
	   COUNT(encounter_id) AS total_visits
FROM encounters
GROUP BY encounter_type
ORDER BY total_visits DESC;
```

### 7. Patient Journey Tracking
* **Goal:** Build an audit log showing patient names, detailing the date of service, attending physician, and primary outcome.
```sql
SELECT
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    e.visit_date,
    CONCAT('Dr. ', d.last_name) AS attending_physician,
    e.primary_diagnosis
FROM Encounters e
JOIN Patients p ON e.patient_id = p.patient_id
JOIN Doctors d ON e.doctor_id = d.doctor_id
ORDER BY e.visit_date DESC;
```

### 8. Highest Performing Department
* **Goal:** Identify which department is generating the most revenue for the hospital.
```sql
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
```

### 9. Chronic Condition Tracking
* **Goal:** Run a quick search to find any patient who has been diagnosed with "Hypertension".
```sql
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
```

### 10. High-Volume Practitioner Identification
* **Goal:** Find our high-performing doctors who have handled more than one patient encounter.
```sql
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
```

---

## 🚀 How to Run This Project
1. Copy `main SQL script`, [Healthcare.sql](Database/Healthcare.sql) containing the schema and sample data.
2. Open **MySQL Workbench** and connect to your local server.
3. Paste the code into a new query tab and hit **Execute** (the lightning bolt icon).
4. Drop any of the analysis queries above into a new tab to test them out!
