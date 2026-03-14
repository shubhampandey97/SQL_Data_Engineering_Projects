-- duckdb md:dw_marts -c ".read build_dw_marts.sql"
-- duckdb dw_marts.duckdb -c ".read build_dw_marts.sql"
-- Step 1: DW - Create star schema tables
.read 01_create_tables_dw.sql

-- Step 2: DW - Load data from CSV files into star schema
.read 02_load_schema_dw.sql

-- Step 3: Mart - Create flat mart (denormalized table)
.read 03_create_flat_mart.sql

-- Step 4: Mart - Create skills demand mart
.read 04_create_skills_mart.sql

-- Step 5: Mart - Create priority mart
.read 05_create_priority_mart.sql

-- Step 6: Mart - Update priority mart
.read 06_update_priority_mart.sql

/*
┌───────────────────┐
│    table_name     │
│      varchar      │
├───────────────────┤
│ company_dim       │
│ job_postings_fact │
│ skills_dim        │
│ skills_job_dim    │
└───────────────────┘
┌───────────────────────────────────┐
│               info                │
│              varchar              │
├───────────────────────────────────┤
│ === lOADING company_dim Table === │
└───────────────────────────────────┘
100% ?██████████████████████████████████████? (00:00:04.96 elapsed)     
┌──────────────────────────────────┐
│               info               │
│             varchar              │
├──────────────────────────────────┤
│ === lOADING skills_dim Table === │
└──────────────────────────────────┘
┌─────────────────────────────────────────┐
│                  info                   │
│                 varchar                 │
├─────────────────────────────────────────┤
│ === lOADING job_postings_fact Table === │
└─────────────────────────────────────────┘
100% ?██████████████████████████████████████? (00:01:04.11 elapsed)
┌──────────────────────────────────────┐
│                 info                 │
│               varchar                │
├──────────────────────────────────────┤
│ === lOADING skills_job_dim Table === │
└──────────────────────────────────────┘
100% ?██████████████████████████████████████? (00:00:33.74 elapsed)
┌───────────────────┬──────────────┐
│    table_name     │ record_count │
│      varchar      │    int64     │
├───────────────────┼──────────────┤
│ Company Dimension │       215940 │
│ Skills Dimension  │          262 │
│ Job Postings Fact │      1615930 │
│ Skills Job Bridge │      7193426 │
└───────────────────┴──────────────┘
┌──────────────────────────────────┐
│               info               │
│             varchar              │
├──────────────────────────────────┤   
│ === Company Dimension Sample === │   
└──────────────────────────────────┘   
┌────────────┬────────────────────────┐
│ company_id │          name          │
│   int32    │        varchar         │
├────────────┼────────────────────────┤
│       4593 │ Metasys Technologies   │
│       4594 │ Guidehouse             │
│       4595 │ Protask                │
│       4596 │ Atria Wealth Solutions │
│       4597 │ ICONMA, LLC            │
└────────────┴────────────────────────┘
┌─────────────────────────────────┐
│              info               │
│             varchar             │
├─────────────────────────────────┤
│ === Skills Dimension Sample === │
└─────────────────────────────────┘
┌──────────┬─────────┬─────────────┐
│ skill_id │ skills  │    type     │
│  int32   │ varchar │   varchar   │
├──────────┼─────────┼─────────────┤
│        0 │ sql     │ programming │
│        1 │ python  │ programming │
│        2 │ r       │ programming │
│        3 │ go      │ programming │
│        4 │ matlab  │ programming │
└──────────┴─────────┴─────────────┘
┌──────────────────────────────────┐
│               info               │
│             varchar              │
├──────────────────────────────────┤
│ === Job Postings Fact Sample === │
└──────────────────────────────────┘
┌────────┬────────────┬─────────────────────┬──────────────────────┬────────────────┬───┬──────────────────────┬───────────────┬─────────────┬─────────────────┬─────────────────┐
│ job_id │ company_id │   job_title_short   │      job_title       │  job_location  │ . │ job_health_insurance │  job_country  │ salary_rate │ salary_year_avg │ salary_hour_avg │
│ int32  │   int32    │       varchar       │       varchar        │    varchar     │   │       boolean        │    varchar    │   varchar   │     double      │     double      │       
├────────┼────────────┼─────────────────────┼──────────────────────┼────────────────┼───┼──────────────────────┼───────────────┼─────────────┼─────────────────┼─────────────────┤
│   4593 │       4593 │ Data Analyst        │ Data Analyst         │ New York, NY   │ . │ false                │ United States │ NULL        │            NULL │            NULL │       
│   4594 │       4594 │ Data Analyst        │ Data Analyst         │ Washington, DC │ . │ true                 │ United States │ NULL        │            NULL │            NULL │
│   4595 │       4595 │ Data Analyst        │ Data Analyst         │ Fairfax, VA    │ . │ false                │ United States │ NULL        │            NULL │            NULL │       
│   4596 │       4596 │ Senior Data Analyst │ Senior Data Analys.  │ Worcester, MA  │ . │ true                 │ United States │ NULL        │            NULL │            NULL │
│   4597 │       4597 │ Data Analyst        │ Data Analyst         │ Sunnyvale, CA  │ . │ false                │ United States │ NULL        │            NULL │            NULL │       
├────────┴────────────┴─────────────────────┴──────────────────────┴────────────────┴───┴──────────────────────┴───────────────┴─────────────┴─────────────────┴─────────────────┤
│ 5 rows                                                                                                                                                   16 columns (10 shown) │       
└────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
┌──────────────────────────────────┐
│               info               │
│             varchar              │
├──────────────────────────────────┤
│ === Skills Job Bridge Sample === │
└──────────────────────────────────┘
┌──────────┬────────┐
│ skill_id │ job_id │
│  int32   │ int32  │
├──────────┼────────┤
│        0 │   4593 │
│        0 │   4594 │
│        1 │   4594 │
│        2 │   4594 │
│        0 │   4595 │
└──────────┴────────┘
┌───────────────────────────┐
│           info            │
│          varchar          │
├───────────────────────────┤
│ === loading Flat Mart === │
└───────────────────────────┘
100% ?██████████████████████████████████████? (00:00:09.89 elapsed)     
┌────────────────────────┬──────────────┐
│       table_name       │ record_count │
│        varchar         │    int64     │
├────────────────────────┼──────────────┤
│ Flat Mart Job Postings │   1615930    │
└────────────────────────┴──────────────┘
┌──────────────────────────┐
│           info           │
│         varchar          │
├──────────────────────────┤
│ === Flat Mart Sample === │
└──────────────────────────┘
┌────────┬──────────────────────┬──────────────────────┬──────────────────────┬─────────────┬─────────────────┬────────────────────┬────────────────────────────────────────────────────┐│ job_id │     company_name     │   job_title_short    │     job_location     │ job_country │ salary_year_avg │ job_work_from_home │                  skills_and_types                  ││ int32  │       varchar        │       varchar        │       varchar        │   varchar   │     double      │      boolean       │      struct("type" varchar, "name" varchar)[]      │├────────┼──────────────────────┼──────────────────────┼──────────────────────┼─────────────┼─────────────────┼────────────────────┼────────────────────────────────────────────────────┤│ 248588 │ HireNexus            │ Senior Data Analyst  │ Santa Fe, NM         │ Sudan       │            NULL │ false              │ [{'type': programming, 'name': sql}, {'type': pr.  ││ 248591 │ Certara              │ Data Scientist       │ Anywhere             │ Sudan       │            NULL │ true               │ [{'type': other, 'name': git}, {'type': programm.  ││ 248690 │ Cdiscount            │ Data Analyst         │ Bordeaux, France     │ France      │            NULL │ false              │ [{'type': programming, 'name': python}, {'type':.  ││ 248733 │ Diverse Lynx         │ Data Analyst         │ Puerto Rico          │ Puerto Rico │            NULL │ false              │ [{'type': analyst_tools, 'name': power bi}, {'ty.  ││ 248780 │ myGwork              │ Senior Data Scient.  │ Gurugram, Haryana,.  │ India       │            NULL │ false              │ [{'type': programming, 'name': c#}, {'type': pro.  ││ 248818 │ Commercial Bank of.  │ Business Analyst     │ Qatar                │ Qatar       │            NULL │ false              │ [{'type': analyst_tools, 'name': word}, {'type':.  ││ 248913 │ Tata Consultancy S.  │ Data Engineer        │ Chennai, Tamil Nad.  │ India       │            NULL │ false              │ [{'type': other, 'name': jenkins}, {'type': othe.  ││ 248995 │ Oracle               │ Software Engineer    │ Cairo, Egypt         │ Egypt       │            NULL │ false              │ [{'type': cloud, 'name': oracle}]                  ││ 249057 │ Archer - The IT Re.  │ Senior Data Engineer │ Dublin, Ireland      │ Ireland     │            NULL │ false              │ [{'type': programming, 'name': sql}, {'type': pr.  ││ 249214 │ Macquarie Group      │ Data Engineer        │ Melbourne VIC, Aus.  │ Australia   │            NULL │ false              │ [{'type': cloud, 'name': aws}, {'type': librarie.  │├────────┴──────────────────────┴──────────────────────┴──────────────────────┴─────────────┴─────────────────┴────────────────────┴────────────────────────────────────────────────────┤│ 10 rows                                                                                                                                                                     8 columns │└───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘┌──────────────────────┬──────────────┐
│      table_name      │ record_count │
│       varchar        │    int64     │
├──────────────────────┼──────────────┤
│ Skill Dimension      │          262 │
│ Date Month Dimension │           30 │
│ Skill Demand Fact    │        52520 │
└──────────────────────┴──────────────┘
┌────────────────────────────────┐
│              info              │
│            varchar             │
├────────────────────────────────┤
│ === Skill Dimension Sample === │
└────────────────────────────────┘
┌──────────┬────────────┬─────────────┐
│ skill_id │   skills   │    type     │
│  int32   │  varchar   │   varchar   │
├──────────┼────────────┼─────────────┤
│        0 │ sql        │ programming │
│        1 │ python     │ programming │
│        2 │ r          │ programming │
│        3 │ go         │ programming │
│        4 │ matlab     │ programming │
│        5 │ crystal    │ programming │
│        6 │ javascript │ programming │
│        7 │ scala      │ programming │
│        8 │ sas        │ programming │
│        9 │ nosql      │ programming │
├──────────┴────────────┴─────────────┤
│ 10 rows                   3 columns │
└─────────────────────────────────────┘
┌─────────────────────────────────────┐
│                info                 │
│               varchar               │
├─────────────────────────────────────┤
│ === Date Month Dimension Sample === │
└─────────────────────────────────────┘
┌──────────────────┬───────┬───────┬─────────┬──────────────┬──────────────┐
│ month_start_date │ year  │ month │ quarter │ quarter_name │ year_quarter │
│       date       │ int32 │ int32 │  int32  │   varchar    │   varchar    │
├──────────────────┼───────┼───────┼─────────┼──────────────┼──────────────┤
│ 2025-06-01       │  2025 │     6 │       2 │ Q2           │ 2025-Q2      │
│ 2025-05-01       │  2025 │     5 │       2 │ Q2           │ 2025-Q2      │
│ 2025-04-01       │  2025 │     4 │       2 │ Q2           │ 2025-Q2      │
│ 2025-03-01       │  2025 │     3 │       1 │ Q1           │ 2025-Q1      │
│ 2025-02-01       │  2025 │     2 │       1 │ Q1           │ 2025-Q1      │
│ 2025-01-01       │  2025 │     1 │       1 │ Q1           │ 2025-Q1      │
│ 2024-12-01       │  2024 │    12 │       4 │ Q4           │ 2024-Q4      │
│ 2024-11-01       │  2024 │    11 │       4 │ Q4           │ 2024-Q4      │
│ 2024-10-01       │  2024 │    10 │       4 │ Q4           │ 2024-Q4      │
│ 2024-09-01       │  2024 │     9 │       3 │ Q3           │ 2024-Q3      │
├──────────────────┴───────┴───────┴─────────┴──────────────┴──────────────┤
│ 10 rows                                                        6 columns │
└──────────────────────────────────────────────────────────────────────────┘
┌──────────────────────────────────┐
│               info               │
│             varchar              │
├──────────────────────────────────┤
│ === Skill Demand Fact Sample === │
└──────────────────────────────────┘
┌──────────┬─────────┬─────────────┬─────────────────┬──────────────────┬────────────────┬──────────────────────┬───────────────────────┬─────────────────────────┬─────────────────────┐│ skill_id │ skills  │ skill_type  │ job_title_short │ month_start_date │ postings_count │ remote_postings_co.  │ health_insurance_po.  │ no_degree_mention_count │    remote_share     ││  int32   │ varchar │   varchar   │     varchar     │       date       │     int32      │        int32         │         int32         │          int32          │       double        │├──────────┼─────────┼─────────────┼─────────────────┼──────────────────┼────────────────┼──────────────────────┼───────────────────────┼─────────────────────────┼─────────────────────┤│        1 │ python  │ programming │ Data Scientist  │ 2023-01-01       │          14070 │                 1286 │                  2439 │                     350 │  0.0914001421464108 ││        0 │ sql     │ programming │ Data Engineer   │ 2023-01-01       │          12973 │                 1314 │                   703 │                    5331 │ 0.10128728898481462 ││        1 │ python  │ programming │ Data Engineer   │ 2023-01-01       │          12444 │                 1298 │                   721 │                    4882 │ 0.10430729668916747 ││        0 │ sql     │ programming │ Data Analyst    │ 2023-01-01       │          11309 │                  895 │                  1725 │                    3912 │ 0.07914050756035017 ││        1 │ python  │ programming │ Data Scientist  │ 2023-08-01       │          11163 │                  722 │                  2387 │                     264 │ 0.06467795395503001 ││        0 │ sql     │ programming │ Data Scientist  │ 2023-01-01       │           9867 │                  942 │                  1873 │                     443 │ 0.09546974764366069 ││        0 │ sql     │ programming │ Data Engineer   │ 2023-03-01       │           9845 │                 1198 │                   920 │                    3693 │ 0.12168613509395633 ││        0 │ sql     │ programming │ Data Engineer   │ 2023-02-01       │           9780 │                 1067 │                   975 │                    3726 │  0.1091002044989775 ││        0 │ sql     │ programming │ Data Engineer   │ 2023-06-01       │           9722 │                 1201 │                   927 │                    3267 │ 0.12353425221147912 ││        0 │ sql     │ programming │ Data Engineer   │ 2023-08-01       │           9604 │                  945 │                  1125 │                    3980 │ 0.09839650145772595 │├──────────┴─────────┴─────────────┴─────────────────┴──────────────────┴────────────────┴──────────────────────┴───────────────────────┴─────────────────────────┴─────────────────────┤│ 10 rows                                                                                                                                                                    10 columns │└───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘┌──────────────────────────┬──────────────┐
│        table_name        │ record_count │
│         varchar          │    int64     │
├──────────────────────────┼──────────────┤
│ Priority Roles Dimension │            3 │
│ Priority Jobs Snapshot   │       575523 │
└──────────────────────────┴──────────────┘
┌─────────────────────────────────────────┐
│                  info                   │
│                 varchar                 │
├─────────────────────────────────────────┤
│ === Priority Roles Dimension Sample === │
└─────────────────────────────────────────┘
┌─────────┬──────────────────────┬──────────────┐
│ role_id │      role_name       │ priority_lvl │
│  int32  │       varchar        │    int32     │
├─────────┼──────────────────────┼──────────────┤
│       1 │ Data Engineer        │            2 │
│       2 │ Senior Data Engineer │            1 │
│       3 │ Software Engineer    │            3 │
└─────────┴──────────────────────┴──────────────┘
┌───────────────────────────────────────┐
│                 info                  │
│                varchar                │
├───────────────────────────────────────┤
│ === Priority Jobs Snapshot Sample === │
└───────────────────────────────────────┘
┌──────────────────────┬───────────┬──────────────┬────────────────────────────┐
│   job_title_short    │ job_count │ priority_lvl │         updated_at         │
│       varchar        │   int64   │    int32     │         timestamp          │
├──────────────────────┼───────────┼──────────────┼────────────────────────────┤
│ Data Engineer        │    391957 │            2 │ 2026-03-15 01:47:15.206034 │
│ Software Engineer    │     92271 │            3 │ 2026-03-15 01:47:15.206034 │
│ Senior Data Engineer │     91295 │            1 │ 2026-03-15 01:47:15.206034 │
└──────────────────────┴───────────┴──────────────┴────────────────────────────┘
┌──────────────────────────┬──────────────┐
│        table_name        │ record_count │
│         varchar          │    int64     │
├──────────────────────────┼──────────────┤
│ Priority Roles Dimension │            4 │
│ Priority Jobs Snapshot   │       906525 │
└──────────────────────────┴──────────────┘
┌─────────────────────────────────────────┐
│                  info                   │
│                 varchar                 │
├─────────────────────────────────────────┤
│ === Priority Roles Dimension Sample === │
└─────────────────────────────────────────┘
┌─────────┬──────────────────────┬──────────────┐
│ role_id │      role_name       │ priority_lvl │
│  int32  │       varchar        │    int32     │
├─────────┼──────────────────────┼──────────────┤
│       1 │ Data Engineer        │            1 │
│       2 │ Senior Data Engineer │            1 │
│       3 │ Software Engineer    │            3 │
│       4 │ Data Scientist       │            2 │
└─────────┴──────────────────────┴──────────────┘
┌───────────────────────────────────────┐
│                 info                  │
│                varchar                │
├───────────────────────────────────────┤
│ === Priority Jobs Snapshot Sample === │
└───────────────────────────────────────┘
┌──────────────────────┬───────────┬──────────────┬────────────────────────────┐
│   job_title_short    │ job_count │ priority_lvl │         updated_at         │
│       varchar        │   int64   │    int32     │         timestamp          │
├──────────────────────┼───────────┼──────────────┼────────────────────────────┤
│ Data Engineer        │    391957 │            1 │ 2026-03-15 01:47:18.103869 │
│ Data Scientist       │    331002 │            2 │ 2026-03-15 01:47:18.103869 │
│ Software Engineer    │     92271 │            3 │ 2026-03-15 01:47:15.206034 │
│ Senior Data Engineer │     91295 │            1 │ 2026-03-15 01:47:15.206034 │
└──────────────────────┴───────────┴──────────────┴────────────────────────────┘
*/