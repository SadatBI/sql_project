-- ============================================================================
-- FINANCIAL ENTERPRISE MULTI-DATABASE SETUP SCRIPT
-- ============================================================================

-- ============================================================================
-- 1. USER MANAGEMENT DATABASE
-- ============================================================================
CREATE DATABASE UserManagementDB;
USE UserManagementDB;

CREATE TABLE Roles (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255)
);

CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20),
    role_id INT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES Roles(role_id)
);

CREATE TABLE AuditLogs (
    log_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    action_performed VARCHAR(100) NOT NULL,
    ip_address VARCHAR(45),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE SET NULL
);

-- Seed UserManagementDB Data
INSERT INTO Roles (role_name, description) VALUES
('Customer', 'Retail banking customer account access'),
('Teller', 'Front desk staff handling baseline client queries'),
('Manager', 'Branch supervisor managing authorization overrides'),
('Auditor', 'Internal risk compliance reviewer with read-only scopes');

INSERT INTO Users (user_id, username, email, password_hash, phone_number, role_id, is_active) VALUES
(101, 'jdoe88', 'j.doe@email.com', '$2b$12$Klsjdhf83hfs', '+15550100', 1, 1),
(102, 'asmith_fin', 'a.smith@bank.com', '$2b$12$Pskjdhf84hfs', '+15550101', 2, 1),
(103, 'm_garcia', 'm.garcia@email.com', '$2b$12$Qskjdhf85hfs', '+15550102', 1, 1),
(104, 'vpatel', 'v.patel@email.com', '$2b$12$Rskjdhf86hfs', '+15550103', 1, 0), -- Suspended User
(105, 'b_obama', 'b.obama@email.com', '$2b$12$Sskjdhf87hfs', '+15550104', 1, 1),
(106, 'c_jones_mgr', 'c.jones@bank.com', '$2b$12$Tskjdhf88hfs', '+15550105', 3, 1),
(107, 'l_walker', 'l.walker@email.com', '$2b$12$Uskjdhf89hfs', '+15550106', 1, 1),
(108, 't_stark', 't.stark@email.com', '$2b$12$Vskjdhf90hfs', '+15550107', 1, 1),
(109, 's_rogers', 's.rogers@email.com', '$2b$12$Wskjdhf91hfs', '+15550108', 1, 1),
(110, 'n_romanoff', 'n.romanoff@bank.com', '$2b$12$Xskjdhf92hfs', '+15550109', 4, 1),
(111, 'b_banner', 'b.banner@email.com', '$2b$12$Yskjdhf93hfs', '+15550110', 1, 1),
(112, 'w_maximoff', 'w.maximoff@email.com', '$2b$12$Zskjdhf94hfs', '+15550111', 1, 1);

INSERT INTO AuditLogs (user_id, action_performed, ip_address, timestamp) VALUES
(101, 'Login', '192.168.1.50', '2026-02-01 08:30:00'),
(102, 'Login', '10.0.4.12', '2026-02-01 08:00:00'),
(104, 'Password_Reset_Failed', '185.22.41.9', '2026-02-01 09:12:00'),
(106, 'Account_Override', '10.0.2.55', '2026-02-01 11:22:00'),
(103, 'Login', '192.168.1.82', '2026-02-01 13:05:00'),
(108, 'Login', '172.16.25.4', '2026-02-02 07:15:00'),
(109, 'Login', '172.16.25.9', '2026-02-02 07:45:00'),
(110, 'Export_Compliance_Report', '10.0.9.11', '2026-02-02 10:00:00'),
(101, 'Password_Change', '192.168.1.50', '2026-02-02 14:20:00'),
(105, 'Login', '192.168.1.11', '2026-02-02 16:40:00');


-- ============================================================================
-- 2. CORE BANKING DATABASE
-- ============================================================================
CREATE DATABASE CoreBankingDB;
USE CoreBankingDB;

CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id_ref INT NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    tax_identifier VARCHAR(50) UNIQUE,
    address_line1 VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE AccountTypes (
    account_type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL UNIQUE,
    interest_rate DECIMAL(5,4) NOT NULL DEFAULT 0.0000
);

CREATE TABLE Accounts (
    account_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    account_type_id INT NOT NULL,
    account_number VARCHAR(20) NOT NULL UNIQUE,
    balance DECIMAL(15,2) NOT NULL DEFAULT 0.00,
    status VARCHAR(20) DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (account_type_id) REFERENCES AccountTypes(account_type_id)
);

