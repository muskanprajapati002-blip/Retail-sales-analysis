# Retail-Sales-Analysis
SQL analysis identifying why a $2.3M revenue business maintains only 12.47% profit margin , with 3 actionable recommendations.


# 🛒 Retail Superstore Sales Analysis
**Tools:** MySQL · Excel · Tableau
- Dashboard screenshot available on GitHub
**Dataset:** [Sample Superstore Dataset — Kaggle](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final)  
**Records Analyzed:** 9,994 orders · 4 years (2014–2017) · 3 categories · 4 regions

---

## 📌 Project Overview

This project analyzes 4 years of retail transaction data from a US-based superstore to uncover revenue trends, profitability gaps, and actionable business recommendations. The analysis was conducted entirely in MySQL, with visualizations built in Excel and Power BI.

**Core Business Question:**  
*The company generates $2.3M in revenue but where is it actually making money, and where is it silently losing it?*

---

## Repository Structure

```
retail-sales-analysis/
│
├── README.md                  ← You are here
├── sql/
│   ├── 1_create_and_load.sql  ← Database setup & data loading
│   ├── 2_data_cleaning.sql    ← Data validation & date transformation
│   └── 3_analysis.sql         ← 10 business analysis queries
├── data/
│   └── superstore.csv         ← Raw dataset
└── dashboard/
    └── superstore_dashboard.png  ← Power BI dashboard screenshot
```

---

## Technical Approach

### Data Loading & Cleaning
- Handled CSV encoding issues using `iconv` for UTF-8 conversion
- Loaded raw data preserving original date strings (ELT approach)
- Transformed date columns from `MM/DD/YYYY` to SQL `DATE` type using `STR_TO_DATE()`
- Used `DECIMAL(10,4)` precision for Sales and Profit to avoid truncation
- Validated 9,994 records loaded with 0 warnings after cleaning

### Analysis
- 10 business-focused SQL queries covering KPIs, trends, regional performance, customer segmentation, product profitability, and discount impact
- Used `GROUP BY`, `HAVING`, `CASE WHEN`, `STR_TO_DATE`, `DATEDIFF`, `COUNT(DISTINCT)` and window functions

---

## Key Findings

### 1. Overall Business Performance
| Metric | Value |
|--------|-------|
| Total Orders | 5,009 |
| Total Revenue | $2,297,200 |
| Total Profit | $286,397 |
| Profit Margin | 12.47% |

> A 12.47% overall margin is within healthy retail range — but the category breakdown reveals the real story.

---

### 2. Category Performance — Revenue ≠ Profit
| Category | Revenue | Profit | Margin |
|----------|---------|--------|--------|
| Technology | $836,154 | $145,455 | 17.40% |
| Office Supplies | $719,047 | $122,491 | 17.04% |
| Furniture | $741,999 | $18,451 | **2.49%** |

**Finding:** Furniture generates the second highest revenue but contributes almost nothing to profit. The company is investing significant resources in a low-return category. Technology and Office Supplies are the true profit engines.

---

### 3. Sub-Category Deep Dive — Hidden Losses
| Sub-Category | Revenue | Profit | Avg Discount |
|--------------|---------|--------|--------------|
| Copiers | $149,528 | $55,618 | Low |
| Accessories | $167,380 | $41,937 | Low |
| Tables | $206,966 | **-$17,725** | High |
| Bookcases | $114,880 | **-$3,473** | High |

**Finding:** Tables and Bookcases are loss-making despite significant sales volume. Copiers sell the least units but generate the highest profit — a textbook case of volume vs. value confusion.

---

### 4. Discount Impact on Profitability
| Discount Band | Orders | Profit Margin |
|---------------|--------|---------------|
| 0% Discount | 4,798 | **+29.51%** |
| 1–10% | 94 | +16.61% |
| 11–20% | 3,709 | +11.58% |
| 21–30% | 227 | **-10.05%** |
| Above 30% | 1,166 | **-48.16%** |

