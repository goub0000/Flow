-- Migration: Add search_universities_ranked function
-- Replaces the client-side .or(ilike) search with a server-side function
-- that uses full-text search with relevance ranking.

CREATE OR REPLACE FUNCTION public.search_universities_ranked(
  search_term text DEFAULT NULL,
  filter_country text DEFAULT NULL,
  filter_university_type text DEFAULT NULL,
  filter_location_type text DEFAULT NULL,
  filter_max_tuition double precision DEFAULT NULL,
  filter_min_acceptance_rate double precision DEFAULT NULL,
  filter_max_acceptance_rate double precision DEFAULT NULL,
  sort_by text DEFAULT 'relevance',
  sort_ascending boolean DEFAULT true,
  result_limit integer DEFAULT 20,
  result_offset integer DEFAULT 0
)
RETURNS json
LANGUAGE plpgsql
STABLE
SECURITY DEFINER
AS $$
DECLARE
  result json;
  clean_term text;
  ts_query tsquery;
BEGIN
  -- Sanitize and prepare search term
  IF search_term IS NOT NULL AND trim(search_term) != '' THEN
    clean_term := trim(search_term);
    -- Build tsquery: split words and join with & for AND matching
    ts_query := plainto_tsquery('english', clean_term);
  ELSE
    clean_term := NULL;
    ts_query := NULL;
  END IF;

  SELECT json_build_object(
    'universities', COALESCE(uni_data.universities, '[]'::json),
    'total_count', COALESCE(uni_data.total_count, 0)
  ) INTO result
  FROM (
    SELECT
      json_agg(row_to_json(t.*)) AS universities,
      MAX(t.total_count) AS total_count
    FROM (
      SELECT
        u.id,
        u.name,
        u.country,
        u.state,
        u.city,
        u.website,
        u.logo_url,
        u.description,
        u.university_type,
        u.location_type,
        u.total_students,
        u.global_rank,
        u.national_rank,
        u.acceptance_rate,
        u.gpa_average,
        u.sat_math_25th,
        u.sat_math_75th,
        u.sat_ebrw_25th,
        u.sat_ebrw_75th,
        u.act_composite_25th,
        u.act_composite_75th,
        u.tuition_out_state,
        u.total_cost,
        u.graduation_rate_4year,
        u.median_earnings_10year,
        u.created_at,
        u.updated_at,
        -- Relevance scoring
        CASE
          WHEN clean_term IS NULL THEN 0
          WHEN lower(u.name) = lower(clean_term) THEN 1000
          WHEN lower(u.name) LIKE lower(clean_term) || '%' THEN 500
          WHEN ts_query IS NOT NULL AND to_tsvector('english', u.name) @@ ts_query
            THEN 100 + (ts_rank(to_tsvector('english', u.name), ts_query) * 100)::int
          WHEN lower(u.name) LIKE '%' || lower(clean_term) || '%' THEN 50
          WHEN lower(COALESCE(u.city, '')) LIKE '%' || lower(clean_term) || '%'
            OR lower(COALESCE(u.state, '')) LIKE '%' || lower(clean_term) || '%' THEN 25
          WHEN lower(u.country) LIKE '%' || lower(clean_term) || '%' THEN 10
          ELSE 0
        END AS relevance_score,
        count(*) OVER() AS total_count
      FROM public.universities u
      WHERE
        -- Search filter: match if no search term, or match any field
        (
          clean_term IS NULL
          OR lower(u.name) = lower(clean_term)
          OR lower(u.name) LIKE lower(clean_term) || '%'
          OR (ts_query IS NOT NULL AND to_tsvector('english', u.name) @@ ts_query)
          OR lower(u.name) LIKE '%' || lower(clean_term) || '%'
          OR lower(COALESCE(u.city, '')) LIKE '%' || lower(clean_term) || '%'
          OR lower(COALESCE(u.state, '')) LIKE '%' || lower(clean_term) || '%'
          OR lower(u.country) LIKE '%' || lower(clean_term) || '%'
        )
        -- Optional filters
        AND (filter_country IS NULL OR u.country = filter_country)
        AND (filter_university_type IS NULL OR u.university_type = filter_university_type)
        AND (filter_location_type IS NULL OR u.location_type = filter_location_type)
        AND (filter_max_tuition IS NULL OR u.tuition_out_state <= filter_max_tuition)
        AND (filter_min_acceptance_rate IS NULL OR u.acceptance_rate >= filter_min_acceptance_rate)
        AND (filter_max_acceptance_rate IS NULL OR u.acceptance_rate <= filter_max_acceptance_rate)
      ORDER BY
        CASE WHEN sort_by = 'relevance' AND NOT sort_ascending THEN
          CASE
            WHEN clean_term IS NULL THEN 0
            WHEN lower(u.name) = lower(clean_term) THEN 1000
            WHEN lower(u.name) LIKE lower(clean_term) || '%' THEN 500
            WHEN ts_query IS NOT NULL AND to_tsvector('english', u.name) @@ ts_query
              THEN 100 + (ts_rank(to_tsvector('english', u.name), ts_query) * 100)::int
            WHEN lower(u.name) LIKE '%' || lower(clean_term) || '%' THEN 50
            WHEN lower(COALESCE(u.city, '')) LIKE '%' || lower(clean_term) || '%'
              OR lower(COALESCE(u.state, '')) LIKE '%' || lower(clean_term) || '%' THEN 25
            WHEN lower(u.country) LIKE '%' || lower(clean_term) || '%' THEN 10
            ELSE 0
          END
        END DESC NULLS LAST,
        CASE WHEN sort_by = 'relevance' AND sort_ascending THEN
          CASE
            WHEN clean_term IS NULL THEN 0
            WHEN lower(u.name) = lower(clean_term) THEN 1000
            WHEN lower(u.name) LIKE lower(clean_term) || '%' THEN 500
            WHEN ts_query IS NOT NULL AND to_tsvector('english', u.name) @@ ts_query
              THEN 100 + (ts_rank(to_tsvector('english', u.name), ts_query) * 100)::int
            WHEN lower(u.name) LIKE '%' || lower(clean_term) || '%' THEN 50
            WHEN lower(COALESCE(u.city, '')) LIKE '%' || lower(clean_term) || '%'
              OR lower(COALESCE(u.state, '')) LIKE '%' || lower(clean_term) || '%' THEN 25
            WHEN lower(u.country) LIKE '%' || lower(clean_term) || '%' THEN 10
            ELSE 0
          END
        END ASC NULLS LAST,
        CASE WHEN sort_by = 'name' AND sort_ascending THEN u.name END ASC NULLS LAST,
        CASE WHEN sort_by = 'name' AND NOT sort_ascending THEN u.name END DESC NULLS LAST,
        CASE WHEN sort_by = 'tuition_out_state' AND sort_ascending THEN u.tuition_out_state END ASC NULLS LAST,
        CASE WHEN sort_by = 'tuition_out_state' AND NOT sort_ascending THEN u.tuition_out_state END DESC NULLS LAST,
        CASE WHEN sort_by = 'acceptance_rate' AND sort_ascending THEN u.acceptance_rate END ASC NULLS LAST,
        CASE WHEN sort_by = 'acceptance_rate' AND NOT sort_ascending THEN u.acceptance_rate END DESC NULLS LAST,
        CASE WHEN sort_by = 'total_students' AND sort_ascending THEN u.total_students END ASC NULLS LAST,
        CASE WHEN sort_by = 'total_students' AND NOT sort_ascending THEN u.total_students END DESC NULLS LAST,
        u.name ASC  -- tiebreaker
      LIMIT result_limit
      OFFSET result_offset
    ) t
  ) uni_data;

  RETURN result;
END;
$$;

-- Grant access to authenticated and anon roles (matching RLS policy pattern)
GRANT EXECUTE ON FUNCTION public.search_universities_ranked TO authenticated;
GRANT EXECUTE ON FUNCTION public.search_universities_ranked TO anon;
