
-- Mercadona Greece: Competitor Analysis
-- Purpose: analyze the sample of supermarket locations.
-- Distances are straight-line estimates based on coordinates.
-- Illustrative records are excluded.

-- 1. Number of candidate stores by city and competitor
SELECT
    c.city_name,
    cp.competitor_name,
    COUNT(*) AS candidate_store_count
FROM stores AS s
JOIN cities AS c
    ON s.city_id = c.city_id
JOIN competitors AS cp
    ON s.competitor_id = cp.competitor_id
WHERE s.data_status IN ('candidate', 'verified')
GROUP BY
    c.city_name,
    cp.competitor_name
ORDER BY
    c.city_name,
    candidate_store_count DESC,
    cp.competitor_name;

-- 2. Candidate store sample by city
SELECT
    c.city_name,
    COUNT(*) AS candidate_store_count,
    COUNT(DISTINCT s.competitor_id) AS competitors_represented
FROM stores AS s
JOIN cities AS c
    ON s.city_id = c.city_id
WHERE s.data_status IN ('candidate', 'verified')
GROUP BY c.city_name
ORDER BY candidate_store_count DESC, c.city_name;

-- 3. Approximate straight-line distance between stores
-- Haversine formula; output is in kilometres.
SELECT
    s1.store_name AS store_1,
    cp1.competitor_name AS competitor_1,
    c1.city_name,
    s2.store_name AS store_2,
    cp2.competitor_name AS competitor_2,
    ROUND(
        (
            6371 * 2 * ASIN(
                SQRT(
                    POWER(SIN(RADIANS(s2.latitude - s1.latitude) / 2), 2)
                    + COS(RADIANS(s1.latitude))
                    * COS(RADIANS(s2.latitude))
                    * POWER(SIN(RADIANS(s2.longitude - s1.longitude) / 2), 2)
                )
            )
        )::numeric,
        2
    ) AS distance_km
FROM stores AS s1
JOIN stores AS s2
    ON s1.city_id = s2.city_id
   AND s1.store_id < s2.store_id
JOIN cities AS c1
    ON s1.city_id = c1.city_id
JOIN competitors AS cp1
    ON s1.competitor_id = cp1.competitor_id
JOIN competitors AS cp2
    ON s2.competitor_id = cp2.competitor_id
WHERE s1.data_status IN ('candidate', 'verified')
  AND s2.data_status IN ('candidate', 'verified')
  AND s1.latitude IS NOT NULL
  AND s1.longitude IS NOT NULL
  AND s2.latitude IS NOT NULL
  AND s2.longitude IS NOT NULL
  AND s1.competitor_id <> s2.competitor_id
ORDER BY distance_km ASC;
