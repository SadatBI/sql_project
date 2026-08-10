CREATE DATABASE HealthcareAnalytics;
USE HealthcareAnalytics;

-- 2. TABLE CREATION (SCHEMA)
-- -------------------------------------------------------------------------

-- Table: Departments
CREATE TABLE Departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    building_floor INT NOT NULL
) ENGINE=InnoDB;

-- Table: Doctors
CREATE TABLE Doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    specialty VARCHAR(100) NOT NULL,
    department_id INT,
    hire_date DATE NOT NULL,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Table: Patients
CREATE TABLE Patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    state_code CHAR(2) NOT NULL,
    registration_date DATE NOT NULL
) ENGINE=InnoDB;

-- Table: Encounters (Visits)
CREATE TABLE Encounters (
    encounter_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    visit_date DATE NOT NULL,
    primary_diagnosis VARCHAR(255) NOT NULL,
    encounter_type ENUM('Inpatient', 'Outpatient', 'ER') NOT NULL,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id) ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Table: Bills
CREATE TABLE Bills (
    bill_id INT AUTO_INCREMENT PRIMARY KEY,
    encounter_id INT NOT NULL UNIQUE,
    total_charged DECIMAL(10, 2) NOT NULL,
    insurance_paid DECIMAL(10, 2) DEFAULT 0.00,
    patient_paid DECIMAL(10, 2) DEFAULT 0.00,
    billing_status ENUM('Paid', 'Partially Paid', 'Unpaid') NOT NULL,
    due_date DATE NOT NULL,
    FOREIGN KEY (encounter_id) REFERENCES Encounters(encounter_id) ON DELETE CASCADE
) ENGINE=InnoDB;


-- 3. DATA INSERTION (SAMPLE DATA)
-- -------------------------------------------------------------------------

-- Insert Departments
INSERT INTO Departments (department_name, building_floor) VALUES
('Cardiology', 3),
('Neurology', 4),
('Pediatrics', 1),
('Emergency Medicine', 1),
('General Medicine', 2);

-- Insert Doctors
INSERT INTO Doctors (first_name, last_name, specialty, department_id, hire_date) VALUES
('Alice', 'Smith', 'Cardiologist', 1, '2018-03-12'),
('Robert', 'Chen', 'Neurologist', 2, '2019-07-22'),
('Emily', 'Taylor', 'Pediatrician', 3, '2021-01-15'),
('David', 'Jones', 'ER Physician', 4, '2015-11-01'),
('Sarah', 'Miller', 'General Practitioner', 5, '2020-05-18'),
('James', 'Wilson', 'Cardiologist', 1, '2022-09-01');

-- Insert Patients
INSERT INTO Patients (first_name, last_name, date_of_birth, gender, state_code, registration_date) VALUES
('John', 'Doe', '1980-05-14', 'Male', 'NY', '2023-01-10'),
('Jane', 'Roe', '1995-11-23', 'Female', 'NJ', '2023-02-15'),
('Michael', 'Green', '1962-08-03', 'Male', 'NY', '2023-03-01'),
('Emma', 'White', '2015-04-12', 'Female', 'CT', '2023-04-20'),
('William', 'Black', '1975-12-30', 'Male', 'NJ', '2023-05-11'),
('Linda', 'Brown', '1950-02-19', 'Female', 'NY', '2023-06-05');

-- Insert Encounters
INSERT INTO Encounters (patient_id, doctor_id, visit_date, primary_diagnosis, encounter_type) VALUES
(1, 1, '2024-01-15', 'Hypertension', 'Outpatient'),
(2, 2, '2024-01-16', 'Migraine', 'Outpatient'),
(3, 4, '2024-01-17', 'Acute Appendicitis', 'ER'),
(4, 3, '2024-01-18', 'Influenza', 'Outpatient'),
(5, 5, '2024-01-19', 'Type 2 Diabetes', 'Outpatient'),
(6, 1, '2024-01-20', 'Arrhythmia', 'Inpatient'),
(1, 6, '2024-02-10', 'Chest Pain', 'ER'),
(3, 5, '2024-02-15', 'Hypertension Check', 'Outpatient');

-- Insert Bills
INSERT INTO Bills (encounter_id, total_charged, insurance_paid, patient_paid, billing_status, due_date) VALUES
(1, 150.00, 100.00, 50.00, 'Paid', '2024-02-15'),
(2, 200.00, 150.00, 0.00, 'Partially Paid', '2024-02-16'),
(3, 2500.00, 1800.00, 700.00, 'Paid', '2024-02-17'),
(4, 120.00, 90.00, 30.00, 'Paid', '2024-02-18'),
(5, 180.00, 0.00, 0.00, 'Unpaid', '2024-02-19'),
(6, 5000.00, 4000.00, 500.00, 'Partially Paid', '2024-02-20'),
(7, 950.00, 700.00, 250.00, 'Paid', '2024-03-10'),
(8, 110.00, 80.00, 30.00, 'Paid', '2024-03-15');