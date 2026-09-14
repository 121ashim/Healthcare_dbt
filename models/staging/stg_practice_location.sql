{{ config(materialized='view') }}

WITH typed AS (

    SELECT
        CAST(ENRLMT_ID AS STRING) AS ENRLMT_ID,
        CITY_NAME,
        STATE_CD,
        CAST(ZIP_CD AS STRING) AS ZIP_CD
    FROM `healthcare-medicare.raw.practice_location`

),

trimmed AS (

    SELECT
        TRIM(ENRLMT_ID) AS ENRLMT_ID,
        TRIM(CITY_NAME) AS CITY_NAME,
        TRIM(STATE_CD) AS STATE_CD,
        TRIM(ZIP_CD) AS ZIP_CD
    FROM typed

)

SELECT *
FROM trimmed