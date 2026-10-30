
-- Mercadona Greece: Market Analysis
-- Purpose: compare estimated grocery market size across selected cities.
-- Important: figures are preliminary estimates, not verified forecasts.

-- 1. Estimated monthly and annual grocery market by city
SELECT
    c.city_name,
    md.year,
    md.target_households,
    md.monthly_grocery_spend_per_household,
    md.target_households * md.monthly_grocery_spend_per_household
        AS estimated_monthly_market_eur,
    md.target_households * md.monthly_grocery_spend_per_household * 12
        AS estimated_annual_market_eur,
    md.data_status
FROM cities AS c
JOIN market_data AS md
    ON c.city_id = md.city_id
WHERE md.year = 2026
ORDER BY estimated_annual_market_eur DESC;

-- 2. Estimated monthly grocery spend by city
SELECT
    c.city_name,
    md.target_households,
    md.monthly_grocery_spend_per_household,
    md.target_households * md.monthly_grocery_spend_per_household
        AS estimated_monthly_market_eur
FROM cities AS c
JOIN market_data AS md
    ON c.city_id = md.city_id
WHERE md.year = 2026
ORDER BY estimated_monthly_market_eur DESC;

-- 3. Data quality check: identify estimates awaiting verification
SELECT
    c.city_name,
    md.year,
    md.data_status,
    md.food_spend_data_level,
    md.food_spend_source
FROM cities AS c
JOIN market_data AS md
    ON c.city_id = md.city_id
WHERE md.year = 2026
ORDER BY c.city_name;
