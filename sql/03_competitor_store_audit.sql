
-- 03_competitor_store_audit.sql
-- Purpose: audit competitor-store records and location confidence.

-- A. Summary of store records by city and data status.
SELECT
    c.city_name,
    s.data_status,
    s.coordinate_status,
    COUNT(*) AS store_records
FROM stores AS s
JOIN cities AS c
    ON c.city_id = s.city_id
GROUP BY
    c.city_name,
    s.data_status,
    s.coordinate_status
ORDER BY
    c.city_name,
    s.data_status,
    s.coordinate_status;

-- B. Inspect all records requiring attention.
SELECT
    c.city_name,
    s.store_name,
    comp.competitor_name,
    s.address,
    s.latitude,
    s.longitude,
    s.data_status,
    s.coordinate_status,
    s.verification_date,
    s.source_url,
    s.data_notes
FROM stores AS s
JOIN cities AS c
    ON c.city_id = s.city_id
LEFT JOIN competitors AS comp
    ON comp.competitor_id = s.competitor_id
WHERE
    s.data_status = 'illustrative'
    OR s.coordinate_status IS DISTINCT FROM 'validated'
    OR s.verification_date IS NULL
ORDER BY c.city_name, comp.competitor_name, s.store_name;

-- C. Review the existing competitor analysis view.
-- Note: this view may include records labelled 'verified' even when
-- their coordinates are still pending validation.
SELECT *
FROM v_competitor_stores_analysis
ORDER BY city_name, competitor_name, store_name;

-- D. Count records that are candidates for factual analysis.
-- This deliberately excludes illustrative records and requires
-- validated coordinates.
SELECT
    c.city_name,
    comp.competitor_name,
    COUNT(*) AS location_validated_store_count
FROM stores AS s
JOIN cities AS c
    ON c.city_id = s.city_id
LEFT JOIN competitors AS comp
    ON comp.competitor_id = s.competitor_id
WHERE s.data_status = 'verified'
  AND s.coordinate_status = 'validated'
  AND s.verification_date IS NOT NULL
GROUP BY c.city_name, comp.competitor_name
ORDER BY c.city_name, comp.competitor_name;
