
**Table of Content**
- [2023](#2023)
  - [02](#02)
    - [25](#25)
    - [26](#26)
    - [27](#27)

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

### 27
* Naming conventions
  * Sources
* 