**Finding:** This is the most significant insight in the analysis. Products sold at 0% discount deliver a 29.51% margin, while products sold at above 30% discount deliver a **-48.16% margin** — meaning the company loses nearly half the sale value on heavily discounted items. Excessive discounting is the primary driver of unprofitability across Tables, Bookcases, and Machines.

---

### 5. Revenue Growth Trend (2014–2017)
| Year | Total Revenue | Growth |
|------|--------------|--------|
| 2014 | ~$484,000 | — |
| 2015 | ~$470,000 | -3% |
| 2016 | ~$609,000 | +30% |
| 2017 | ~$733,000 | +20% |

**Finding:** Strong 51% overall growth from 2014 to 2017. Clear seasonality pattern — Q4 (October–December) spikes every year. July consistently underperforms and even recorded negative profit in 2014.

---

### 6. Regional Performance
| Region | Revenue | Profit | Avg Order Value |
|--------|---------|--------|-----------------|
| West | $725,458 | $108,418 | $226 |
| East | $678,781 | $91,523 | $238 |
| Central | $501,240 | $39,706 | $216 |
| South | $391,722 | $46,749 | $242 |

**Finding:** Central region is the most inefficient — $501K revenue but only $39K profit (7.9% margin). South has the fewest orders but the highest average order value, indicating a premium customer base worth nurturing.

---

### 7. Customer Segment Analysis
| Segment | Customers | Revenue | Avg Order Value |
|---------|-----------|---------|-----------------|
| Consumer | 409 | $1,161,401 | $224 |
| Corporate | 236 | $706,146 | $234 |
| Home Office | 148 | $429,653 | $241 |

**Finding:** Home Office is the smallest segment but has the highest average order value. Corporate customers are stable and consistently profitable. Consumer segment drives volume but requires discount discipline.

---

### 8. Top 5 Most Profitable Customers
| Customer | Segment | Profit Generated | Orders |
|----------|---------|-----------------|--------|
| Tamara Chand | Corporate | $8,745 | 2 |
| Raymond Buch | Consumer | $6,807 | 2 |
| Adrian Barton | Consumer | $5,363 | 5 |
| Hunter Lopez | Consumer | $5,046 | 2 |
| Sanjit Chand | Consumer | $4,669 | 1 |

**Finding:** Top customers generate outsized profit from very few orders. Tamara Chand generated $8,745 from just 2 orders. Retaining these customers should be a top business priority.

---

## Business Recommendations

Based on the analysis, three recommendations would have the highest impact:

**1. Cap discounts at 20% company-wide**  
Products discounted above 20% consistently generate negative margins. Implementing a 20% discount ceiling would eliminate the -48% margin drag from the "Above 30%" band and significantly improve overall profitability.

**2. Review the Furniture category strategy**  
With a 2.49% margin, Furniture is consuming sales and operational resources for minimal return. Specifically, Tables and Bookcases are loss-making. The business should either reprice these products or reduce promotional spend on them.

**3. Invest in Q4 and address the July dip**  
September through December drives disproportionate revenue every year. Allocating more inventory and marketing budget to Q4 while introducing July-specific promotions (without deep discounts) would smooth revenue distribution.

---

## Tools & Skills Demonstrated

- **MySQL** — database creation, data loading, ELT pipeline, date transformation, aggregations, CASE statements, subqueries
- **Excel** — pivot tables, data export, chart creation
- **Power BI** — interactive dashboard with slicers for region, category, and year
- **Business Analysis** — KPI definition, profitability analysis, customer segmentation, trend analysis

---

## Author

**Muskan Prajapati**  
Aspiring Data Analyst | SQL · Tableau · Excel  
📧 muskanprajapati002@gmail.com  
🔗 [LinkedIn](https://www.linkedin.com/in/muskan-prajapati-6201b0231/)

---

*This project is part of my data analytics portfolio. Dataset sourced from Kaggle for educational purposes.*