CREATE TABLE Transactions (
    transaction_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    source_account_id INT NOT NULL,
    destination_account_id INT,
    transaction_type VARCHAR(20) NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    reference_memo VARCHAR(255),
    status VARCHAR(20) DEFAULT 'Completed',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (source_account_id) REFERENCES Accounts(account_id),
    FOREIGN KEY (destination_account_id) REFERENCES Accounts(account_id)
);

-- Seed CoreBankingDB Data
INSERT INTO Customers (customer_id, user_id_ref, first_name, last_name, date_of_birth, tax_identifier, address_line1, city, country) VALUES
(1, 101, 'John', 'Doe', '1988-05-12', 'TX-9912A', '742 Evergreen Tce', 'Springfield', 'USA'),
(2, 103, 'Maria', 'Garcia', '1992-11-23', 'TX-4410B', '123 Maple St', 'Vancouver', 'Canada'),
(3, 104, 'Vikram', 'Patel', '1975-01-04', 'TX-1299C', '456 Oak Rd', 'London', 'UK'),
(4, 105, 'Barack', 'Obama', '1961-08-04', 'TX-0001A', '1600 Pennsylvania Ave', 'Washington', 'USA'),
(5, 107, 'Logan', 'Walker', '1995-07-19', 'TX-8831D', '89 Pine Ave', 'Sydney', 'Australia'),
(6, 108, 'Tony', 'Stark', '1970-05-29', 'TX-3000S', '10880 Malibu Point', 'Malibu', 'USA'),
(7, 109, 'Steve', 'Rogers', '1918-07-04', 'TX-1941B', '569 Corona Ave', 'Brooklyn', 'USA'),
(8, 111, 'Bruce', 'Banner', '1969-12-18', 'TX-0500H', 'Unknown Base Rd', 'Dayton', 'USA'),
(9, 112, 'Wanda', 'Maximoff', '1989-02-10', 'TX-1111W', '42 Westview Dr', 'Westview', 'USA');

INSERT INTO AccountTypes (account_type_id, type_name, interest_rate) VALUES
(1, 'Checking', 0.0000),
(2, 'Savings', 0.0425),
(3, 'Loan', 0.0750);

-- Mixed up balances and accounts
INSERT INTO Accounts (account_id, customer_id, account_type_id, account_number, balance, status) VALUES
(501, 1, 1, 'ACC-1001-CH', 4500.50, 'Active'),
(502, 1, 2, 'ACC-1001-SV', 25000.00, 'Active'),
(503, 2, 1, 'ACC-1002-CH', 120.00, 'Active'),
(504, 3, 1, 'ACC-1003-CH', 0.00, 'Frozen'),
(505, 4, 1, 'ACC-1004-CH', 890000.00, 'Active'),
(506, 4, 2, 'ACC-1004-SV', 4500000.00, 'Active'),
(507, 5, 1, 'ACC-1005-CH', 12450.75, 'Active'),
(508, 6, 1, 'ACC-1006-CH', 12500000.00, 'Active'),
(509, 6, 3, 'ACC-1006-LN', -500000.00, 'Active'),
(510, 7, 1, 'ACC-1007-CH', 150.25, 'Active'),
(511, 8, 2, 'ACC-1008-SV', 550.00, 'Active'),
(512, 9, 1, 'ACC-1009-CH', -25.00, 'Active');

