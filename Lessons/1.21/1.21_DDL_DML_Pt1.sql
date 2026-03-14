-- .read Lessons/1.21/1.21_DDL_DML_Pt1.sql
/*
┌───────────────────────┐
│     database_name     │
│        varchar        │
├───────────────────────┤
│ data_jobs             │
│ jobs_mart             │
│ md_information_schema │
│ my_db                 │
│ sample_data           │
└───────────────────────┘
┌───────────────────────┬──────────────────────┬──────────────┬───────────────────────────────┬──────────────────────────────┬────────────────────────────┬──────────┐
│     catalog_name      │     schema_name      │ schema_owner │ default_character_set_catalog │ default_character_set_schema │ default_character_set_name │ sql_path │
│        varchar        │       varchar        │   varchar    │            varchar            │           varchar            │          varchar           │ varchar  │
├───────────────────────┼──────────────────────┼──────────────┼───────────────────────────────┼──────────────────────────────┼────────────────────────────┼──────────┤
│ data_jobs             │ main                 │ duckdb       │ NULL                          │ NULL                         │ NULL                       │ NULL     │
│ jobs_mart             │ main                 │ duckdb       │ NULL                          │ NULL                         │ NULL                       │ NULL     │
│ jobs_mart             │ staging              │ duckdb       │ NULL                          │ NULL                         │ NULL                       │ NULL     │
│ md_information_schema │ main                 │ duckdb       │ NULL                          │ NULL                         │ NULL                       │ NULL     │
│ my_db                 │ main                 │ duckdb       │ NULL                          │ NULL                         │ NULL                       │ NULL     │
│ sample_data           │ hn                   │ duckdb       │ NULL                          │ NULL                         │ NULL                       │ NULL     │
│ sample_data           │ kaggle               │ duckdb       │ NULL                          │ NULL                         │ NULL                       │ NULL     │
│ sample_data           │ main                 │ duckdb       │ NULL                          │ NULL                         │ NULL                       │ NULL     │
│ sample_data           │ nyc                  │ duckdb       │ NULL                          │ NULL                         │ NULL                       │ NULL     │
│ sample_data           │ stackoverflow_survey │ duckdb       │ NULL                          │ NULL                         │ NULL                       │ NULL     │
│ sample_data           │ who                  │ duckdb       │ NULL                          │ NULL                         │ NULL                       │ NULL     │
│ system                │ information_schema   │ duckdb       │ NULL                          │ NULL                         │ NULL                       │ NULL     │
│ system                │ main                 │ duckdb       │ NULL                          │ NULL                         │ NULL                       │ NULL     │
│ system                │ pg_catalog           │ duckdb       │ NULL                          │ NULL                         │ NULL                       │ NULL     │
│ temp                  │ main                 │ duckdb       │ NULL                          │ NULL                         │ NULL                       │ NULL     │
├───────────────────────┴──────────────────────┴──────────────┴───────────────────────────────┴──────────────────────────────┴────────────────────────────┴──────────┤
│ 15 rows                                                                                                                                                  7 columns │
└────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
┌───────────────┬──────────────┬─────────────────┬────────────┬──────────────────────┬───┬──────────────────────┬──────────────────────┬────────────────────┬──────────┬───────────────┬───────────────┐
│ table_catalog │ table_schema │   table_name    │ table_type │ self_referencing_c.  │ . │ user_defined_type_.  │ user_defined_type_.  │ is_insertable_into │ is_typed │ commit_action │ TABLE_COMMENT │ 
│    varchar    │   varchar    │     varchar     │  varchar   │       varchar        │   │       varchar        │       varchar        │      varchar       │ varchar  │    varchar    │    varchar    │ 
├───────────────┼──────────────┼─────────────────┼────────────┼──────────────────────┼───┼──────────────────────┼──────────────────────┼────────────────────┼──────────┼───────────────┼───────────────┤
│ jobs_mart     │ staging      │ preferred_roles │ BASE TABLE │ NULL                 │ . │ NULL                 │ NULL                 │ YES                │ NO       │ NULL          │ NULL          │
├───────────────┴──────────────┴─────────────────┴────────────┴──────────────────────┴───┴──────────────────────┴──────────────────────┴────────────────────┴──────────┴───────────────┴───────────────┤
│ 1 rows                                                                                                                                                                         13 columns (11 shown) │ 
└──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
┌─────────┬──────────────────────┐
│ role_id │      role_name       │
│  int32  │       varchar        │
├─────────┼──────────────────────┤
│       1 │ Data Engineer        │
│       2 │ Senior Data Engineer │
│       3 │ Software Engineer    │
└─────────┴──────────────────────┘
┌─────────┬──────────────────────┬────────────────┐
│ role_id │      role_name       │ preferred_role │
│  int32  │       varchar        │    boolean     │
├─────────┼──────────────────────┼────────────────┤
│       1 │ Data Engineer        │ NULL           │
│       2 │ Senior Data Engineer │ NULL           │
│       3 │ Software Engineer    │ NULL           │
└─────────┴──────────────────────┴────────────────┘
┌─────────┬──────────────────────┬────────────────┐
│ role_id │      role_name       │ preferred_role │
│  int32  │       varchar        │    boolean     │
├─────────┼──────────────────────┼────────────────┤
│       1 │ Data Engineer        │ true           │
│       2 │ Senior Data Engineer │ true           │
│       3 │ Software Engineer    │ NULL           │
└─────────┴──────────────────────┴────────────────┘
┌─────────┬──────────────────────┬────────────────┐
│ role_id │      role_name       │ preferred_role │
│  int32  │       varchar        │    boolean     │
├─────────┼──────────────────────┼────────────────┤
│       1 │ Data Engineer        │ true           │
│       2 │ Senior Data Engineer │ true           │
│       3 │ Software Engineer    │ false          │
└─────────┴──────────────────────┴────────────────┘
┌─────────┬──────────────────────┬────────────────┐
│ role_id │      role_name       │ preferred_role │
│  int32  │       varchar        │    boolean     │
├─────────┼──────────────────────┼────────────────┤
│       1 │ Data Engineer        │ true           │
│       2 │ Senior Data Engineer │ true           │
│       3 │ Software Engineer    │ false          │
└─────────┴──────────────────────┴────────────────┘
┌─────────┬──────────────────────┬──────────────┐
│ role_id │      role_name       │ priority_lvl │
│  int32  │       varchar        │   boolean    │
├─────────┼──────────────────────┼──────────────┤
│       1 │ Data Engineer        │ true         │
│       2 │ Senior Data Engineer │ true         │
│       3 │ Software Engineer    │ false        │
└─────────┴──────────────────────┴──────────────┘
┌─────────┬──────────────────────┬──────────────┐
│ role_id │      role_name       │ priority_lvl │
│  int32  │       varchar        │    int32     │
├─────────┼──────────────────────┼──────────────┤
│       1 │ Data Engineer        │            1 │
│       2 │ Senior Data Engineer │            1 │
│       3 │ Software Engineer    │            0 │
└─────────┴──────────────────────┴──────────────┘
┌─────────┬──────────────────────┬──────────────┐
│ role_id │      role_name       │ priority_lvl │
│  int32  │       varchar        │    int32     │
├─────────┼──────────────────────┼──────────────┤
│       1 │ Data Engineer        │            1 │
│       2 │ Senior Data Engineer │            1 │
│       3 │ Software Engineer    │            3 │
└─────────┴──────────────────────┴──────────────┘
*/





