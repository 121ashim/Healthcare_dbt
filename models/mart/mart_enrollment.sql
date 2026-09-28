{{ config(materialized='table') }}

SELECT
    NPI,
    MULTIPLE_NPI_FLAG,
    PECOS_ASCT_CNTL_ID,
    ENRLMT_ID,
    PROVIDER_TYPE_CD,
    PROVIDER_TYPE_DESC,
    STATE_CD,
    FIRST_NAME,
    MDL_NAME,
    LAST_NAME,
    ORG_NAME
FROM {{ ref('stg_enrollment') }}
