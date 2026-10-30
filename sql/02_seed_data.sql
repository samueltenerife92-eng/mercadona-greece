
-- Mercadona Greece: Initial Dataset
-- PostgreSQL
-- Market figures are estimates and require further validation.
-- Store records are candidates, not independently verified locations.

-- 1. Cities
INSERT INTO cities (city_name, region, data_status)
VALUES
    ('Athens', 'Attica', 'pending_verification'),
    ('Thessaloniki', 'Central Macedonia', 'pending_verification'),
    ('Patras', 'Western Greece', 'pending_verification'),
    ('Heraklion', 'Crete', 'pending_verification')
ON CONFLICT (city_name) DO NOTHING;

-- 2. Competitors
INSERT INTO competitors (competitor_name, market_positioning, website)
VALUES
    ('AB', 'Supermarket chain', 'https://www.ab.gr/'),
    ('Lidl', 'Discount supermarket', 'https://www.lidl-hellas.gr/'),
    ('Sklavenitis', 'Supermarket chain', 'https://www.sklavenitis.gr/'),
    ('Masoutis', 'Supermarket chain', 'https://www.masoutis.gr/')
ON CONFLICT (competitor_name) DO NOTHING;

-- 3. Market data for 2026
-- EUR 357 is a national-average proxy per household per month.
-- It is not a verified city-specific grocery spending figure.

INSERT INTO market_data (
    city_id,
    year,
    data_status,
    target_households,
    monthly_grocery_spend_per_household,
    estimated_monthly_rent,
    food_spend_data_level,
    food_spend_source
)
SELECT
    c.city_id,
    v.year,
    'pending_verification',
    v.target_households,
    v.monthly_spend,
    v.monthly_rent,
    'National-average proxy',
    'https://www.statistics.gr/en/2021-census-res-pop-results'
FROM (
    VALUES
        ('Athens', 2026, 320645::BIGINT, 357::NUMERIC, 12000::NUMERIC),
        ('Thessaloniki', 2026, 157507::BIGINT, 357::NUMERIC, 7000::NUMERIC),
        ('Patras', 2026, 91391::BIGINT, 357::NUMERIC, 3500::NUMERIC),
        ('Heraklion', 2026, 73197::BIGINT, 357::NUMERIC, 4000::NUMERIC)
) AS v(city_name, year, target_households, monthly_spend, monthly_rent)
JOIN cities AS c
    ON c.city_name = v.city_name
ON CONFLICT (city_id, year) DO NOTHING;

-- 4. Data sources
INSERT INTO data_sources (
    source_name,
    source_url,
    dataset_name,
    access_date,
    notes
)
VALUES
    (
        'Hellenic Statistical Authority (ELSTAT)',
        'https://www.statistics.gr/en/2021-census-res-pop-results',
        '2021 Population and Housing Census',
        CURRENT_DATE,
        'Primary source to consult for official population and household data.'
    ),
    (
        'The Agora Review / Econscope',
        'https://www.econscope-by-the-agora-review.com/will-fewer-people-mean-more-homes-to-go-around-in-greece/',
        'Secondary demographic discussion',
        CURRENT_DATE,
        'Secondary source; figures and definitions require independent validation.'
    ),
    (
        'AB Store Locator',
        'https://www.ab.gr/storelocator',
        'Candidate competitor locations',
        CURRENT_DATE,
        'Use to verify individual store details.'
    ),
    (
        'Lidl Greece Store Locator',
        'https://www.lidl-hellas.gr/s/el-GR/anazitisi-katastaton/',
        'Candidate competitor locations',
        CURRENT_DATE,
        'Use to verify individual store details.'
    ),
    (
        'Sklavenitis Store Directory',
        'https://www.sklavenitis.gr/about/katastimata/',
        'Candidate competitor locations',
        CURRENT_DATE,
        'Use to verify individual store details.'
    ),
    (
        'Masoutis',
        'https://www.masoutis.gr/',
        'Candidate competitor locations',
        CURRENT_DATE,
        'Company website; individual store details require verification.'
    );

-- 5. Candidate competitor stores
-- Coordinates are approximate. Check addresses and coordinates before
-- using the data for geographic or investment decisions.

INSERT INTO stores (
    store_name,
    city_id,
    competitor_id,
    store_type,
    data_status,
    address,
    latitude,
    longitude,
    source_url,
    data_notes
)
SELECT
    v.store_name,
    c.city_id,
    cp.competitor_id,
    'Supermarket',
    'candidate',
    v.address,
    v.latitude,
    v.longitude,
    v.source_url,
    v.data_notes
