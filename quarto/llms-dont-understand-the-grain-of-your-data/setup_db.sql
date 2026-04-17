CREATE OR REPLACE TABLE orders AS
    SELECT *
    FROM read_csv_auto('csvs/olist_orders_dataset.csv');

CREATE OR REPLACE TABLE order_items AS
    SELECT *
    FROM read_csv_auto('csvs/olist_order_items_dataset.csv');

CREATE OR REPLACE TABLE payments AS
    SELECT *
    FROM read_csv_auto('csvs/olist_order_payments_dataset.csv');

CREATE OR REPLACE TABLE customers AS
    SELECT *
    FROM read_csv_auto('csvs/olist_customers_dataset.csv');

CREATE OR REPLACE TABLE products AS
    SELECT *
    FROM read_csv_auto('csvs/olist_products_dataset.csv');

CREATE OR REPLACE TABLE sellers AS
    SELECT *
    FROM read_csv_auto('csvs/olist_sellers_dataset.csv');

CREATE OR REPLACE TABLE geolocation AS
    SELECT *
    FROM read_csv_auto('csvs/olist_geolocation_dataset.csv');
