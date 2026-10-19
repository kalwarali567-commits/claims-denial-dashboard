# Claims Denial Analysis Dashboard (Power BI)

A Power BI dashboard that shows why medical claims get denied, by payer, reason code, and appeal outcome, built to help billing teams find recoverable revenue.

> **Data note:** This project uses a synthetic dataset created for portfolio demonstration. It contains no real patient data and does not represent a client engagement or real financial recoveries.

![Dashboard](dashboard_screenshot.png)

## Business question
Where are claims being denied, why are they being denied, and which problems can a billing team fix?

## What the dashboard shows
- Total claims, denial rate, denied amount, recovered amount, and average days to submit
- Denial rate by payer
- Denied claims by denial category and reason code
- Denial rate by service month
- Appeal outcomes for denied claims
- Slicers to filter by payer and provider specialty

## Key findings (synthetic sample data)
- **1,800 claims**, of which **303 were denied** (16.83% denial rate), totaling about **$34.05K** in denied billed amount.
- **Humana** had the highest denial rate (about 29%), followed by **UnitedHealthcare** and **Medicaid** (about 20-21%). **Medicare** was lowest (about 11%).
- **Missing information (CO-16)** was the largest denial reason (67 claims), followed by **timely filing (CO-29)** with 50 and **prior authorization (CO-197)** with 48. Several of these are front-end process issues that can be prevented.
- About **half of denied claims were never appealed**.
- Only about **$4.32K of $34.05K** (roughly 13%) was recovered, which points to unrecovered revenue in this sample.

## How I built it
1. Loaded the claims dataset into PostgreSQL
2. Created a cleaned view (`claims_clean`) with a denial flag, denied amount, and service month
3. Connected Power BI to the view and built DAX measures (Total Claims, Denied Claims, Denial Rate %, Denied Amount, Recovered Amount, Avg Days to Submit)
4. Designed the report page and checked totals against the SQL results

## Tools
Power BI, SQL (PostgreSQL), Excel

## Files
| File | Description |
|---|---|
| `synthetic_claims_data.csv` | Synthetic dataset (1,800 claims) |
| `denial_analysis.sql` | Table, view, and analysis queries |
| `claims_denial_dashboard.pbix` | Power BI report |
| `dashboard_screenshot.png` | Dashboard preview |

## About me
Healthcare data analyst and nursing student with clinical experience, focused on revenue cycle (RCM) analytics.

**Contact:** kalwarali567@gmail.com
**LinkedIn:** https://www.linkedin.com/in/muzammil-aliba0406383
