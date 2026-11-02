
# Mercadona Greece Market Entry Analysis

## Project overview

This portfolio project explores how a Spanish grocery retailer such as Mercadona could evaluate a potential entry into the Greek market.

Using PostgreSQL, the project organizes market indicators, competitor-store records, data sources and illustrative financial scenarios to support an initial market-entry assessment.

The analysis focuses on four Greek cities:

- Athens
- Thessaloniki
- Patras
- Heraklion

## Business questions

1. Which cities should be prioritized for further market research?
2. What do available household and population indicators suggest about the potential grocery market?
3. How is the existing supermarket landscape represented in the current dataset?
4. What operating assumptions would influence the break-even point of a hypothetical store?
5. Which data gaps must be resolved before making an investment recommendation?

## Tools

- PostgreSQL
- SQL
- GitHub
- Public statistical sources and retailer store pages

## Analytical approach

The project follows five steps:

1. Audit data quality and identify unverified assumptions.
2. Estimate a broad grocery-expenditure proxy from household counts and an expenditure benchmark.
3. Review the competitor-store dataset and its verification status.
4. Calculate illustrative store break-even scenarios.
5. Summarize limitations and the additional evidence required for a market-entry decision.

## Data sources

The project references public sources including:

- [ELSTAT — 2021 Population and Housing Census](https://www.statistics.gr/en/2021-census-res-pop-results)
- [ELSTAT — Household Budget Survey 2024](https://www.statistics.gr/en/statistics/-/publication/SFA05/2024)
- [ELSTAT — Household Budget Survey 2025](https://www.statistics.gr/documents/20181/18958813/DT_eop_2025_en.pdf/5f6cedd1-de1b-f227-f783-508c5976295b)
- [Eurostat](https://ec.europa.eu/eurostat/)
- [OpenStreetMap](https://www.openstreetmap.org/)

The project records source references, but not every city-level estimate or store coordinate has been independently verified.

## Important limitations

This is a preliminary analytical model, not an official Mercadona feasibility study.

- Several city-level income, rent, grocery-spending and target-population inputs remain pending verification.
- The household expenditure benchmark is a national proxy, not a city-specific supermarket-spending estimate.
- Total municipal grocery expenditure is not the same as a store's addressable market or expected revenue.
- Competitor records with approximate coordinates must not be treated as fully location-verified.
- Store financial scenarios use illustrative assumptions and are not Mercadona operating data.
- The break-even calculation excludes some potential costs, including capital expenditure, depreciation, financing and taxes.

No actual Mercadona expansion decision, store forecast or financial result is claimed.


## How to run

1. Create the database and tables in PostgreSQL.
2. Load the source records into the relevant tables.
3. Run the SQL scripts in numerical order.
4. Review all `REVIEW`, `pending_verification` and `pending_validation` statuses before drawing conclusions.

## Intended business value

The project demonstrates how SQL can help structure a market-entry investigation, compare locations, assess data reliability, identify competitor coverage and test operating assumptions before a business commits resources.

## Next steps

- Validate household counts against the exact census geography.
- Replace estimates with documented, comparable city-level indicators.
- Verify individual competitor locations and remove illustrative records from factual analyses.
- Improve the model using realistic store catchments, competition intensity, capital expenditure and operating-cost assumptions.
- Develop a transparent city-ranking methodology once the required inputs are validated.
