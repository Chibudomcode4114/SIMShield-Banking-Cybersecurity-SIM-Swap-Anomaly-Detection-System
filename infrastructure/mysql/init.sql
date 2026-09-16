-- ==============================================================================
-- SIMShield Initial Database Schema & Synthetic Seed Data
-- ==============================================================================
-- Domain: Banking Cybersecurity / SIM-Swap Anomaly Detection
-- Privacy Constraint: SYNTHETIC / TEST DATA ONLY (No real banking credentials or PII)
-- ==============================================================================

CREATE DATABASE IF NOT EXISTS simshield_db;
USE simshield_db;

-- 1. Accounts Table (Synthetic Customer Profiles)
CREATE TABLE IF NOT EXISTS bank_accounts (
    id VARCHAR(36) PRIMARY KEY,
    account_number VARCHAR(20) NOT NULL UNIQUE,
    customer_pseudo_id VARCHAR(36) NOT NULL,
    phone_hash VARCHAR(64) NOT NULL,
    kyc_tier VARCHAR(10) DEFAULT 'TIER_3',
    account_status VARCHAR(20) DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 2. SIM Swap Events (Simulated Telecom Feed)
CREATE TABLE IF NOT EXISTS sim_swap_events (
    id VARCHAR(36) PRIMARY KEY,
    phone_hash VARCHAR(64) NOT NULL,
    imsi_hash VARCHAR(64) NOT NULL,
    previous_imsi_hash VARCHAR(64),
    telecom_carrier VARCHAR(50) NOT NULL,
    swap_timestamp TIMESTAMP NOT NULL,
    event_source VARCHAR(50) DEFAULT 'SIMULATED_TELCO_GATEWAY',
    processed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Banking Transactions (Simulated Financial Activity)
CREATE TABLE IF NOT EXISTS banking_transactions (
    id VARCHAR(36) PRIMARY KEY,
    account_id VARCHAR(36) NOT NULL,
    amount_kobo BIGINT NOT NULL,
    currency VARCHAR(3) DEFAULT 'NGN',
    transaction_type VARCHAR(30) NOT NULL,
    destination_account VARCHAR(20),
    device_fingerprint_hash VARCHAR(64),
    ip_address_masked VARCHAR(45),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (account_id) REFERENCES bank_accounts(id)
);

-- 4. Risk Assessments & Decision Audits (SIMShield Core Output)
CREATE TABLE IF NOT EXISTS risk_assessments (
    id VARCHAR(36) PRIMARY KEY,
    transaction_id VARCHAR(36),
    account_id VARCHAR(36) NOT NULL,
    sim_swap_event_id VARCHAR(36),
    risk_score INT NOT NULL,
    risk_tier ENUM('LOW', 'MEDIUM', 'HIGH', 'CRITICAL') NOT NULL,
    decision ENUM('ALLOW', 'FLAG_FOR_REVIEW', 'REQUIRE_STEP_UP', 'HOLD_TRANSACTION') NOT NULL,
    reasoning_summary TEXT NOT NULL,
    assessed_by VARCHAR(50) DEFAULT 'SIMSHIELD_RULES_ENGINE_V1',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (account_id) REFERENCES bank_accounts(id)
);

-- Synthetic Demonstration Seed (Safe Placeholders)
INSERT IGNORE INTO bank_accounts (id, account_number, customer_pseudo_id, phone_hash, kyc_tier, account_status)
VALUES 
('acc-001', '0123456789', 'cust-syn-101', 'hash_e3b0c44298fc1c149afbf4c8996fb924', 'TIER_3', 'ACTIVE'),
('acc-002', '9876543210', 'cust-syn-102', 'hash_f7ff9e8b7bb2e09b70935a5d785e0cc5', 'TIER_2', 'ACTIVE');