-- CREATE & DELETE DATABASES

USE data_jobs;

DROP DATABASE IF EXISTS jobs_mart;

CREATE DATABASE IF NOT EXISTS jobs_mart;

SHOW DATABASES;
/*
┌───────────────────────┐
│     database_name     │
│        varchar        │
├───────────────────────┤
│ data_jobs             │
│ job_mart              │
│ md_information_schema │
│ my_db                 │
│ sample_data           │
└───────────────────────┘
*/



-- DROP DATABASE IF EXISTS jobs_mart;
-- SHOW DATABASES;
/*
┌───────────────────────┐
│     database_name     │
│        varchar        │
├───────────────────────┤
│ data_jobs             │
│ md_information_schema │
│ my_db                 │
│ sample_data           │
└───────────────────────┘
*/





-- ____________________________________________________________________________________
-- CREATE & DELTE SCHEMAS

-- SELECT *
-- FROM information_schema.schemata;
/*
┌──────────────────────┬──────────────────────┬───┬──────────────────────┬──────────┐
│     catalog_name     │     schema_name      │ . │ default_character_.  │ sql_path │
│       varchar        │       varchar        │   │       varchar        │ varchar  │
├──────────────────────┼──────────────────────┼───┼──────────────────────┼──────────┤
│ data_jobs            │ main                 │ . │ NULL                 │ NULL     │
│ job_mart             │ main                 │ . │ NULL                 │ NULL     │
│ md_information_sch.  │ main                 │ . │ NULL                 │ NULL     │
│ my_db                │ main                 │ . │ NULL                 │ NULL     │
│ sample_data          │ hn                   │ . │ NULL                 │ NULL     │
│ sample_data          │ kaggle               │ . │ NULL                 │ NULL     │
│ sample_data          │ main                 │ . │ NULL                 │ NULL     │
│ sample_data          │ nyc                  │ . │ NULL                 │ NULL     │
│ sample_data          │ stackoverflow_survey │ . │ NULL                 │ NULL     │
│ sample_data          │ who                  │ . │ NULL                 │ NULL     │
│ system               │ information_schema   │ . │ NULL                 │ NULL     │
│ system               │ main                 │ . │ NULL                 │ NULL     │
│ system               │ pg_catalog           │ . │ NULL                 │ NULL     │
│ temp                 │ main                 │ . │ NULL                 │ NULL     │
├──────────────────────┴──────────────────────┴───┴──────────────────────┴──────────┤
│ 14 rows                                                       7 columns (4 shown) │
└───────────────────────────────────────────────────────────────────────────────────┘
*/


