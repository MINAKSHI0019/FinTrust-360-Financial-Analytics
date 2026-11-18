
-- 1. Total complaints
SELECT COUNT(*) AS total_complaints
FROM FINTRUST_COMPLAINTS;

-- 2. Monthly complaint trends
SELECT TO_CHAR(date_received, 'YYYY-MM') AS complaint_month,
       COUNT(*) AS total_complaints
FROM FINTRUST_COMPLAINTS
GROUP BY TO_CHAR(date_received, 'YYYY-MM')
ORDER BY complaint_month;

-- 3. Complaints by financial product
SELECT financial_product, COUNT(*) AS total_complaints
FROM FINTRUST_COMPLAINTS
GROUP BY financial_product
ORDER BY total_complaints DESC;

-- 4. Most frequently reported issues
SELECT issue_category, COUNT(*) AS total_complaints
FROM FINTRUST_COMPLAINTS
GROUP BY issue_category
ORDER BY total_complaints DESC;

-- 5. Complaints by company
SELECT company_name, COUNT(*) AS total_complaints
FROM FINTRUST_COMPLAINTS
GROUP BY company_name
ORDER BY total_complaints DESC;

-- 6. Complaints by customer state (Unknown includes missing locations)
SELECT state, COUNT(*) AS total_complaints
FROM FINTRUST_COMPLAINTS
GROUP BY state
ORDER BY total_complaints DESC;

-- 7. Timely-response percentage by company.
-- Open complaints are excluded because they do not yet have a response.
SELECT company_name,
       COUNT(*) AS responded_complaints,
       SUM(CASE WHEN timely_response_clean = 'Yes' THEN 1 ELSE 0 END) AS timely_responses,
       ROUND(100 * SUM(CASE WHEN timely_response_clean = 'Yes' THEN 1 ELSE 0 END)
             / NULLIF(COUNT(*), 0), 2) AS timely_response_pct
FROM FINTRUST_COMPLAINTS
WHERE response_status = 'Closed'
  AND date_company_responded IS NOT NULL
GROUP BY company_name
ORDER BY timely_response_pct DESC;

-- 8. Average response time in days (open complaints excluded)
SELECT ROUND(AVG(date_company_responded - date_received), 2)
       AS average_response_time_days
FROM FINTRUST_COMPLAINTS
WHERE response_status = 'Closed'
  AND date_company_responded IS NOT NULL;

-- 9. Open vs closed complaint status
SELECT response_status, COUNT(*) AS complaint_count
FROM FINTRUST_COMPLAINTS
GROUP BY response_status;

-- 10. Monthly timely-response performance
SELECT TO_CHAR(date_received, 'YYYY-MM') AS complaint_month,
       COUNT(*) AS responded_complaints,
       SUM(CASE WHEN timely_response_clean = 'Yes' THEN 1 ELSE 0 END) AS timely_responses,
       ROUND(100 * SUM(CASE WHEN timely_response_clean = 'Yes' THEN 1 ELSE 0 END)
             / NULLIF(COUNT(*), 0), 2) AS timely_response_pct
FROM FINTRUST_COMPLAINTS
WHERE response_status = 'Closed'
  AND date_company_responded IS NOT NULL
GROUP BY TO_CHAR(date_received, 'YYYY-MM')
ORDER BY complaint_month;