-- Mixed transaction types, volumes, historical data, and failure metrics
INSERT INTO Transactions (source_account_id, destination_account_id, transaction_type, amount, currency, reference_memo, status, created_at) VALUES
(501, NULL, 'Deposit', 1500.00, 'USD', 'Monthly Paycheck', 'Completed', '2026-01-15 09:00:00'),
(501, 502, 'Transfer', 500.00, 'USD', 'Savings allocation', 'Completed', '2026-01-15 09:15:00'),
(503, NULL, 'Withdrawal', 200.00, 'USD', 'ATM Cash Out', 'Completed', '2026-01-16 14:22:00'),
(505, 506, 'Transfer', 100000.00, 'USD', 'Quarterly Interest Move', 'Completed', '2026-01-17 11:00:00'),
(508, 509, 'Transfer', 50000.00, 'USD', 'Loan Repayment Tranche', 'Completed', '2026-01-18 16:30:00'),
(512, NULL, 'Withdrawal', 50.00, 'USD', 'Overdraft ATM Attempt', 'Failed', '2026-01-20 19:45:00'),
(507, NULL, 'Deposit', 3400.00, 'USD', 'Stripe Vendor Payout', 'Completed', '2026-01-22 08:12:00'),
(510, NULL, 'Withdrawal', 100.00, 'USD', 'Gas Station Card Swipe', 'Completed', '2026-01-25 13:00:00'),
(502, NULL, 'Withdrawal', 6000.00, 'USD', 'Wire Transfer House Downpayment', 'Completed', '2026-01-28 10:15:00'),
(504, NULL, 'Deposit', 500.00, 'USD', 'Incoming Lockbox Wire', 'Failed', '2026-01-29 11:00:00'),
(501, 503, 'Transfer', 250.00, 'USD', 'Gift to Maria', 'Completed', '2026-02-01 14:00:00'),
(508, NULL, 'Withdrawal', 12000.00, 'USD', 'Dinner Catering Luxury bill', 'Completed', '2026-02-02 21:00:00');


-- ============================================================================
-- 3. ANALYTICS & REPORTING DATABASE (Data Warehouse Subsystem)
-- ============================================================================
CREATE DATABASE AnalyticsDB;
USE AnalyticsDB;

CREATE TABLE DimDate (
    date_key INT PRIMARY KEY,
    full_date DATE NOT NULL,
    day_of_week VARCHAR(10),
    month_name VARCHAR(15),
    quarter INT,
    year INT
);

CREATE TABLE DimCustomerSummary (
    customer_key INT AUTO_INCREMENT PRIMARY KEY,
    customer_id_ref INT NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    risk_segment VARCHAR(50) DEFAULT 'Standard'
);

CREATE TABLE FactTransactionDailySummary (
    summary_key BIGINT AUTO_INCREMENT PRIMARY KEY,
    date_key INT NOT NULL,
    customer_key INT NOT NULL,
    total_deposits DECIMAL(18,2) DEFAULT 0.00,
    total_withdrawals DECIMAL(18,2) DEFAULT 0.00,
    transaction_count INT DEFAULT 0,
    FOREIGN KEY (date_key) REFERENCES DimDate(date_key),
    FOREIGN KEY (customer_key) REFERENCES DimCustomerSummary(customer_key)
);

-- Seed AnalyticsDB Data
INSERT INTO DimDate (date_key, full_date, day_of_week, month_name, quarter, year) VALUES
(20260116, '2026-01-16', 'Friday', 'January', 1, 2026),
(20260117, '2026-01-17', 'Saturday', 'January', 1, 2026),
(20260118, '2026-01-18', 'Sunday', 'January', 1, 2026),
(20260122, '2026-01-22', 'Thursday', 'January', 1, 2026),
(20260128, '2026-01-28', 'Wednesday', 'January', 1, 2026),
(20260201, '2026-02-01', 'Sunday', 'February', 1, 2026),
(20260202, '2026-02-02', 'Monday', 'February', 1, 2026);

-- Populating Customer Dimension
INSERT INTO DimCustomerSummary (customer_key, customer_id_ref, full_name, country, risk_segment) VALUES
(1001, 1, 'John Doe', 'USA', 'Standard'),
(1002, 2, 'Maria Garcia', 'Canada', 'Standard'),
(1003, 4, 'Barack Obama', 'USA', 'High-Value'),
(1004, 5, 'Logan Walker', 'Australia', 'Standard'),
(1005, 6, 'Tony Stark', 'USA', 'High-Value');

-- Historical rolled-up day aggregations
INSERT INTO FactTransactionDailySummary (date_key, customer_key, total_deposits, total_withdrawals, transaction_count) VALUES
(20260115, 1001, 1500.00, 500.00, 2),
(20260116, 1002, 0.00, 200.00, 1),
(20260117, 1003, 0.00, 100000.00, 1),
(20260118, 1005, 0.00, 50000.00, 1),
(20260122, 1004, 3400.00, 0.00, 1),
(20260128, 1001, 0.00, 6000.00, 1),
(20260201, 1001, 0.00, 250.00, 1),
(20260202, 1005, 0.00, 12000.00, 1);