USE jobs_mart;

CREATE SCHEMA IF NOT EXISTS jobs_mart.staging;

SELECT *
FROM information_schema.schemata;
/*
┌──────────────────────┬──────────────────────┬───┬──────────────────────┬──────────┐
│     catalog_name     │     schema_name      │ . │ default_character_.  │ sql_path │
│       varchar        │       varchar        │   │       varchar        │ varchar  │
├──────────────────────┼──────────────────────┼───┼──────────────────────┼──────────┤
│ data_jobs            │ main                 │ . │ NULL                 │ NULL     │
│ job_mart             │ main                 │ . │ NULL                 │ NULL     │
│ job_mart             │ staging              │ . │ NULL                 │ NULL     │
│ md_information_sch.  │ main                 │ . │ NULL                 │ NULL     │
│ my_db                │ main                 │ . │ NULL                 │ NULL     │
│ sample_data          │ hn                   │ . │ NULL                 │ NULL     │
│ sample_data          │ kaggle               │ . │ NULL                 │ NULL     │
│ sample_data          │ main                 │ . │ NULL                 │ NULL     │
│ sample_data          │ nyc                  │ . │ NULL                 │ NULL     │
│ sample_data          │ stackoverflow_survey │ . │ NULL                 │ NULL     │
│ sample_data          │ who                  │ . │ NULL                 │ NULL     │
│ system               │ information_schema   │ . │ NULL                 │ NULL     │
│ system               │ main                 │ . │ NULL                 │ NULL     │
│ system               │ pg_catalog           │ . │ NULL                 │ NULL     │
│ temp                 │ main                 │ . │ NULL                 │ NULL     │
├──────────────────────┴──────────────────────┴───┴──────────────────────┴──────────┤
│ 15 rows                                                       7 columns (4 shown) │
└───────────────────────────────────────────────────────────────────────────────────┘
*/

-- DROP SCHEMA IF EXISTS jobs_mart.staging;

-- SELECT *
-- FROM information_schema.schemata;
/*
┌──────────────────────┬──────────────────────┬───┬──────────────────────┬──────────┐
│     catalog_name     │     schema_name      │ . │ default_character_.  │ sql_path │
│       varchar        │       varchar        │   │       varchar        │ varchar  │
├──────────────────────┼──────────────────────┼───┼──────────────────────┼──────────┤
│ data_jobs            │ main                 │ . │ NULL                 │ NULL     │
│ job_mart             │ main                 │ . │ NULL                 │ NULL     │
│ md_information_sch.  │ main                 │ . │ NULL                 │ NULL     │
│ my_db                │ main                 │ . │ NULL                 │ NULL     │
│ sample_data          │ hn                   │ . │ NULL                 │ NULL     │
│ sample_data          │ kaggle               │ . │ NULL                 │ NULL     │
│ sample_data          │ main                 │ . │ NULL                 │ NULL     │
│ sample_data          │ nyc                  │ . │ NULL                 │ NULL     │
│ sample_data          │ stackoverflow_survey │ . │ NULL                 │ NULL     │
│ sample_data          │ who                  │ . │ NULL                 │ NULL     │
│ system               │ information_schema   │ . │ NULL                 │ NULL     │
│ system               │ main                 │ . │ NULL                 │ NULL     │
│ system               │ pg_catalog           │ . │ NULL                 │ NULL     │
│ temp                 │ main                 │ . │ NULL                 │ NULL     │
├──────────────────────┴──────────────────────┴───┴──────────────────────┴──────────┤
│ 14 rows                                                       7 columns (4 shown) │
└───────────────────────────────────────────────────────────────────────────────────┘
*/





