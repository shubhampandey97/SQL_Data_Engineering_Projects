SELECT DISTINCT
    job_title_short
FROM
    job_postings_fact;

-- ┌───────────────────────────┐
-- │      job_title_short      │
-- │          varchar          │
-- ├───────────────────────────┤
-- │ Machine Learning Engineer │
-- │ Cloud Engineer            │
-- │ Senior Data Analyst       │
-- │ Senior Data Engineer      │
-- │ Data Analyst              │
-- │ Software Engineer         │
-- │ Data Engineer             │
-- │ Data Scientist            │
-- │ Business Analyst          │
-- │ Senior Data Scientist     │
-- ├───────────────────────────┤
-- │          10 rows          │
-- └───────────────────────────┘



SELECT DISTINCT
    job_country
FROM
    job_postings_fact;

-- ┌────────────────────────┐
-- │      job_country       │
-- │        varchar         │
-- ├────────────────────────┤
-- │ Sweden                 │
-- │ Portugal               │
-- │ Singapore              │
-- │ Thailand               │
-- │ Bulgaria               │
-- │ Romania                │
-- │ Paraguay               │
-- │ Albania                │
-- │ Suriname               │
-- │ Mozambique             │
-- │ United Arab Emirates   │
-- │ Taiwan                 │
-- │ Latvia                 │
-- │ Uruguay                │
-- │ Bhutan                 │
-- │ Honduras               │
-- │ Somalia                │
-- │ Argentina              │
-- │ Ecuador                │
-- │ New Zealand            │
-- │   ·                    │
-- │   ·                    │
-- │   ·                    │
-- │ Mexico                 │
-- │ Bosnia and Herzegovina │
-- │ Lebanon                │
-- │ Bangladesh             │
-- │ Bahrain                │
-- │ Japan                  │
-- │ Benin                  │
-- │ Lesotho                │
-- │ Australia              │
-- │ Pakistan               │
-- │ Vietnam                │
-- │ Palestine              │
-- │ Ghana                  │
-- │ Tajikistan             │
-- │ Haiti                  │
-- │ Austria                │
-- │ Iraq                   │
-- │ Greece                 │
-- │ Macedonia (FYROM)      │
-- │ Zimbabwe               │
-- ├────────────────────────┤
-- │  161 rows (40 shown)   │
-- └────────────────────────┘