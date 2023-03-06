
**Table of Content**
- [2023](#2023)
  - [02](#02)
    - [25](#25)
    - [26](#26)
  - [03](#03)
    - [05](#05)

**Reference**
- dbt Fundamentals [[*link*]](https://courses.getdbt.com/courses/fundamentals)

# 2023

## 02

### 25
* ELT vs. ETL, dbt being the T
* source --> loader --> data platform --> transformation ...
* `dbt run` build the model following the DAG
* `dbt test` test the model
* `dbt docs generate` build the doc site
* For BigQuery test, need to set up BigQuery and dbt cloud account following instructions [here](https://docs.getdbt.com/docs/get-started/getting-started/getting-set-up/setting-up-bigquery)
* `yaml` files are for tests and documentations

### 26
* You can click `+` sign in dbt cloud IDE to create a new file to run a sql query or a dbt code (mixed with Jinja code)). `Preview` will show you the expected result of the code, `Compile` will show you the detailed steps `dbt` followed to get the output.
  * `Preview` doesn't do any materialization
* You can activate the keyboard shortcuts by typing `__` (double underscores)
* `Modeling`: raw data --> transformed data
* Models live in the `models` directory in the dbt project
  * Each model has a 1:1 relationship with a table or view in the data warehouse
  * `dbt` handles the DDL/DML, you just need to configure it either at the top of the sql file or in a separate `yaml` file on how you want to build the data model
* `dbt run` would rebuild all models. To only rebuild a specific model, run `dbt run --select <model_name_without_dot_sql>`. Previous output (view or table) will all be cleaned in every rebuild.
* The suggested approach is to build model modularly
  * Build a set of atomic models and reassemble, and the atomic models could also be reused in other future models
* The `ref` function help reference any "materialized" (view or table) models in the data warehouse and build the dependencies across different data models
    ```sql
    with customers as (

        select * from {{ ref('stg_customers') }}

    )
    ```
  * `Compile` will show the actual referencing logic (with the actual table/view names)

## 03
### 05
* Naming conventions
  * `Sources` (tables)- ways to reference the raw data in data warehouse
  * `Staging` (models) - one to one with the source tables, rename columns and rename columns, etc.
  * `Intermediate` (models) - always built on staging
  * `Fact` (models)
  * `Dimension` (models)
* Organize the project
  * Add folders under `models` - `staging` and `marts`
    * `staging` contains staging
      * All staging models and source configurations can be stored here. Further subfolders can be used to separate data by data source (e.g. Stripe, Segment, Salesforce)
    * `marts` contains the final models
      * All `intermediate`, `fact`, and `dimension` models can be stored here. Further subfolders can be used to separate data by business function (e.g. marketing, finance)
  * If `dbt run -s staging` will run all models that exist in `models/staging`.
  * Default materialization is `view`
  * Define `materialized` option in `dbt_project.yml` by the folder structures under `models`
    ```yaml
    models:
      jaffle_shop:
        marts:
          core:
            +materialized: table
        staging:
          +materialized: view
    ```
  * `dbt run --select dim_customers+` will attempt to only materialize dim_customers and its downstream models.
  * You could define `sources` in yaml and reference them using the `source(schema, table)` pattern in `staging` models
    * The yaml could stay under the `staging` subfolders and here is an example (with a freshness check included)
      ```yaml
      version: 2

      sources:
        - name: jaffle_shop
          database: "dbt-tutorial"
          schema: jaffle_shop
          tables:
            - name: customers
            - name: orders
              loaded_at_field: _etl_loaded_at
              freshness:
                warn_after: {count: 12, period: hour}
                error_after: {count: 24, period: hour}    
      ```
  * `dbt source freshness` can be used to check the freshness status
  *  