-- _________________________________________________________________________________
-- CREATE & DELETE tables

-- CREATE TABLE preferred_roles (
--     role_id INTEGER,
--     role_name VARCHAR
-- );

-- SELECT *
-- FROM information_schema.tables
-- WHERE table_catalog = 'jobs_mart';
/*
┌───────────────┬──────────────┬───┬──────────┬───────────────┬───────────────┐
│ table_catalog │ table_schema │ . │ is_typed │ commit_action │ TABLE_COMMENT │
│    varchar    │   varchar    │   │ varchar  │    varchar    │    varchar    │
├───────────────┼──────────────┼───┼──────────┼───────────────┼───────────────┤
│ jobs_mart     │ main         │ . │ NO       │ NULL          │ NULL          │
├───────────────┴──────────────┴───┴──────────┴───────────────┴───────────────┤
│ 1 rows                                                 13 columns (5 shown) │
└─────────────────────────────────────────────────────────────────────────────┘
*/



CREATE TABLE staging.preferred_roles (
    role_id INTEGER PRIMARY KEY,
    role_name VARCHAR
);



SELECT *
FROM information_schema.tables
WHERE table_catalog = 'jobs_mart';
/*
┌───────────────┬──────────────┬───┬──────────┬───────────────┬───────────────┐
│ table_catalog │ table_schema │ . │ is_typed │ commit_action │ TABLE_COMMENT │
│    varchar    │   varchar    │   │ varchar  │    varchar    │    varchar    │
├───────────────┼──────────────┼───┼──────────┼───────────────┼───────────────┤
│ jobs_mart     │ main         │ . │ NO       │ NULL          │ NULL          │
│ jobs_mart     │ staging      │ . │ NO       │ NULL          │ NULL          │
├───────────────┴──────────────┴───┴──────────┴───────────────┴───────────────┤
│ 2 rows                                                 13 columns (5 shown) │
└─────────────────────────────────────────────────────────────────────────────┘
*/


-- DROP TABLE IF EXISTS main.preferred_roles;

-- SELECT *
-- FROM information_schema.tables
-- WHERE table_catalog = 'jobs_mart';
/*
┌───────────────┬──────────────┬─────────────────┬────────────┬──────────────────────┬───┬──────────────────────┬──────────────────────┬────────────────────┬──────────┬───────────────┬───────────────┐
│ table_catalog │ table_schema │   table_name    │ table_type │ self_referencing_c.  │ . │ user_defined_type_.  │ user_defined_type_.  │ is_insertable_into │ is_typed │ commit_action │ TABLE_COMMENT │
│    varchar    │   varchar    │     varchar     │  varchar   │       varchar        │   │       varchar        │       varchar        │      varchar       │ varchar  │    varchar    │    varchar    │ 
├───────────────┼──────────────┼─────────────────┼────────────┼──────────────────────┼───┼──────────────────────┼──────────────────────┼────────────────────┼──────────┼───────────────┼───────────────┤
│ jobs_mart     │ staging      │ preferred_roles │ BASE TABLE │ NULL                 │ . │ NULL                 │ NULL                 │ YES                │ NO       │ NULL          │ NULL          │
├───────────────┴──────────────┴─────────────────┴────────────┴──────────────────────┴───┴──────────────────────┴──────────────────────┴────────────────────┴──────────┴───────────────┴───────────────┤
│ 1 rows                                                                                                                                                                         13 columns (11 shown) │ 
└──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
*/





-- ___________________________________________________________________________________
-- INSERT INTO

INSERT INTO staging.preferred_roles (role_id, role_name)
VALUES
    (1, 'Data Engineer'),
    (2, 'Senior Data Engineer'),
    (3, 'Software Engineer');


SELECT *
FROM staging.preferred_roles;
/*
┌─────────┬──────────────────────┐
│ role_id │      role_name       │
│  int32  │       varchar        │
├─────────┼──────────────────────┤
│       1 │ Data Engineer        │
│       2 │ Senior Data Engineer │
└─────────┴──────────────────────┘
*/





