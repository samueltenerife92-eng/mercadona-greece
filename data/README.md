
# Data Documentation

## Purpose

This folder documents the data sources and data-quality principles used in the Mercadona Greece Market Entry project.

## Data categories

### 1. City indicators

The database contains records for Athens, Thessaloniki, Patras and Heraklion.

Population figures are associated with the 2021 Greek census. The exact geographic boundaries and definitions should be checked before combining population, household and commercial-market measures.

### 2. Household expenditure

The 2025 ELSTAT Household Budget Survey reports average monthly household expenditure of €1,820.20 and a 20.4% share for food and non-alcoholic beverages.

A simple calculation gives:

`€1,820.20 × 20.4% = €371.32 per household per month` (rounded).

This is a national household-expenditure proxy. It is not a city-specific estimate, nor does it measure supermarket expenditure exclusively.

### 3. City-level market estimates

Some city-level income, grocery spending, rent and target-population values are preliminary assumptions.

They should be treated as unverified until each value has:
- a traceable source;
- a reference year;
- a geographic definition;
- a documented calculation method;
- a clear unit of measurement.

### 4. Competitor stores

The database includes competitor names and candidate store records.

Some records are illustrative examples. Other records have candidate addresses and coordinates that still require validation. A record's presence in the database does not mean its address or coordinates have been independently confirmed.

## Data status conventions

- `official_census_2021`: associated with a census reference; verify the underlying source and geographic scope.
- `pending_verification`: the input or methodology requires further validation.
- `pending_validation`: a store location or its coordinates require confirmation.
- `illustrative`: a synthetic example used to demonstrate the analytical workflow.
- `verified`: a database label that should not be interpreted as proof of coordinate-level validation on its own.

## Sources

- ELSTAT 2021 Census: https://www.statistics.gr/en/2021-census-res-pop-results
- ELSTAT Household Budget Survey 2024: https://www.statistics.gr/en/statistics/-/publication/SFA05/2024
- ELSTAT Household Budget Survey 2025: https://www.statistics.gr/documents/20181/18958813/DT_eop_2025_en.pdf/5f6cedd1-de1b-f227-f783-508c5976295b
- Eurostat: https://ec.europa.eu/eurostat/
- OpenStreetMap: https://www.openstreetmap.org/

## Responsible interpretation

Do not present broad household expenditure as Mercadona's serviceable market, market share or forecast revenue. Those estimates require additional evidence on catchment areas, shopper behaviour, competition, store format and operational feasibility.
