# Airbnb End-to-End Data Engineering Pipeline

A data engineering project for transforming Airbnb listings, bookings, and host data using Snowflake, dbt, SQL, and AWS S3.

## Architecture

```text
Airbnb CSV Source Data
          |
          v
        AWS S3
          |
          v
   Snowflake Staging
          |
          v
     Bronze Models
          |
          v
     Silver Models
          |
          v
      Gold Models
   Fact Tables / OBT
          |
          v
 Analytics and Reporting
```

The S3-to-Snowflake ingestion mechanism (for example, a stage and `COPY INTO`) should be documented once configured in this repository.

## Technology Stack

- **Cloud data warehouse:** Snowflake
- **Transformation and modelling:** dbt Core
- **Cloud object storage:** AWS S3
- **Languages and templating:** SQL, Python, Jinja
- **Version control:** Git
- **Testing and documentation:** dbt tests and dbt docs

## Source Datasets

- `listings.csv` — property listing information
- `bookings.csv` — booking transactions
- `hosts.csv` — host information

Load the files into Snowflake staging tables before running downstream models.

## Medallion Architecture

### Bronze — Raw data
Preserve source data with minimal transformations in models such as:
- `bronze_bookings`
- `bronze_hosts`
- `bronze_listings`

### Silver — Cleaned data
Standardize types and values, handle invalid or missing data, apply documented business rules, and prepare reliable datasets:
- `silver_bookings`
- `silver_hosts`
- `silver_listings`

### Gold — Analytics-ready data
Build downstream models for analysis:
- `fact` — fact-oriented analytical model
- `obt` — denormalized table joining relevant bookings, listings, and host attributes
- Ephemeral models — intermediate transformations compiled into dependent models



### Incremental models
Process new or changed data without rebuilding every target table. Implementation should account for late-arriving records, updates, timestamp ties, and unique keys.

### SCD Type 2 snapshots
Track historical changes to selected records with dbt snapshots. Planned snapshot files:
- `dim_bookings`
- `dim_hosts`
- `dim_listings`

Snapshot strategy and configuration will be documented after implementation and testing.

### Reusable macros
Centralize repeated SQL logic, such as price categorization, string trimming, arithmetic expressions, and schema naming.

### Data quality
Planned tests include:
- Unique and not-null checks
- Referential integrity checks
- Source-data validation
- Custom business-rule tests

### Lineage and documentation
Use dbt model dependencies and generated documentation to explain upstream sources, downstream impacts, and model relationships.

## Repository Structure

```text
airbnb-snowflake-dbt-pipeline/
├── README.md
├── SourceData/
├── DDL/
├── pyproject.toml
└── aws_dbt_snowflake_project/
    ├── dbt_project.yml
    ├── models/
    │   ├── sources/
    │   ├── bronze/
    │   ├── silver/
    │   └── gold/
    ├── macros/
    ├── snapshots/
    ├── tests/
    ├── analyses/
    └── seeds/
```

Empty folders contain `.gitkeep` files until implementation files are added.

## Setup Plan

1. Install Python and a compatible dbt Core / dbt Snowflake adapter version.
2. Configure Snowflake account access, database, warehouse, schemas, and a least-privilege role.
3. Configure credentials through environment variables or an approved secrets manager.
4. Create staging tables and load the CSV source datasets.
5. Configure the dbt profile to match `profile:` in `dbt_project.yml`.
6. Validate connectivity using `dbt debug`.
7. Implement and run Bronze, Silver, and Gold models.
8. Add tests and snapshots, then validate the results.
9. Generate dbt documentation and review model lineage.

## Useful dbt Commands

```bash
dbt debug
dbt deps
dbt run
dbt test
dbt snapshot
dbt build
dbt docs generate
dbt docs serve
```
## References

- dbt documentation: https://docs.getdbt.com/
- Snowflake documentation: https://docs.snowflake.com/
- dbt best practices: https://docs.getdbt.com/guides/best-practices
