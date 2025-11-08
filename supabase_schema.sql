-- ================================================================================
-- Find Your Path - Supabase Database Schema
-- Run this SQL in your Supabase SQL Editor to create all tables
-- ================================================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ================================================================================
-- Universities Table
-- ================================================================================
CREATE TABLE universities (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    country VARCHAR(100) NOT NULL,
    state VARCHAR(100),
    city VARCHAR(100),
    website VARCHAR(255),
    logo_url VARCHAR(500),
    description TEXT,
    university_type VARCHAR(50),
    location_type VARCHAR(50),

    -- Student body
    total_students INTEGER,

    -- Rankings
    global_rank INTEGER,
    national_rank INTEGER,

    -- Admissions
    acceptance_rate FLOAT,
    gpa_average FLOAT,
    sat_math_25th INTEGER,
    sat_math_75th INTEGER,
    sat_ebrw_25th INTEGER,
    sat_ebrw_75th INTEGER,
    act_composite_25th INTEGER,
    act_composite_75th INTEGER,

    -- Financial
    tuition_out_state FLOAT,
    total_cost FLOAT,

    -- Outcomes
    graduation_rate_4year FLOAT,
    median_earnings_10year FLOAT,

    -- Timestamps
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create indexes for universities
CREATE INDEX idx_universities_name ON universities(name);
CREATE INDEX idx_universities_country ON universities(country);
CREATE INDEX idx_universities_global_rank ON universities(global_rank);
CREATE INDEX idx_universities_name_country ON universities(name, country);

-- ================================================================================
-- Programs Table
-- ================================================================================
CREATE TABLE programs (
    id BIGSERIAL PRIMARY KEY,
    university_id BIGINT NOT NULL REFERENCES universities(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    degree_type VARCHAR(50) NOT NULL,
    field VARCHAR(100),
    description TEXT,
    median_salary FLOAT,

    -- Timestamps
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create indexes for programs
CREATE INDEX idx_programs_university_id ON programs(university_id);
CREATE INDEX idx_programs_field ON programs(field);

-- ================================================================================
-- Student Profiles Table
-- ================================================================================
CREATE TABLE student_profiles (
    id BIGSERIAL PRIMARY KEY,
    user_id VARCHAR(100) UNIQUE NOT NULL,

    -- Global Academic Information
    grading_system VARCHAR(50),
    grade_value VARCHAR(20),
    nationality VARCHAR(10),
    current_country VARCHAR(10),
    current_region VARCHAR(100),
    standardized_test_type VARCHAR(50),
    test_scores JSONB,

    -- Legacy Academic Info (backward compatibility)
    gpa FLOAT,
    sat_total INTEGER,
    sat_math INTEGER,
    sat_ebrw INTEGER,
    act_composite INTEGER,
    class_rank INTEGER,
    class_size INTEGER,

    -- Interests
    intended_major VARCHAR(100),
    field_of_study VARCHAR(100),
    career_goals TEXT,
    alternative_majors JSONB,
    career_focused INTEGER DEFAULT 1,
    research_opportunities INTEGER DEFAULT 0,

    -- Preferences
    preferred_states JSONB,
    preferred_regions JSONB,
    preferred_countries JSONB,
    location_type_preference VARCHAR(50),

    -- Financial
    budget_range VARCHAR(50),
    max_budget_per_year FLOAT,
    need_financial_aid INTEGER DEFAULT 0,
    eligible_for_in_state VARCHAR(50),

    -- University characteristics
    preferred_university_type VARCHAR(50),
    university_size_preference VARCHAR(100),
    university_type_preference VARCHAR(100),
    preferred_size VARCHAR(50),
    interested_in_sports INTEGER DEFAULT 0,
    sports_important INTEGER DEFAULT 0,
    features_desired JSONB,
    deal_breakers JSONB,

    -- Timestamps
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create indexes for student profiles
CREATE INDEX idx_student_profiles_user_id ON student_profiles(user_id);

-- ================================================================================
-- Recommendations Table
-- ================================================================================
CREATE TABLE recommendations (
    id BIGSERIAL PRIMARY KEY,
    student_id BIGINT NOT NULL REFERENCES student_profiles(id) ON DELETE CASCADE,
    university_id BIGINT NOT NULL REFERENCES universities(id) ON DELETE CASCADE,

    -- Recommendation details
    match_score FLOAT NOT NULL,
    category VARCHAR(20) NOT NULL,

    -- Score breakdown
    academic_score FLOAT,
    financial_score FLOAT,
    program_score FLOAT,
    location_score FLOAT,
    characteristics_score FLOAT,

    -- Insights
    strengths JSONB,
    concerns JSONB,

    -- User interaction
    favorited INTEGER DEFAULT 0,
    notes TEXT,

    -- Timestamps
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create indexes for recommendations
CREATE INDEX idx_recommendations_student_id ON recommendations(student_id);
CREATE INDEX idx_recommendations_university_id ON recommendations(university_id);
CREATE INDEX idx_recommendations_match_score ON recommendations(match_score);

-- ================================================================================
-- Trigger for updated_at timestamps
-- ================================================================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply triggers to tables with updated_at
CREATE TRIGGER update_universities_updated_at BEFORE UPDATE ON universities
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_student_profiles_updated_at BEFORE UPDATE ON student_profiles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_recommendations_updated_at BEFORE UPDATE ON recommendations
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ================================================================================
-- Row Level Security (RLS) - OPTIONAL
-- ================================================================================
-- Enable RLS for student_profiles (users can only see their own profile)
ALTER TABLE student_profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own profile"
    ON student_profiles FOR SELECT
    USING (auth.uid()::text = user_id);

CREATE POLICY "Users can update own profile"
    ON student_profiles FOR UPDATE
    USING (auth.uid()::text = user_id);

CREATE POLICY "Users can insert own profile"
    ON student_profiles FOR INSERT
    WITH CHECK (auth.uid()::text = user_id);

-- Enable RLS for recommendations (users can only see their own recommendations)
ALTER TABLE recommendations ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own recommendations"
    ON recommendations FOR SELECT
    USING (
        student_id IN (
            SELECT id FROM student_profiles WHERE user_id = auth.uid()::text
        )
    );

CREATE POLICY "Users can manage own recommendations"
    ON recommendations FOR ALL
    USING (
        student_id IN (
            SELECT id FROM student_profiles WHERE user_id = auth.uid()::text
        )
    );

-- Universities and programs are publicly readable (no RLS needed for now)
-- If you want to restrict access, uncomment below:
-- ALTER TABLE universities ENABLE ROW LEVEL SECURITY;
-- CREATE POLICY "Public read access to universities" ON universities FOR SELECT USING (true);

-- ALTER TABLE programs ENABLE ROW LEVEL SECURITY;
-- CREATE POLICY "Public read access to programs" ON programs FOR SELECT USING (true);

-- ================================================================================
-- Done!
-- ================================================================================
