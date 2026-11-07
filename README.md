# Marketing Data Platform with Databricks & dbt Core

## Project Overview

This project implements a unified marketing analytics platform
for Facebook Ads and Snapchat Ads.

The goal is to ingest advertising data into Databricks,
transform it using dbt Core, and provide reliable analytical
models for reporting and downstream consumption.

## Technology Stack

- Databricks
- Unity Catalog
- Databricks SQL Warehouse
- dbt Core
- dbt-databricks
- uv (Python dependency management)
- Elementary (planned)
- GitHub Actions (planned)

## Data Sources

The assignment provides nine CSV datasets:

### Facebook Ads
- ads_stats.csv
- new_acccount_de_randomized.csv
- new_adgroup_de_randomized.csv
- new_ads_de_randomized.csv
- new_campaign_de_randomized.csv

### Snapchat Ads
- snapchat_ads_stats.csv
- snapchat_ads_ad_history_new_ad_names.csv
- snapchat_ads_adgroup_history_new_ad_group_names.csv
- snapchat_ads_campaign_history_new_campaign_names.csv

Raw CSV files are excluded from version control.

## Planned Architecture

CSV Sources
    |
    v
Databricks Bronze Layer
    |
    v
dbt Staging Models
    |
    v
dbt Intermediate Models
    |
    v
Unified Marketing Fact Model
    |
    v
SQL / BI / Analytics / AI Consumers

## Environments

The intended Unity Catalog structure is:

- marketing_dev
- marketing_ci
- marketing_prod

Each environment will have dedicated schemas for its
transformation models.

Production authentication will use a Databricks
Service Principal.

## Local Development

Install uv:

https://docs.astral.sh/uv/

Install project dependencies:

    uv sync --frozen

Verify dbt installation:

    uv run dbt --version

## Current Implementation Status

Completed:
- Local project initialization
- uv dependency management
- dbt Core installation
- Databricks adapter installation
- Raw dataset organization
- Databricks SQL Warehouse access verification
- Unity Catalog discovery

Pending:
- Dedicated Unity Catalog setup
- Bronze ingestion
- dbt project and models
- Automated data quality tests
- Documentation and lineage
- Elementary observability
- CI/CD
- Production Service Principal authentication

## Official Documentation

- https://docs.getdbt.com/
- https://docs.databricks.com/
- https://docs.astral.sh/uv/
- https://docs.elementary-data.com/
