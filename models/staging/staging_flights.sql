{{ config(materialized='view') }}

WITH source_data AS (
    SELECT * 
    FROM {{ source('project_data', 'flights_all') }}
)

SELECT *
FROM source_data