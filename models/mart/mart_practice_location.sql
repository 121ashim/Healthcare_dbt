{{ config(materialized='table') }}

SELECT
    ENRLMT_ID,
    CITY_NAME,
    STATE_CD,
    ZIP_CD
FROM {{ ref('stg_practice_location') }}