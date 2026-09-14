{{ config(materialized='view') }}

WITH typed AS (

    SELECT
        CAST(EASGN_BNFT_ENRLMT_ID AS STRING) AS EASGN_BNFT_ENRLMT_ID,
        CAST(RCV_BNFT_ENRLMT_ID AS STRING) AS RCV_BNFT_ENRLMT_ID
    FROM `healthcare-medicare.raw.reassignment`

),

trimmed AS (

    SELECT
        TRIM(EASGN_BNFT_ENRLMT_ID) AS EASGN_BNFT_ENRLMT_ID,
        TRIM(RCV_BNFT_ENRLMT_ID) AS RCV_BNFT_ENRLMT_ID
    FROM typed

)

SELECT *
FROM trimmed