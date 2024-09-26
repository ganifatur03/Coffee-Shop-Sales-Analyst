# Coffee Shop Sales Data Processing

## Introduction

This project contains SQL scripts for processing and analyzing coffee shop sales data. The primary goal is to clean the data, ensuring it is in a structured and usable format, and to generate key performance indicators (KPIs) that help track the business's performance over time.

## Table of Contents

- [Introduction](#introduction)
- [Usage](#usage)
- [Features](#features)
- [Configuration](#configuration)
- [Troubleshooting](#troubleshooting)


## Usage

### Data Cleansing (`Data Cleansing.sql`)

This script prepares the `coffee_shop_sales` data by:
- Converting `transaction_date` and `transaction_time` columns from string formats to `DATE` and `TIME`.
- Ensuring `unit_price` is correctly formatted as a `DOUBLE` by replacing commas with periods.
- Modifying columns like `store_id` and `transaction_id` to appropriate data types.

### KPI Calculation (`KPI Requirement.sql`)

This script calculates key performance indicators, such as:
- Total sales for a specific month.
- Month-over-month (MoM) sales growth in percentage.

## Features

- **Data Cleaning**: Converts improperly formatted data into usable formats (dates, times, prices).
- **KPI Calculation**: Provides insights into sales trends, including total monthly sales and month-over-month growth.

## Configuration

No additional configuration is required for the SQL scripts, but they assume the `coffee_shop_sales` table is available and contains the following columns:
- `transaction_date`: The date of each transaction (in `%d/%m/%Y` format).
- `transaction_time`: The time of each transaction (in `%H:%i:%s` format).
- `unit_price`: The price per unit (formatted with commas).
- `transaction_qty`: The quantity of items sold.
- `store_id`: An integer identifying the store.

## Troubleshooting
- Ensure the date formats in your dataset match the expected formats (%d/%m/%Y for dates and %H:%i:%s for times).
- Verify that the unit_price column uses periods for decimal points, not commas.
