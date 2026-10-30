
-- 02_market_size_proxy.sql
-- Purpose: estimate a broad municipal household food-expenditure proxy.
-- Warning: this is NOT supermarket-only expenditure, addressable market,
-- expected store sales, or a revenue forecast.

SELECT
    c.city_name,
    md.year,
    md.target_households,
    md.monthly_grocery_spend_per_household AS national_monthly_food_proxy_eur,

    ROUND(
        md.target_households::numeric
        * md.monthly_grocery_spend_per_household,
        2
    ) AS estimated_monthly_household_food_proxy_eur,

    ROUND(
        md.target_households::numeric
        * md.monthly_grocery_spend_per_household
        * 12,
        2
    ) AS estimated_annual_household_food_proxy_eur,

    md.data_status,

    'National household proxy; not a city-specific supermarket sales estimate'
        AS interpretation

FROM market_data AS md
JOIN cities AS c
    ON c.city_id = md.city_id

WHERE md.target_households IS NOT NULL
  AND md.monthly_grocery_spend_per_household IS NOT NULL

ORDER BY estimated_annual_household_food_proxy_eur DESC;
