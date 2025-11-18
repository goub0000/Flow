-- Create letter of recommendation management tables
-- This supports Phase 3.5 - Recommender System Backend

-- 1. Recommendation Requests Table
CREATE TABLE IF NOT EXISTS recommendation_requests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    student_id UUID NOT NULL,
    recommender_id UUID NOT NULL,

    -- Request details
    request_type VARCHAR(50) NOT NULL, -- academic, professional, character, scholarship
    purpose TEXT NOT NULL, -- What the recommendation is for
    institution_name VARCHAR(255), -- Target institution/company
    deadline DATE NOT NULL,

    -- Status tracking
    status VARCHAR(20) DEFAULT 'pending', -- pending, accepted, declined, in_progress, completed, cancelled
    priority VARCHAR(20) DEFAULT 'normal', -- low, normal, high, urgent

    -- Student provided information
    student_message TEXT, -- Message from student to recommender
    achievements TEXT, -- Key achievements to highlight
    goals TEXT, -- Student's goals and aspirations
    relationship_context TEXT, -- How student knows recommender

    -- Recommender response
    accepted_at TIMESTAMPTZ,
    declined_at TIMESTAMPTZ,
    decline_reason TEXT,

    -- Timestamps
    requested_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    completed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Foreign keys
    CONSTRAINT fk_recommendation_requests_student
        FOREIGN KEY (student_id)
        REFERENCES auth.users(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_recommendation_requests_recommender
        FOREIGN KEY (recommender_id)
        REFERENCES auth.users(id)
        ON DELETE CASCADE,

    -- Constraints
    CONSTRAINT check_deadline_future
        CHECK (deadline >= CURRENT_DATE)
);

-- 2. Letter of Recommendations Table
CREATE TABLE IF NOT EXISTS letter_of_recommendations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    request_id UUID NOT NULL,

    -- Letter content
    content TEXT NOT NULL,
    letter_type VARCHAR(50), -- formal, informal, email_format

    -- Metadata
    word_count INTEGER,
    character_count INTEGER,

    -- Status
    status VARCHAR(20) DEFAULT 'draft', -- draft, submitted, archived
    is_template_based BOOLEAN DEFAULT false,
    template_id UUID,

    -- Visibility and sharing
    is_visible_to_student BOOLEAN DEFAULT false,
    share_token VARCHAR(255) UNIQUE, -- For sharing with institutions

    -- File attachment (optional)
    attachment_url TEXT,
    attachment_filename VARCHAR(255),

    -- Timestamps
    drafted_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    submitted_at TIMESTAMPTZ,
    last_edited_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Foreign keys
    CONSTRAINT fk_letter_of_recommendations_request
        FOREIGN KEY (request_id)
        REFERENCES recommendation_requests(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_letter_of_recommendations_template
        FOREIGN KEY (template_id)
        REFERENCES recommendation_templates(id)
        ON DELETE SET NULL
);

-- 3. Recommendation Templates Table
CREATE TABLE IF NOT EXISTS recommendation_templates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Template details
    name VARCHAR(255) NOT NULL,
    description TEXT,
    category VARCHAR(50) NOT NULL, -- academic, professional, scholarship, character

    -- Template content
    content TEXT NOT NULL,

    -- Customizable fields (JSON array of field names)
    custom_fields JSONB DEFAULT '[]'::jsonb,

    -- Usage tracking
    usage_count INTEGER DEFAULT 0,

    -- Template metadata
    is_public BOOLEAN DEFAULT true,
    created_by UUID, -- NULL for system templates

    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Foreign key
    CONSTRAINT fk_recommendation_templates_creator
        FOREIGN KEY (created_by)
        REFERENCES auth.users(id)
        ON DELETE SET NULL
);

-- 4. Recommendation Reminders Table
CREATE TABLE IF NOT EXISTS recommendation_reminders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    request_id UUID NOT NULL,

    -- Reminder details
    reminder_type VARCHAR(50) NOT NULL, -- deadline_approaching, overdue, follow_up
    days_before_deadline INTEGER, -- How many days before deadline to send

    -- Status
    sent_at TIMESTAMPTZ,
    is_sent BOOLEAN DEFAULT false,

    -- Reminder content
    message TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Foreign key
    CONSTRAINT fk_recommendation_reminders_request
        FOREIGN KEY (request_id)
        REFERENCES recommendation_requests(id)
        ON DELETE CASCADE
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_recommendation_requests_student_id ON recommendation_requests(student_id);
CREATE INDEX IF NOT EXISTS idx_recommendation_requests_recommender_id ON recommendation_requests(recommender_id);
CREATE INDEX IF NOT EXISTS idx_recommendation_requests_status ON recommendation_requests(status);
CREATE INDEX IF NOT EXISTS idx_recommendation_requests_deadline ON recommendation_requests(deadline);
CREATE INDEX IF NOT EXISTS idx_recommendation_requests_requested_at ON recommendation_requests(requested_at DESC);

CREATE INDEX IF NOT EXISTS idx_letter_of_recommendations_request_id ON letter_of_recommendations(request_id);
CREATE INDEX IF NOT EXISTS idx_letter_of_recommendations_status ON letter_of_recommendations(status);
CREATE INDEX IF NOT EXISTS idx_letter_of_recommendations_template_id ON letter_of_recommendations(template_id);

CREATE INDEX IF NOT EXISTS idx_recommendation_templates_category ON recommendation_templates(category);
CREATE INDEX IF NOT EXISTS idx_recommendation_templates_is_public ON recommendation_templates(is_public);
CREATE INDEX IF NOT EXISTS idx_recommendation_templates_created_by ON recommendation_templates(created_by);

