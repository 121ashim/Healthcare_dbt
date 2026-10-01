# Healthcare Medicare dbt Project

A **dbt + Google BigQuery** project that transforms raw CMS Medicare provider data into clean, documented, and tested tables for self-serve analytics. The cleaned tables are consumed directly in **Power BI**, where all data modeling (relationships and measures) is performed.

> **Design philosophy:** Deliver individually clean, trustworthy, ready-to-use tables so that any analyst can select the fields they need without having to clean or reshape the data first. Relationships and business logic live downstream in Power BI.

---

## 📊 Data Source

Data originates from the **CMS Medicare Physician & Other Practitioners / Provider Enrollment (PPEF)** public datasets. See [`PPEF_Data_Guidance.pdf`](PPEF_Data_Guidance.pdf) for the official field guidance.

Raw tables live in BigQuery under `healthcare-medicare.raw.*` and are transformed through two dbt layers.

---

## 🏗️ Architecture

```
BigQuery raw tables  ──▶  staging (views: clean + typed)  ──▶  mart (tables: public, self-serve)  ──▶  Power BI
```

| Layer | Materialization | Purpose |
|-------|-----------------|---------|
| **staging** | `view` | Cast types, trim whitespace, standardize columns, enforce data quality |
| **mart** | `table` | Stable, documented, "public" tables that Power BI connects to |

---

## 📁 Models

### Staging (`models/staging/`)

| Model | Grain | Description |
|-------|-------|-------------|
| `stg_enrollment` | One row per enrollment (`ENRLMT_ID`) | Cleaned & typed Medicare provider enrollment records |
| `stg_practice_location` | One row per practice address | Provider practice addresses and location details |
| `stg_provider_service` | One row per rendering NPI | Service utilization, payment amounts, and beneficiary metrics |
| `stg_reassignment` | One row per reassignment pair | Benefit reassignment mappings (assigning ↔ receiving enrollment IDs) |
| `stg_secondary_specialty` | One row per provider specialty | Provider secondary specialties |

### Mart (`models/mart/`)

Clean, materialized tables mirroring the staging entities — the public, self-serve layer that Power BI connects to.

- `mart_enrollment`
- `mart_practice_location`
- `mart_provider_service`
- `mart_reassignment`
- `mart_secondary_specialty`

---

## 🔑 Keys & Relationships

All tables relate back to **`stg_enrollment.ENRLMT_ID`** (the primary key), except `provider_service`, which keys on `NPI`.

```
                      stg_enrollment  (ENRLMT_ID — unique PK)
                     /        |         \
   stg_practice_location  stg_secondary_specialty  stg_reassignment
      (ENRLMT_ID)          (ENRLMT_ID)       (EASGN_BNFT_ENRLMT_ID,
                                              RCV_BNFT_ENRLMT_ID)

   stg_provider_service  ── relates on NPI
```

These relationships are **enforced in dbt** via `relationships` tests and are **modeled in Power BI** as 1-to-many relationships.

---

## ✅ Data Quality / Testing

Quality is enforced in `models/staging/stg_schema.yml`:

- **`unique`** — on primary keys (`ENRLMT_ID`, `Rndrng_NPI`)
- **`not_null`** — on keys and critical measures
- **`relationships`** — referential integrity: every foreign-key `ENRLMT_ID` in the child tables (location, specialty, reassignment) exists in `stg_enrollment`

Cleaning performed in staging:
- `CAST` to explicit types
- `TRIM` whitespace on all string fields

Run tests:
```bash
dbt test
```

---

## 📈 Downstream: Power BI

The mart tables are loaded into Power BI, where:
- **Relationships** are defined in Model view (`ENRLMT_ID` → 1-to-many).
- **Measures** (ratios, demographic %, payment-per-beneficiary, etc.) are built in DAX.
- `stg_reassignment` has two keys to enrollment (assigning / receiving) — handled as a role-playing dimension with `USERELATIONSHIP()`.

> Data is **static** (point-in-time CMS extract), so no scheduled refresh or source-freshness checks are required.

---

## 🚀 Getting Started

**Prerequisites:** Python, dbt (`dbt-bigquery`), and a BigQuery service account with access to the `healthcare-medicare` project.

```bash
# install
pip install dbt-bigquery

# install packages (if any)
dbt deps

# build all models
dbt build

# or run and test separately
dbt run
dbt test

# generate & view documentation
dbt docs generate
dbt docs serve
```

Configure your connection in `~/.dbt/profiles.yml` under the `healthcare_dbt` profile.

---

## 📂 Project Structure

```
healthcare_dbt/
├── models/
│   ├── staging/        # cleaned views + stg_schema.yml (tests & docs)
│   └── mart/           # public, materialized tables
├── analyses/
├── macros/
├── seeds/
├── snapshots/
├── tests/
├── dbt_project.yml
├── PPEF_Data_Guidance.pdf
└── README.md
```

---

## 🗺️ Roadmap

- [ ] Full column-level documentation for all exposed fields
- [ ] GitHub Actions CI to run `dbt build` on pull requests
- [ ] Power BI report build-out (in progress)

