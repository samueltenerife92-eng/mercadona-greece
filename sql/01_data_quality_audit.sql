
-- 01_data_quality_audit.sql
-- Purpose: audit market inputs before using them in a business decision.

-- A. Review the market-data quality view.
SELECT *
FROM v_market_data_quality
ORDER BY city_id;

-- B. Inspect the raw market inputs.
SELECT
    c.city_name,
    md.year,
    md.average_monthly_household_income,
    md.estimated_monthly_grocery_spend,
    md.target_population,
    md.target_households,
    md.monthly_grocery_spend_per_household,
    md.estimated_monthly_rent,
    md.food_spend_data_level,
    md.food_spend_source,
    md.data_status
FROM market_data AS md
JOIN cities AS c
    ON c.city_id = md.city_id
ORDER BY c.city_name, md.year;

-- C. Flag missing or potentially problematic values.
SELECT
    c.city_name,
    md.year,
    CASE
        WHEN md.average_monthly_household_income IS NULL
            THEN 'Missing household income'
        ELSE 'Present: source still needs review'
    END AS income_check,
    CASE
        WHEN md.estimated_monthly_grocery_spend IS NULL
            THEN 'Missing grocery-spend estimate'
        ELSE 'Present: methodology still needs review'
    END AS grocery_spend_check,
    CASE
        WHEN md.target_population IS NULL OR md.target_population <= 0
            THEN 'Missing or invalid target population'
        ELSE 'Present: catchment definition needs review'
    END AS target_population_check,
    CASE
        WHEN md.target_households IS NULL OR md.target_households <= 0
            THEN 'Missing or invalid household count'
        ELSE 'Present: geographic scope needs review'
    END AS household_count_check,
    CASE
        WHEN md.estimated_monthly_rent IS NULL
            THEN 'Missing rent estimate'
        ELSE 'Present: unit and property type need review'
    END AS rent_check,
    md.data_status
FROM market_data AS md
JOIN cities AS c
    ON c.city_id = md.city_id
ORDER BY c.city_name;

-- D. Summarize records by data status.
SELECT
    data_status,
    COUNT(*) AS record_count
FROM market_data
GROUP BY data_status
ORDER BY record_count DESC;

-- E. Review source documentation.
SELECT
    source_id,
    source_name,
    source_url,
    dataset_name,
    access_date,
    notes
FROM data_sources
ORDER BY source_id;
