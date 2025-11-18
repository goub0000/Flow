-- Create recommendation tracking tables for ML improvement
-- This supports Phase 3.2 - ML Recommendations API Enhancement

-- 1. Recommendation Impressions Table
-- Tracks when recommendations are shown to users
CREATE TABLE IF NOT EXISTS recommendation_impressions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    student_id UUID NOT NULL,
    university_id INTEGER NOT NULL,

    -- Recommendation details
    match_score DECIMAL(5, 2), -- 0.00 to 100.00
    category VARCHAR(20), -- Safety, Match, Reach
    position INTEGER, -- Position in the recommendation list (1, 2, 3, ...)

    -- Context
    recommendation_session_id UUID, -- Group recommendations shown together
    source VARCHAR(50) DEFAULT 'dashboard', -- dashboard, search, email, notification

    -- Explanation (why this was recommended)
    match_reasons JSONB, -- Array of reasons: {"gpa_match": true, "major_match": true, ...}
    match_explanation TEXT, -- Human-readable explanation

    -- Timestamps
    shown_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Foreign keys
    CONSTRAINT fk_impressions_student
        FOREIGN KEY (student_id)
        REFERENCES auth.users(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_impressions_university
        FOREIGN KEY (university_id)
        REFERENCES universities(id)
        ON DELETE CASCADE
);