FROM (
    VALUES
    (
        'AB - Mitropoleos', 'Athens', 'AB',
        'Mitropoleos 72, Athens 105 63',
        37.976028::NUMERIC, 23.728048::NUMERIC,
        'https://www.ab.gr/storelocator',
        'Candidate location; independently verify address and coordinates.'
    ),
    (
        'Lidl - Liosion', 'Athens', 'Lidl',
        'Liosion 132-134, Athens 104 45',
        37.996000::NUMERIC, 23.721500::NUMERIC,
        'https://www.lidl-hellas.gr/s/el-GR/anazitisi-katastaton/',
        'Candidate location; independently verify address and coordinates.'
    ),
    (
        'Sklavenitis - Aitolias', 'Athens', 'Sklavenitis',
        'Aitolias 29 & Leof. Kifisias 7, Athens 115 23',
        37.993900::NUMERIC, 23.764800::NUMERIC,
        'https://www.sklavenitis.gr/about/katastimata/',
        'Candidate location; independently verify address and coordinates.'
    ),
    (
        'AB - Herodotou', 'Heraklion', 'AB',
        'Leof. Ikarou 26, Heraklion',
        35.338600::NUMERIC, 25.139400::NUMERIC,
        'https://www.ab.gr/storelocator',
        'Important: store name and address may not match; verify before use.'
    ),
    (
        'Lidl - Makariou', 'Heraklion', 'Lidl',
        'Leoforos Archiepiskopou Makariou 2, Heraklion 712 02',
        35.338480::NUMERIC, 25.124840::NUMERIC,
        'https://www.lidl-hellas.gr/s/el-GR/anazitisi-katastaton/',
        'Candidate location; independently verify address and coordinates.'
    ),
    (
        'Sklavenitis - Merkouri', 'Heraklion', 'Sklavenitis',
        'Melinas Merkouri 17, Heraklion 713 05',
        35.327800::NUMERIC, 25.127000::NUMERIC,
        'https://www.sklavenitis.gr/about/katastimata/',
        'Candidate location; independently verify address and coordinates.'
    ),
    (
        'AB - Akti Dymaion', 'Patras', 'AB',
        'Akti Dymaion & Eleftheriou Venizelou, Patras 265 00',
        38.231800::NUMERIC, 21.724700::NUMERIC,
        'https://www.ab.gr/storelocator',
        'Candidate location; independently verify address and coordinates.'
    ),
    (
        'Lidl - Ionias', 'Patras', 'Lidl',
        'Ionias 8, Patras 263 32',
        38.223600::NUMERIC, 21.718800::NUMERIC,
        'https://www.lidl-hellas.gr/s/el-GR/anazitisi-katastaton/',
        'Candidate location; independently verify address and coordinates.'
    ),
    (
        'Sklavenitis - Parnassou', 'Patras', 'Sklavenitis',
        'Parnassou 14-18, Patras 262 22',
        38.232340::NUMERIC, 21.727890::NUMERIC,
        'https://www.sklavenitis.gr/about/katastimata/',
        'Candidate location; independently verify address and coordinates.'
    ),
    (
        'Lidl - Olympiados', 'Thessaloniki', 'Lidl',
        'Olympiados 56, Thessaloniki 546 33',
        40.640816::NUMERIC, 22.949326::NUMERIC,
        'https://www.lidl-hellas.gr/s/el-GR/anazitisi-katastaton/',
        'Candidate location; independently verify address and coordinates.'
    ),
    (
        'Masoutis - Tsimiski', 'Thessaloniki', 'Masoutis',
        'Tsimiski 43, Plateia Shopping Centre, Thessaloniki 546 23',
        40.632200::NUMERIC, 22.942700::NUMERIC,
        'https://www.masoutis.gr/',
        'Candidate location; independently verify address and coordinates.'
    ),
    (
        'Sklavenitis - Lagkada', 'Thessaloniki', 'Sklavenitis',
        'Lagkada 11, Thessaloniki 546 29',
        40.644600::NUMERIC, 22.933800::NUMERIC,
        'https://www.sklavenitis.gr/about/katastimata/',
        'Candidate location; independently verify address and coordinates.'
    )
) AS v(
    store_name, city_name, competitor_name, address,
    latitude, longitude, source_url, data_notes
)
JOIN cities AS c
    ON c.city_name = v.city_name
JOIN competitors AS cp
    ON cp.competitor_name = v.competitor_name;

-- 6. Illustrative monthly operating scenarios
-- Market capture = 1% of the estimated entire city market.
-- This is a simplifying assumption, not a store-level forecast.

INSERT INTO store_business_scenarios (
    city_id,
    scenario_name,
    market_capture_rate,
    monthly_rent,
    monthly_staff_cost,
    monthly_logistics_cost,
    monthly_other_operating_cost,
    gross_margin_rate,
    notes
)
SELECT
    c.city_id,
    'Baseline illustrative',
    0.0100,
    v.monthly_rent,
    v.staff_cost,
    v.logistics_cost,
    v.other_cost,
    0.2500,
    'Illustrative assumptions only; not Mercadona actual financial data.'
FROM (
    VALUES
        ('Athens', 12000::NUMERIC, 30000::NUMERIC, 15000::NUMERIC, 10000::NUMERIC),
        ('Thessaloniki', 7000::NUMERIC, 28000::NUMERIC, 14000::NUMERIC, 9000::NUMERIC),
        ('Patras', 3500::NUMERIC, 22000::NUMERIC, 10000::NUMERIC, 7000::NUMERIC),
        ('Heraklion', 4000::NUMERIC, 22000::NUMERIC, 11000::NUMERIC, 7000::NUMERIC)
) AS v(city_name, monthly_rent, staff_cost, logistics_cost, other_cost)
JOIN cities AS c
    ON c.city_name = v.city_name;