-- _______________________________________________________________________________
-- Alter TABLE
-- ADD COLUMN / DROP COLUMN


ALTER TABLE staging.preferred_roles
ADD COLUMN preferred_role BOOLEAN;

SELECT *
FROM staging.preferred_roles;
/*
┌─────────┬──────────────────────┬────────────────┐
│ role_id │      role_name       │ preferred_role │
│  int32  │       varchar        │    boolean     │
├─────────┼──────────────────────┼────────────────┤
│       1 │ Data Engineer        │ NULL           │
│       2 │ Senior Data Engineer │ NULL           │
│       3 │ Software Engineer    │ NULL           │
└─────────┴──────────────────────┴────────────────┘
*/


-- ALTER TABLE staging.preferred_roles
-- DROP COLUMN preferred_role;

-- SELECT *
-- FROM staging.preferred_roles;
/*
┌─────────┬──────────────────────┐
│ role_id │      role_name       │
│  int32  │       varchar        │
├─────────┼──────────────────────┤
│       1 │ Data Engineer        │
│       2 │ Senior Data Engineer │
│       3 │ Software Engineer    │
└─────────┴──────────────────────┘
*/





-- _________________________________________________________________________________
-- UPDATE

UPDATE staging.preferred_roles
SET preferred_role = TRUE
WHERE role_id = 1 OR role_id = 2;

SELECT *
FROM staging.preferred_roles;
/*
┌─────────┬──────────────────────┬────────────────┐
│ role_id │      role_name       │ preferred_role │
│  int32  │       varchar        │    boolean     │
├─────────┼──────────────────────┼────────────────┤
│       1 │ Data Engineer        │ true           │
│       2 │ Senior Data Engineer │ true           │
│       3 │ Software Engineer    │ NULL           │
└─────────┴──────────────────────┴────────────────┘
*/



UPDATE staging.preferred_roles
SET preferred_role = FALSE
WHERE role_id = 3;


SELECT *
FROM staging.preferred_roles;
/*
┌─────────┬──────────────────────┬────────────────┐
│ role_id │      role_name       │ preferred_role │
│  int32  │       varchar        │    boolean     │
├─────────┼──────────────────────┼────────────────┤
│       1 │ Data Engineer        │ true           │
│       2 │ Senior Data Engineer │ true           │
│       3 │ Software Engineer    │ false          │
└─────────┴──────────────────────┴────────────────┘
*/





-- ALTER TABLE
-- RENAME TABLE / RENAME COLUMN / ALTER COLUMN

ALTER TABLE staging.preferred_roles
RENAME TO priority_roles;


SELECT *
FROM staging.priority_roles;


ALTER TABLE staging.priority_roles
RENAME COLUMN preferred_role TO priority_lvl;

SELECT *
FROM staging.priority_roles;
/*
┌─────────┬──────────────────────┬──────────────┐
│ role_id │      role_name       │ priority_lvl │
│  int32  │       varchar        │   boolean    │
├─────────┼──────────────────────┼──────────────┤
│       1 │ Data Engineer        │ true         │
│       2 │ Senior Data Engineer │ true         │
│       3 │ Software Engineer    │ false        │
└─────────┴──────────────────────┴──────────────┘
*/


ALTER TABLE staging.priority_roles
ALTER COLUMN  priority_lvl TYPE INTEGER; 

SELECT *
FROM staging.priority_roles;
/*
┌─────────┬──────────────────────┬──────────────┐
│ role_id │      role_name       │ priority_lvl │
│  int32  │       varchar        │    int32     │
├─────────┼──────────────────────┼──────────────┤
│       1 │ Data Engineer        │            1 │
│       2 │ Senior Data Engineer │            1 │
│       3 │ Software Engineer    │            0 │
└─────────┴──────────────────────┴──────────────┘
*/


UPDATE staging.priority_roles
SET priority_lvl = 3
WHERE role_id = 3;

SELECT *
FROM staging.priority_roles;
/*
┌─────────┬──────────────────────┬──────────────┐
│ role_id │      role_name       │ priority_lvl │
│  int32  │       varchar        │    int32     │
├─────────┼──────────────────────┼──────────────┤
│       1 │ Data Engineer        │            1 │
│       2 │ Senior Data Engineer │            1 │
│       3 │ Software Engineer    │            3 │
└─────────┴──────────────────────┴──────────────┘
*/
