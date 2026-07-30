E-Commerce Funnel & Revenue Analysis (BigQuery / SQL)
Overview

An end-to-end SQL analysis of a simulated e-commerce event dataset, built in Google BigQuery. The project traces user behavior through a 5-stage purchase funnel — page view → add to cart → checkout start → payment info → purchase — to identify where users drop off, which acquisition channels convert best, and how funnel performance translates into revenue.

The goal was to move beyond simple aggregation and produce analysis a stakeholder could act on: specific, prioritized recommendations tied to conversion and revenue data.

What's in this project
funnel_analysis.sql — six queries covering:
Funnel stage counts — distinct users reaching each funnel stage
Stage-to-stage conversion rates — where the biggest drop-offs occur
Funnel by traffic source — conversion performance broken out by acquisition channel
Time-to-conversion — average time (in minutes) users take to move from view → cart → purchase
Revenue funnel analysis — average order value, revenue per buyer, and revenue per visitor
recommendations.md — business recommendations derived from the analysis, covering UX, marketing spend allocation, and financial guardrails
Key techniques
CTEs (WITH clauses) to structure multi-stage aggregation logic
Conditional aggregation (COUNT(DISTINCT CASE WHEN ...)) to pivot event-level data into per-stage funnel counts without multiple joins or subqueries
TIMESTAMP_DIFF for user-level journey timing analysis
Derived metrics (conversion rates, AOV, revenue per visitor) calculated from aggregated CTEs rather than raw event rows
Sample findings
Checkout-to-purchase conversion was strong (~80%+), indicating the payment flow itself wasn't a bottleneck worth re-engineering
Social media drove the highest traffic volume but the lowest conversion rate, while email converted more than 2x as effectively
Average order value (~$115) was used to set a data-informed ceiling on acceptable customer acquisition cost by channel
Tools

Google BigQuery (Standard SQL)

Why this project

Built to practice translating raw event data into funnel and revenue metrics that support real marketing and product decisions — the kind of upstream, decision-oriented analysis that sits between data and strategy.
