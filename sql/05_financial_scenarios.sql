
-- Mercadona Greece: Illustrative Financial Scenarios
-- These are assumptions for a portfolio case study, not company forecasts.
-- Simplified model: one hypothetical store per city.
-- Excludes capex, tax, financing, depreciation and other potential costs.

-- 1. Break-even sales required to cover monthly operating costs
SELECT
    c.city_name,
    s.scenario_name,
    s.monthly_rent,
    s.monthly_staff_cost,
    s.monthly_logistics_cost,
    s.monthly_other_operating_cost,
    (
        s.monthly_rent
        + s.monthly_staff_cost
        + s.monthly_logistics_cost
        + s.monthly_other_operating_cost
    ) AS total_monthly_operating_costs,
    s.gross_margin_rate,
    ROUND(
        (
            s.monthly_rent
            + s.monthly_staff_cost
            + s.monthly_logistics_cost
            + s.monthly_other_operating_cost
        ) / NULLIF(s.gross_margin_rate, 0),
        2
    ) AS break_even_monthly_sales
FROM store_business_scenarios AS s
JOIN cities AS c
    ON s.city_id = c.city_id
ORDER BY break_even_monthly_sales ASC;

-- 2. Illustrative monthly operating result at the assumed market capture rate
SELECT
    c.city_name,
    s.scenario_name,
    s.market_capture_rate,
    md.target_households
        * md.monthly_grocery_spend_per_household
        AS estimated_city_monthly_market,
    ROUND(
        (
            md.target_households
            * md.monthly_grocery_spend_per_household
            * s.market_capture_rate
        )::numeric,
        2
    ) AS illustrative_monthly_sales,
    ROUND(
        (
            md.target_households
            * md.monthly_grocery_spend_per_household
            * s.market_capture_rate
            * s.gross_margin_rate
        )::numeric,
        2
    ) AS illustrative_gross_profit,
    (
        s.monthly_rent
        + s.monthly_staff_cost
        + s.monthly_logistics_cost
        + s.monthly_other_operating_cost
    ) AS total_monthly_operating_costs,
    ROUND(
        (
            md.target_households
            * md.monthly_grocery_spend_per_household
            * s.market_capture_rate
            * s.gross_margin_rate
            - s.monthly_rent
            - s.monthly_staff_cost
            - s.monthly_logistics_cost
            - s.monthly_other_operating_cost
        )::numeric,
        2
    ) AS illustrative_monthly_result
FROM store_business_scenarios AS s
JOIN cities AS c
    ON s.city_id = c.city_id
JOIN market_data AS md
    ON md.city_id = c.city_id
   AND md.year = 2026
ORDER BY illustrative_monthly_result DESC;

-- 3. Required share of the estimated city market to reach break-even
SELECT
    c.city_name,
    ROUND(
        (
            (
                s.monthly_rent
                + s.monthly_staff_cost
                + s.monthly_logistics_cost
                + s.monthly_other_operating_cost
            ) / NULLIF(s.gross_margin_rate, 0)
        )::numeric,
        2
    ) AS break_even_monthly_sales,
    ROUND(
        (
            (
                (
                    s.monthly_rent
                    + s.monthly_staff_cost
                    + s.monthly_logistics_cost
                    + s.monthly_other_operating_cost
                ) / NULLIF(s.gross_margin_rate, 0)
            )
            /
            NULLIF(
                md.target_households
                * md.monthly_grocery_spend_per_household,
                0
            )
            * 100
        )::numeric,
        4
    ) AS required_city_market_share_pct
FROM store_business_scenarios AS s
JOIN cities AS c
    ON s.city_id = c.city_id
JOIN market_data AS md
    ON md.city_id = c.city_id
   AND md.year = 2026
ORDER BY required_city_market_share_pct ASC;
