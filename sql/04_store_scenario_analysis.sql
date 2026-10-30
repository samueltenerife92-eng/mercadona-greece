
-- 04_store_scenario_analysis.sql
-- Purpose: calculate illustrative monthly operating break-even sales.
-- All assumptions below are hypothetical, not Mercadona operating data.
-- Excludes capital expenditure, taxes, financing, depreciation and
-- other potentially relevant costs.

WITH illustrative_assumptions AS (
    SELECT *
    FROM (
        VALUES
            ('Athens',       12000::numeric, 30000::numeric,
             15000::numeric, 10000::numeric, 0.25::numeric),
            ('Thessaloniki',  7000::numeric, 28000::numeric,
             14000::numeric,  9000::numeric, 0.25::numeric),
            ('Patras',        3500::numeric, 22000::numeric,
             10000::numeric,  7000::numeric, 0.25::numeric),
            ('Heraklion',     4000::numeric, 22000::numeric,
             11000::numeric,  7000::numeric, 0.25::numeric)
    ) AS v(
        city_name,
        monthly_rent_eur,
        monthly_staff_cost_eur,
        monthly_logistics_cost_eur,
        monthly_other_costs_eur,
        gross_margin_rate
    )
),
cost_calculation AS (
    SELECT
        *,
        monthly_rent_eur
        + monthly_staff_cost_eur
        + monthly_logistics_cost_eur
        + monthly_other_costs_eur AS monthly_operating_costs_eur
    FROM illustrative_assumptions
)
SELECT
    city_name,
    monthly_rent_eur,
    monthly_staff_cost_eur,
    monthly_logistics_cost_eur,
    monthly_other_costs_eur,
    monthly_operating_costs_eur,
    gross_margin_rate,
    ROUND(
        monthly_operating_costs_eur / NULLIF(gross_margin_rate, 0),
        2
    ) AS illustrative_monthly_break_even_sales_eur,
    'Illustrative scenario only; not a verified business forecast'
        AS scenario_status
FROM cost_calculation
ORDER BY illustrative_monthly_break_even_sales_eur;
