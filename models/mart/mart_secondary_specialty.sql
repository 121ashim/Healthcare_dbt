{{ config(materialized='table') }}

SELECT *
FROM {{ ref('stg_secondary_specialty') }}