CREATE INDEX IF NOT EXISTS idx_recommendation_reminders_request_id ON recommendation_reminders(request_id);
CREATE INDEX IF NOT EXISTS idx_recommendation_reminders_is_sent ON recommendation_reminders(is_sent);

-- Add RLS (Row Level Security) policies
ALTER TABLE recommendation_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE letter_of_recommendations ENABLE ROW LEVEL SECURITY;
ALTER TABLE recommendation_templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE recommendation_reminders ENABLE ROW LEVEL SECURITY;

-- Recommendation Requests Policies
CREATE POLICY "Students can view own requests"
    ON recommendation_requests FOR SELECT
    USING (auth.uid() = student_id);

CREATE POLICY "Recommenders can view their assigned requests"
    ON recommendation_requests FOR SELECT
    USING (auth.uid() = recommender_id);

CREATE POLICY "Students can create requests"
    ON recommendation_requests FOR INSERT
    WITH CHECK (auth.uid() = student_id);

CREATE POLICY "Students can update own requests"
    ON recommendation_requests FOR UPDATE
    USING (auth.uid() = student_id);

CREATE POLICY "Recommenders can update assigned requests"
    ON recommendation_requests FOR UPDATE
    USING (auth.uid() = recommender_id);

-- Letter of Recommendations Policies
CREATE POLICY "Recommenders can view their letters"
    ON letter_of_recommendations FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM recommendation_requests
            WHERE recommendation_requests.id = letter_of_recommendations.request_id
            AND recommendation_requests.recommender_id = auth.uid()
        )
    );

CREATE POLICY "Students can view visible letters"
    ON letter_of_recommendations FOR SELECT
    USING (
        is_visible_to_student = true
        AND EXISTS (
            SELECT 1 FROM recommendation_requests
            WHERE recommendation_requests.id = letter_of_recommendations.request_id
            AND recommendation_requests.student_id = auth.uid()
        )
    );

CREATE POLICY "Recommenders can insert letters"
    ON letter_of_recommendations FOR INSERT
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM recommendation_requests
            WHERE recommendation_requests.id = request_id
            AND recommendation_requests.recommender_id = auth.uid()
        )
    );

CREATE POLICY "Recommenders can update their letters"
    ON letter_of_recommendations FOR UPDATE
    USING (
        EXISTS (
            SELECT 1 FROM recommendation_requests
            WHERE recommendation_requests.id = letter_of_recommendations.request_id
            AND recommendation_requests.recommender_id = auth.uid()
        )
    );

-- Recommendation Templates Policies
CREATE POLICY "Everyone can view public templates"
    ON recommendation_templates FOR SELECT
    USING (is_public = true OR created_by = auth.uid());

CREATE POLICY "Users can create templates"
    ON recommendation_templates FOR INSERT
    WITH CHECK (auth.uid() = created_by);

CREATE POLICY "Users can update own templates"
    ON recommendation_templates FOR UPDATE
    USING (auth.uid() = created_by);

-- Recommendation Reminders Policies (Service role only)
CREATE POLICY "Service role can manage reminders"
    ON recommendation_reminders FOR ALL
    WITH CHECK (true);

-- Comments
COMMENT ON TABLE recommendation_requests IS 'Student requests for letters of recommendation';
COMMENT ON TABLE letter_of_recommendations IS 'Actual recommendation letters written by recommenders';
COMMENT ON TABLE recommendation_templates IS 'Templates for writing recommendations';
COMMENT ON TABLE recommendation_reminders IS 'Automated reminders for pending recommendations';

-- Insert default templates
INSERT INTO recommendation_templates (name, description, category, content, custom_fields, is_public, created_by)
VALUES
(
    'Academic Recommendation - General',
    'General purpose academic recommendation template',
    'academic',
    'Dear Admissions Committee,

I am writing to recommend {student_name} for admission to your {program_name} program. I have known {student_name} for {duration} as their {relationship}.

{student_name} has consistently demonstrated {qualities} in their academic pursuits. Particularly noteworthy is their work in {subject_area}, where they {specific_achievement}.

Their dedication to {area_of_interest} is evident in {example}. I am confident that {student_name} will be an excellent addition to your institution.

Sincerely,
{recommender_name}
{recommender_title}',
    '["student_name", "program_name", "duration", "relationship", "qualities", "subject_area", "specific_achievement", "area_of_interest", "example", "recommender_name", "recommender_title"]'::jsonb,
    true,
    NULL
),
(
    'Scholarship Recommendation',
    'Template for scholarship recommendation letters',
    'scholarship',
    'To the Scholarship Committee,

I am pleased to recommend {student_name} for the {scholarship_name}. Having worked with {student_name} for {duration}, I can attest to their exceptional {qualities}.

{student_name} has shown remarkable dedication to both academics and {extracurricular}. Their {achievement} demonstrates their commitment to {field}.

This scholarship would enable {student_name} to {goals}. I wholeheartedly support their application.

Best regards,
{recommender_name}
{recommender_title}',
    '["student_name", "scholarship_name", "duration", "qualities", "extracurricular", "achievement", "field", "goals", "recommender_name", "recommender_title"]'::jsonb,
    true,
    NULL
),
(
    'Professional Recommendation',
    'Template for internship/job recommendations',
    'professional',
    'Dear Hiring Manager,

I am writing to recommend {student_name} for the {position} position. I have had the pleasure of working with {student_name} for {duration} in the capacity of {relationship}.

{student_name} has demonstrated strong {skills} and excellent {qualities}. Their work on {project} showcased their ability to {accomplishment}.

I believe {student_name} would be an asset to your team and highly recommend them for this opportunity.

Sincerely,
{recommender_name}
{recommender_title}',
    '["student_name", "position", "duration", "relationship", "skills", "qualities", "project", "accomplishment", "recommender_name", "recommender_title"]'::jsonb,
    true,
    NULL
);
