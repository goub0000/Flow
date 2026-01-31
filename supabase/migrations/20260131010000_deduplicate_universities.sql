-- Migration: Deduplicate universities and add unique constraint
--
-- Problem: ~5800 duplicate groups exist (same name+country), totaling ~5836 extra rows.
-- Multiple import sources (College Scorecard, QS Rankings, THE Rankings, Wikipedia,
-- Hipolabs API, African CSV) inserted without checking for existing records.
--
-- Strategy:
-- 1. Identify the "best" record in each duplicate group (most non-null fields, lowest ID as tiebreaker)
-- 2. Reassign foreign key references from duplicate IDs to the kept ID
-- 3. Delete the duplicate rows
-- 4. Add a unique index on lower(name) + lower(country) to prevent future duplicates

BEGIN;

-- Step 1: Create a temp table mapping duplicate IDs to the ID we're keeping.
-- For each (name, country) group with duplicates, rank by completeness then by lowest ID.
CREATE TEMP TABLE _dedup_map AS
WITH ranked AS (
  SELECT
    id,
    name,
    country,
    ROW_NUMBER() OVER (
      PARTITION BY lower(trim(name)), lower(trim(country))
      ORDER BY
        -- Most complete first (count of non-null important fields)
        (CASE WHEN state IS NOT NULL THEN 1 ELSE 0 END
         + CASE WHEN city IS NOT NULL THEN 1 ELSE 0 END
         + CASE WHEN website IS NOT NULL THEN 1 ELSE 0 END
         + CASE WHEN description IS NOT NULL THEN 1 ELSE 0 END
         + CASE WHEN university_type IS NOT NULL THEN 1 ELSE 0 END
         + CASE WHEN location_type IS NOT NULL THEN 1 ELSE 0 END
         + CASE WHEN total_students IS NOT NULL THEN 1 ELSE 0 END
         + CASE WHEN global_rank IS NOT NULL THEN 1 ELSE 0 END
         + CASE WHEN national_rank IS NOT NULL THEN 1 ELSE 0 END
         + CASE WHEN acceptance_rate IS NOT NULL THEN 1 ELSE 0 END
         + CASE WHEN gpa_average IS NOT NULL THEN 1 ELSE 0 END
         + CASE WHEN sat_math_25th IS NOT NULL THEN 1 ELSE 0 END
         + CASE WHEN sat_math_75th IS NOT NULL THEN 1 ELSE 0 END
         + CASE WHEN sat_ebrw_25th IS NOT NULL THEN 1 ELSE 0 END
         + CASE WHEN sat_ebrw_75th IS NOT NULL THEN 1 ELSE 0 END
         + CASE WHEN act_composite_25th IS NOT NULL THEN 1 ELSE 0 END
         + CASE WHEN act_composite_75th IS NOT NULL THEN 1 ELSE 0 END
         + CASE WHEN tuition_out_state IS NOT NULL THEN 1 ELSE 0 END
         + CASE WHEN total_cost IS NOT NULL THEN 1 ELSE 0 END
         + CASE WHEN graduation_rate_4year IS NOT NULL THEN 1 ELSE 0 END
         + CASE WHEN median_earnings_10year IS NOT NULL THEN 1 ELSE 0 END
         + CASE WHEN logo_url IS NOT NULL THEN 1 ELSE 0 END
        ) DESC,
        -- Lowest ID as tiebreaker (oldest record)
        id ASC
    ) AS rn
  FROM public.universities
),
-- The "keeper" for each group is rn=1
keepers AS (
  SELECT
    lower(trim(name)) AS norm_name,
    lower(trim(country)) AS norm_country,
    id AS keep_id
  FROM ranked
  WHERE rn = 1
)
-- Map every non-keeper duplicate to its keeper
SELECT
  r.id AS duplicate_id,
  k.keep_id
FROM ranked r
JOIN keepers k
  ON lower(trim(r.name)) = k.norm_name
  AND lower(trim(r.country)) = k.norm_country
WHERE r.rn > 1;

-- Step 2: Reassign foreign keys from duplicate IDs to the kept IDs.
-- Only recommendations.university_id references universities.id (bigint).
-- applications.institution_id and programs.institution_id are UUIDs referencing a different table.
UPDATE public.recommendations r
SET university_id = dm.keep_id
FROM _dedup_map dm
WHERE r.university_id = dm.duplicate_id;

-- Step 3: Delete the duplicate university rows
DELETE FROM public.universities
WHERE id IN (SELECT duplicate_id FROM _dedup_map);

-- Step 4: Clean up temp table
DROP TABLE _dedup_map;

-- Step 5: Add unique index on normalized name + country to prevent future duplicates.
-- Using a functional index on lower(trim(...)) so matching is case-insensitive.
CREATE UNIQUE INDEX IF NOT EXISTS idx_universities_name_country_unique
  ON public.universities (lower(trim(name)), lower(trim(country)));

COMMIT;