-- 2. Recommendation Clicks Table
-- Tracks when users click on recommendations
CREATE TABLE IF NOT EXISTS recommendation_clicks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    impression_id UUID NOT NULL,
    student_id UUID NOT NULL,
    university_id INTEGER NOT NULL,

    -- Click details
    action_type VARCHAR(50) NOT NULL, -- view_details, apply, favorite, share
    time_to_click_seconds INTEGER, -- How long after impression until click

    -- Context
    device_type VARCHAR(20), -- web, mobile, tablet
    referrer VARCHAR(255), -- Where did the click originate

    -- Timestamps
    clicked_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Foreign keys
    CONSTRAINT fk_clicks_impression
        FOREIGN KEY (impression_id)
        REFERENCES recommendation_impressions(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_clicks_student
        FOREIGN KEY (student_id)
        REFERENCES auth.users(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_clicks_university
        FOREIGN KEY (university_id)
        REFERENCES universities(id)
        ON DELETE CASCADE
);

-- 3. Recommendation Feedback Table
-- Explicit feedback from users about recommendations
CREATE TABLE IF NOT EXISTS recommendation_feedback (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    student_id UUID NOT NULL,
    university_id INTEGER NOT NULL,
    impression_id UUID, -- Link to impression if available

    -- Feedback details
    feedback_type VARCHAR(50) NOT NULL, -- thumbs_up, thumbs_down, not_interested, already_applied
    rating INTEGER, -- 1-5 star rating (optional)
    comment TEXT, -- Optional user comment

    -- Feedback reasons (for negative feedback)
    reasons JSONB, -- Array of reasons: ["too_expensive", "wrong_major", "wrong_location", ...]

    -- Timestamps
    submitted_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Foreign keys
    CONSTRAINT fk_feedback_student
        FOREIGN KEY (student_id)
        REFERENCES auth.users(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_feedback_university
        FOREIGN KEY (university_id)
        REFERENCES universities(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_feedback_impression
        FOREIGN KEY (impression_id)
        REFERENCES recommendation_impressions(id)
        ON DELETE SET NULL
);

-- 4. Student Interaction History (Aggregated View)
-- Materialized view for faster queries (optional - can be a regular table)
CREATE TABLE IF NOT EXISTS student_interaction_summary (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    student_id UUID NOT NULL UNIQUE,

    -- Aggregate statistics
    total_impressions INTEGER DEFAULT 0,
    total_clicks INTEGER DEFAULT 0,
    total_applications INTEGER DEFAULT 0,
    total_favorites INTEGER DEFAULT 0,

    -- Click-through rate
    ctr_percentage DECIMAL(5, 2), -- Click-through rate

    -- Preferences learned from interactions
    preferred_categories JSONB, -- Most clicked categories
    preferred_locations JSONB, -- Most clicked locations
    preferred_cost_range JSONB, -- {"min": 10000, "max": 50000}

    -- Last interaction
    last_interaction_at TIMESTAMPTZ,

    -- Timestamps
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Foreign key
    CONSTRAINT fk_interaction_summary_student
        FOREIGN KEY (student_id)
        REFERENCES auth.users(id)
        ON DELETE CASCADE
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_impressions_student_id ON recommendation_impressions(student_id);
CREATE INDEX IF NOT EXISTS idx_impressions_university_id ON recommendation_impressions(university_id);
CREATE INDEX IF NOT EXISTS idx_impressions_session_id ON recommendation_impressions(recommendation_session_id);
CREATE INDEX IF NOT EXISTS idx_impressions_shown_at ON recommendation_impressions(shown_at DESC);
CREATE INDEX IF NOT EXISTS idx_impressions_student_shown ON recommendation_impressions(student_id, shown_at DESC);

CREATE INDEX IF NOT EXISTS idx_clicks_impression_id ON recommendation_clicks(impression_id);
CREATE INDEX IF NOT EXISTS idx_clicks_student_id ON recommendation_clicks(student_id);
CREATE INDEX IF NOT EXISTS idx_clicks_university_id ON recommendation_clicks(university_id);
CREATE INDEX IF NOT EXISTS idx_clicks_clicked_at ON recommendation_clicks(clicked_at DESC);
CREATE INDEX IF NOT EXISTS idx_clicks_action_type ON recommendation_clicks(action_type);

CREATE INDEX IF NOT EXISTS idx_feedback_student_id ON recommendation_feedback(student_id);
CREATE INDEX IF NOT EXISTS idx_feedback_university_id ON recommendation_feedback(university_id);
CREATE INDEX IF NOT EXISTS idx_feedback_type ON recommendation_feedback(feedback_type);
CREATE INDEX IF NOT EXISTS idx_feedback_submitted_at ON recommendation_feedback(submitted_at DESC);

CREATE INDEX IF NOT EXISTS idx_interaction_summary_student_id ON student_interaction_summary(student_id);
CREATE INDEX IF NOT EXISTS idx_interaction_summary_last_interaction ON student_interaction_summary(last_interaction_at DESC);

-- Add RLS (Row Level Security) policies
ALTER TABLE recommendation_impressions ENABLE ROW LEVEL SECURITY;
ALTER TABLE recommendation_clicks ENABLE ROW LEVEL SECURITY;
ALTER TABLE recommendation_feedback ENABLE ROW LEVEL SECURITY;
ALTER TABLE student_interaction_summary ENABLE ROW LEVEL SECURITY;

-- Recommendation Impressions Policies
CREATE POLICY "Students can view own impressions"
    ON recommendation_impressions FOR SELECT
    USING (auth.uid() = student_id);

CREATE POLICY "Service role can insert impressions"
    ON recommendation_impressions FOR INSERT
    WITH CHECK (true);

-- Recommendation Clicks Policies
CREATE POLICY "Students can view own clicks"
    ON recommendation_clicks FOR SELECT
    USING (auth.uid() = student_id);

CREATE POLICY "Service role can insert clicks"
    ON recommendation_clicks FOR INSERT
    WITH CHECK (true);

CREATE POLICY "Students can insert own clicks"
    ON recommendation_clicks FOR INSERT
    WITH CHECK (auth.uid() = student_id);

-- Recommendation Feedback Policies
CREATE POLICY "Students can view own feedback"
    ON recommendation_feedback FOR SELECT
    USING (auth.uid() = student_id);

CREATE POLICY "Students can insert feedback"
    ON recommendation_feedback FOR INSERT
    WITH CHECK (auth.uid() = student_id);

CREATE POLICY "Students can update own feedback"
    ON recommendation_feedback FOR UPDATE
    USING (auth.uid() = student_id);

-- Student Interaction Summary Policies
CREATE POLICY "Students can view own summary"
    ON student_interaction_summary FOR SELECT
    USING (auth.uid() = student_id);

CREATE POLICY "Service role can manage summaries"
    ON student_interaction_summary FOR ALL
    WITH CHECK (true);

-- Comments
COMMENT ON TABLE recommendation_impressions IS 'Tracks when recommendations are shown to students';
COMMENT ON TABLE recommendation_clicks IS 'Tracks when students click on recommendations';
COMMENT ON TABLE recommendation_feedback IS 'Explicit feedback from students about recommendations';
COMMENT ON TABLE student_interaction_summary IS 'Aggregated interaction statistics per student';

-- Function to update interaction summary after new impression
CREATE OR REPLACE FUNCTION update_interaction_summary_after_impression()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO student_interaction_summary (student_id, total_impressions, last_interaction_at)
    VALUES (NEW.student_id, 1, NEW.shown_at)
    ON CONFLICT (student_id)
    DO UPDATE SET
        total_impressions = student_interaction_summary.total_impressions + 1,
        last_interaction_at = NEW.shown_at,
        updated_at = NOW();

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to update summary after impression
CREATE TRIGGER trigger_update_summary_after_impression
    AFTER INSERT ON recommendation_impressions
    FOR EACH ROW
    EXECUTE FUNCTION update_interaction_summary_after_impression();

-- Function to update interaction summary after new click
CREATE OR REPLACE FUNCTION update_interaction_summary_after_click()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO student_interaction_summary (student_id, total_clicks, last_interaction_at)
    VALUES (NEW.student_id, 1, NEW.clicked_at)
    ON CONFLICT (student_id)
    DO UPDATE SET
        total_clicks = student_interaction_summary.total_clicks + 1,
        total_favorites = CASE WHEN NEW.action_type = 'favorite' THEN student_interaction_summary.total_favorites + 1 ELSE student_interaction_summary.total_favorites END,
        ctr_percentage = ROUND((student_interaction_summary.total_clicks + 1.0) / NULLIF(student_interaction_summary.total_impressions, 0) * 100, 2),
        last_interaction_at = NEW.clicked_at,
        updated_at = NOW();

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to update summary after click
CREATE TRIGGER trigger_update_summary_after_click
    AFTER INSERT ON recommendation_clicks
    FOR EACH ROW
    EXECUTE FUNCTION update_interaction_summary_after_click();
