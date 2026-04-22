-- ══════════════════════════════════════════════════════
--  EBMS — Updated SQL  (run this AFTER your existing ebms.sql)
--  Adds: customer_auth table + payment_history table
-- ══════════════════════════════════════════════════════

USE ebms2;

-- ──────────────────────────────────────────────────────
--  1. CUSTOMER AUTH  (email + password for portal login)
-- ──────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS `customer_auth` (
  `auth_id`   INT          NOT NULL AUTO_INCREMENT,
  `cust_id`   INT          NOT NULL,
  `email`     VARCHAR(100) NOT NULL UNIQUE,
  `password`  VARCHAR(255) NOT NULL,
  `created_at` DATETIME    DEFAULT NOW(),
  PRIMARY KEY (`auth_id`),
  KEY `cust_id` (`cust_id`),
  CONSTRAINT `customer_auth_ibfk_1`
    FOREIGN KEY (`cust_id`) REFERENCES `customer` (`cust_id`)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ──────────────────────────────────────────────────────
--  2. PAYMENT HISTORY  (records every bill payment)
-- ──────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS `payment_history` (
  `payment_id`     INT          NOT NULL AUTO_INCREMENT,
  `cust_id`        INT          NOT NULL,
  `meter_number`   VARCHAR(10)  NOT NULL,
  `amount_paid`    DECIMAL(10,2) NOT NULL,
  `payment_method` VARCHAR(50)  DEFAULT 'Online',
  `paid_at`        DATETIME     DEFAULT NOW(),
  PRIMARY KEY (`payment_id`),
  KEY `cust_id` (`cust_id`),
  KEY `meter_number` (`meter_number`),
  CONSTRAINT `payment_history_ibfk_1`
    FOREIGN KEY (`cust_id`) REFERENCES `customer` (`cust_id`)
    ON DELETE CASCADE,
  CONSTRAINT `payment_history_ibfk_2`
    FOREIGN KEY (`meter_number`) REFERENCES `billing` (`meter_number`)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- ──────────────────────────────────────────────────────
--  3. SEED — demo login for existing customers
--     (password stored in plain-text for demo purposes;
--      use bcrypt in production)
-- ──────────────────────────────────────────────────────

INSERT IGNORE INTO `customer_auth` (cust_id, email, password) VALUES
  (111, 'abhay@ebms.in',    'abhay@123'),
  (112, 'vishnu@ebms.in',   'vishnu@123'),
  (113, 'anant@ebms.in',    'anant@123'),
  (211, 'vijay@ebms.in',    'vijay@123'),
  (212, 'deekshith@ebms.in','deekshith@123'),
  (311, 'farhaan@ebms.in',  'farhaan@123'),
  (312, 'ajay@ebms.in',     'ajay@123'),
  (313, 'nikhil@ebms.in',   'nikhil@123'),
  (324, 'tushar@ebms.in',   'tushar@123'),
  (325, 'ayushman@ebms.in', 'ayushman@123'),
  (345, 'rohanjit@ebms.in', 'rohanjit@123'),
  (347, 'anwesh@ebms.in',   'anwesh@123'),
  (367, 'devash@ebms.in',   'devash@123'),
  (411, 'preetham@ebms.in', 'preetham@123'),
  (412, 'sridhar@ebms.in',  'sridhar@123');

-- ──────────────────────────────────────────────────────
--  SUMMARY OF ALL CHANGES:
--
--  NEW TABLES:
--    customer_auth    — stores email + password per customer
--    payment_history  — log of all bill payments made via portal
--
--  NEW SERVER ENDPOINTS (in server.js):
--    POST /api/auth/register          — customer self-registration
--    POST /api/auth/customer-login    — customer login (returns profile)
--    GET  /api/customer/:id/profile   — own profile only
--    GET  /api/customer/:id/account   — own account only
--    GET  /api/customer/:id/billing   — own billing only
--    GET  /api/customer/:id/invoices  — own invoices only
--    POST /api/customer/:id/pay       — record a payment
--    GET  /api/customer/:id/payments  — own payment history
--
--  All admin endpoints remain UNCHANGED.
-- ──────────────────────────────────────────────────────
