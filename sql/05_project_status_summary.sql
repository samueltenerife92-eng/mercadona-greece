
-- 05_project_status_summary.sql
-- Purpose: summarize the current database coverage and outstanding checks.

-- A. City coverage.
SELECT
    COUNT(*) AS city_count
FROM cities;

-- B. Market-data coverage and verification status.
SELECT
    COUNT(*) AS market_data_records,
    COUNT(*) FILTER (
        WHERE data_status = 'pending_verification'
    ) AS pending_verification_records,
    COUNT(*) FILTER (
        WHERE average_monthly_household_income IS NULL
    ) AS missing_income_records,
    COUNT(*) FILTER (
        WHERE estimated_monthly_grocery_spend IS NULL
    ) AS missing_grocery_spend_records,
    COUNT(*) FILTER (
        WHERE target_households IS NULL
    ) AS missing_household_count_records
FROM market_data;

-- C. Competitor-store status.
SELECT
    COUNT(*) AS total_store_records,
    COUNT(*) FILTER (
        WHERE data_status = 'illustrative'
    ) AS illustrative_records,
    COUNT(*) FILTER (
        WHERE coordinate_status = 'pending_validation'
    ) AS coordinates_pending_validation,
    COUNT(*) FILTER (
        WHERE verification_date IS NULL
    ) AS records_without_verification_date
FROM stores;

-- D. Registered data sources.
SELECT
    COUNT(*) AS registered_sources
FROM data_sources;

-- E. Review the project's data-quality assessment.
SELECT *
FROM v_market_data_quality
ORDER BY city_id;
