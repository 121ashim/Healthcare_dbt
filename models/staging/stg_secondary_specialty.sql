{{ config(materialized='view') }}

WITH typed AS (

    SELECT
        CAST(ENRLMT_ID AS STRING) AS ENRLMT_ID,
        CAST(PROVIDER_TYPE_CD AS STRING) AS PROVIDER_TYPE_CD,
        CAST(PROVIDER_TYPE_DESC AS STRING) AS PROVIDER_TYPE_DESC
    FROM `healthcare-medicare.raw.secondary_specialty`

),

trimmed AS (

    SELECT
        TRIM(ENRLMT_ID) AS ENRLMT_ID,
        TRIM(PROVIDER_TYPE_CD) AS PROVIDER_TYPE_CD,
        TRIM(PROVIDER_TYPE_DESC) AS PROVIDER_TYPE_DESC
    FROM typed

)

SELECT *
FROM trimmed