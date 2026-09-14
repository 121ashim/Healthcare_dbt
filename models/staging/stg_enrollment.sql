{{ config(materialized='view') }}

WITH typed AS (

    SELECT
        CAST(NPI AS STRING) AS NPI,
        MULTIPLE_NPI_FLAG,
        CAST(PECOS_ASCT_CNTL_ID AS STRING) AS PECOS_ASCT_CNTL_ID,
        ENRLMT_ID,
        PROVIDER_TYPE_CD,
        PROVIDER_TYPE_DESC,
        STATE_CD,
        FIRST_NAME,
        MDL_NAME,
        LAST_NAME,
        ORG_NAME
    FROM `healthcare-medicare.raw.enrollment`

),

trimmed AS (

    SELECT
        NPI,
        MULTIPLE_NPI_FLAG,
        PECOS_ASCT_CNTL_ID,
        TRIM(ENRLMT_ID) AS ENRLMT_ID,
        TRIM(PROVIDER_TYPE_CD) AS PROVIDER_TYPE_CD,
        TRIM(PROVIDER_TYPE_DESC) AS PROVIDER_TYPE_DESC,
        TRIM(STATE_CD) AS STATE_CD,
        TRIM(FIRST_NAME) AS FIRST_NAME,
        TRIM(MDL_NAME) AS MDL_NAME,
        TRIM(LAST_NAME) AS LAST_NAME,
        TRIM(ORG_NAME) AS ORG_NAME
    FROM typed

)

SELECT *
FROM trimmed