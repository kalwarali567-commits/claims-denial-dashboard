-- Claims Denial Analysis (synthetic data, PostgreSQL)
-- Data: synthetic_claims_data.csv, loaded into a table named "claims"

-- 1. Create the table
CREATE TABLE claims (
  claim_id TEXT, service_date DATE, submission_date DATE, days_to_submit INT,
  payer TEXT, provider_specialty TEXT, cpt_code TEXT, cpt_description TEXT,
  billed_amount NUMERIC(10,2), allowed_amount NUMERIC(10,2), paid_amount NUMERIC(10,2),
  claim_status TEXT, denial_reason_code TEXT, denial_reason_description TEXT,
  denial_category TEXT, appeal_status TEXT, recovered_amount NUMERIC(10,2)
);

-- (Import the CSV into this table, then check the row count)
SELECT COUNT(*) FROM claims;   -- expected: 1800

-- 2. Cleaned view used by Power BI
CREATE VIEW claims_clean AS
SELECT *,
  CASE WHEN claim_status = 'Denied' THEN 1 ELSE 0 END AS denied_flag,
  CASE WHEN claim_status = 'Denied' THEN billed_amount ELSE 0 END AS denied_amount,
  TO_CHAR(service_date, 'YYYY-MM') AS service_month
FROM claims;

-- 3. KPI summary (matches the dashboard cards)
SELECT COUNT(*) AS total_claims,
       SUM(denied_flag) AS denied_claims,
       ROUND(100.0 * SUM(denied_flag) / COUNT(*), 2) AS denial_rate_pct,
       ROUND(SUM(denied_amount), 2) AS denied_amount,
       ROUND(SUM(recovered_amount), 2) AS recovered_amount,
       ROUND(AVG(days_to_submit), 2) AS avg_days_to_submit
FROM claims_clean;

-- 4. Denial rate by payer
SELECT payer,
       COUNT(*) AS total_claims,
       SUM(denied_flag) AS denied_claims,
       ROUND(100.0 * SUM(denied_flag) / COUNT(*), 1) AS denial_rate_pct
FROM claims_clean
GROUP BY payer
ORDER BY denial_rate_pct DESC;

-- 5. Denials by category
SELECT denial_category,
       COUNT(*) AS denied_claims,
       ROUND(SUM(billed_amount), 2) AS denied_amount
FROM claims_clean
WHERE denied_flag = 1
GROUP BY denial_category
ORDER BY denied_claims DESC;

-- 6. Denials by reason code (matches the dashboard table)
SELECT denial_reason_code,
       denial_reason_description,
       COUNT(*) AS denied_claims,
       ROUND(SUM(billed_amount), 2) AS denied_amount
FROM claims_clean
WHERE denied_flag = 1
GROUP BY denial_reason_code, denial_reason_description
ORDER BY denied_claims DESC;

-- 7. Denial rate by service month
SELECT service_month,
       ROUND(100.0 * SUM(denied_flag) / COUNT(*), 1) AS denial_rate_pct
FROM claims_clean
GROUP BY service_month
ORDER BY service_month;

-- 8. Appeal outcomes for denied claims
SELECT appeal_status, COUNT(*) AS denied_claims
FROM claims_clean
WHERE denied_flag = 1
GROUP BY appeal_status
ORDER BY denied_claims DESC;


