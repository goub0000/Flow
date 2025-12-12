-- Migration: Create Progress Tracking Tables
-- Description: Tables for tracking student progress through lessons, quizzes, and assignments
-- Dependencies: Requires course_lessons, lesson_quizzes, lesson_assignments tables to exist

-- =============================================================================
-- TABLE: lesson_completions
-- =============================================================================

CREATE TABLE IF NOT EXISTS lesson_completions (
    -- Primary Key
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Foreign Keys
    lesson_id UUID NOT NULL REFERENCES course_lessons(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,

    -- Completion tracking
    completed_at TIMESTAMPTZ DEFAULT NOW(),
    time_spent_minutes INTEGER DEFAULT 0, -- Actual time spent on lesson

    -- Metadata
    completed_from_device VARCHAR(50), -- mobile, desktop, tablet
    completion_percentage DECIMAL(5,2) DEFAULT 100.00, -- For partial completions

    -- Timestamps
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),

    -- Constraints
    CONSTRAINT unique_lesson_user UNIQUE(lesson_id, user_id),
    CONSTRAINT valid_time_spent CHECK (time_spent_minutes >= 0),
    CONSTRAINT valid_completion_percentage CHECK (
        completion_percentage >= 0 AND completion_percentage <= 100
    )
);

-- =============================================================================
-- TABLE: quiz_attempts
-- =============================================================================

DO $$ BEGIN
    CREATE TYPE quiz_attempt_status AS ENUM ('in_progress', 'submitted', 'graded');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

CREATE TABLE IF NOT EXISTS quiz_attempts (
    -- Primary Key
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Foreign Keys
    quiz_id UUID NOT NULL REFERENCES lesson_quizzes(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,

    -- Attempt tracking
    attempt_number INTEGER NOT NULL DEFAULT 1,
    status quiz_attempt_status DEFAULT 'in_progress',

    -- Scoring
    score DECIMAL(5,2) DEFAULT 0.00, -- Percentage score
    points_earned INTEGER DEFAULT 0,
    points_possible INTEGER DEFAULT 0,

    -- Pass/Fail
    passed BOOLEAN DEFAULT FALSE,

    -- Timing
    started_at TIMESTAMPTZ DEFAULT NOW(),
    submitted_at TIMESTAMPTZ,
    time_taken_minutes INTEGER, -- Calculated on submission

    -- Answers (JSONB array of {question_id, answer, is_correct, points})
    answers JSONB DEFAULT '[]'::JSONB,

    -- Feedback from instructor (optional)
    instructor_feedback TEXT,

    -- Timestamps
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),

    -- Constraints
    CONSTRAINT valid_attempt_number CHECK (attempt_number > 0),
    CONSTRAINT valid_score CHECK (score >= 0 AND score <= 100),
    CONSTRAINT valid_points_earned CHECK (points_earned >= 0),
    CONSTRAINT valid_points_possible CHECK (points_possible >= 0),
    CONSTRAINT valid_time_taken CHECK (time_taken_minutes IS NULL OR time_taken_minutes >= 0)
);

-- =============================================================================
-- TABLE: assignment_submissions
-- =============================================================================

DO $$ BEGIN
    CREATE TYPE submission_status AS ENUM (
        'draft',
        'submitted',
        'grading',
        'graded',
        'returned'
    );
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

CREATE TABLE IF NOT EXISTS assignment_submissions (
    -- Primary Key
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Foreign Keys
    assignment_id UUID NOT NULL REFERENCES lesson_assignments(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,

    -- Submission tracking
    status submission_status DEFAULT 'draft',

    -- Content
    text_submission TEXT, -- For text submissions
    file_urls JSONB DEFAULT '[]'::JSONB, -- Array of {filename, url, size, type}
    external_url TEXT, -- For URL submissions (e.g., GitHub repo)

    -- Grading
    points_earned DECIMAL(5,2),
    points_possible INTEGER,
    grade_percentage DECIMAL(5,2),

    -- Feedback
    instructor_feedback TEXT,
    rubric_scores JSONB DEFAULT '[]'::JSONB, -- Array of {criterion, points, feedback}

    -- Grading metadata
    graded_by UUID REFERENCES users(id), -- Institution user who graded it
    graded_at TIMESTAMPTZ,

    -- Timing
    submitted_at TIMESTAMPTZ,
    returned_at TIMESTAMPTZ, -- When feedback was returned to student

    -- Late submission tracking
    is_late BOOLEAN DEFAULT FALSE,
    late_days INTEGER DEFAULT 0,
    late_penalty_applied DECIMAL(5,2) DEFAULT 0.00, -- Percentage penalty

    -- Timestamps
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),

    -- Constraints
    CONSTRAINT unique_assignment_user UNIQUE(assignment_id, user_id),
    CONSTRAINT valid_points_earned CHECK (points_earned IS NULL OR points_earned >= 0),
    CONSTRAINT valid_points_possible CHECK (points_possible IS NULL OR points_possible >= 0),
    CONSTRAINT valid_grade_percentage CHECK (grade_percentage IS NULL OR (grade_percentage >= 0 AND grade_percentage <= 100)),
    CONSTRAINT valid_late_days CHECK (late_days >= 0),
    CONSTRAINT valid_late_penalty CHECK (late_penalty_applied >= 0 AND late_penalty_applied <= 100)
);

-- =============================================================================
-- CREATE INDEXES
-- =============================================================================

-- Indexes for lesson_completions
CREATE INDEX idx_lesson_completions_lesson_id ON lesson_completions(lesson_id);
CREATE INDEX idx_lesson_completions_user_id ON lesson_completions(user_id);
CREATE INDEX idx_lesson_completions_user_lesson ON lesson_completions(user_id, lesson_id);
CREATE INDEX idx_lesson_completions_completed_at ON lesson_completions(completed_at);

-- Indexes for quiz_attempts
CREATE INDEX idx_quiz_attempts_quiz_id ON quiz_attempts(quiz_id);
CREATE INDEX idx_quiz_attempts_user_id ON quiz_attempts(user_id);
CREATE INDEX idx_quiz_attempts_user_quiz ON quiz_attempts(user_id, quiz_id);
CREATE INDEX idx_quiz_attempts_status ON quiz_attempts(status);
CREATE INDEX idx_quiz_attempts_submitted_at ON quiz_attempts(submitted_at);

-- Indexes for assignment_submissions
CREATE INDEX idx_assignment_submissions_assignment_id ON assignment_submissions(assignment_id);
CREATE INDEX idx_assignment_submissions_user_id ON assignment_submissions(user_id);
CREATE INDEX idx_assignment_submissions_status ON assignment_submissions(status);
CREATE INDEX idx_assignment_submissions_submitted_at ON assignment_submissions(submitted_at);
CREATE INDEX idx_assignment_submissions_graded_by ON assignment_submissions(graded_by);

-- =============================================================================
-- TRIGGERS: Auto-update updated_at timestamps
-- =============================================================================

-- Trigger for lesson_completions
CREATE OR REPLACE FUNCTION update_lesson_completions_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_lesson_completions_updated_at
    BEFORE UPDATE ON lesson_completions
    FOR EACH ROW
    EXECUTE FUNCTION update_lesson_completions_updated_at();

-- Trigger for quiz_attempts
CREATE OR REPLACE FUNCTION update_quiz_attempts_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_quiz_attempts_updated_at
    BEFORE UPDATE ON quiz_attempts
    FOR EACH ROW
    EXECUTE FUNCTION update_quiz_attempts_updated_at();

-- Trigger for assignment_submissions
CREATE OR REPLACE FUNCTION update_assignment_submissions_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_assignment_submissions_updated_at
    BEFORE UPDATE ON assignment_submissions
    FOR EACH ROW
    EXECUTE FUNCTION update_assignment_submissions_updated_at();

-- =============================================================================
-- TRIGGER: Auto-calculate time_taken for quiz attempts
-- =============================================================================

CREATE OR REPLACE FUNCTION calculate_quiz_time_taken()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'submitted' AND NEW.submitted_at IS NOT NULL THEN
        NEW.time_taken_minutes := EXTRACT(EPOCH FROM (NEW.submitted_at - NEW.started_at)) / 60;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_calculate_quiz_time_taken
    BEFORE UPDATE OF status, submitted_at ON quiz_attempts
    FOR EACH ROW
    EXECUTE FUNCTION calculate_quiz_time_taken();

-- =============================================================================
-- TRIGGER: Auto-update enrollment progress when lessons are completed
-- =============================================================================

CREATE OR REPLACE FUNCTION update_enrollment_progress()
RETURNS TRIGGER AS $$
DECLARE
    v_enrollment_id UUID;
    v_total_lessons INTEGER;
    v_completed_lessons INTEGER;
    v_progress_percentage DECIMAL(5,2);
BEGIN
    -- Find the enrollment for this lesson completion
    SELECT e.id INTO v_enrollment_id
    FROM enrollments e
    INNER JOIN courses c ON e.course_id = c.id
    INNER JOIN course_modules cm ON cm.course_id = c.id
    INNER JOIN course_lessons cl ON cl.module_id = cm.id
    WHERE cl.id = NEW.lesson_id
    AND e.student_id = NEW.user_id
    LIMIT 1;

    IF v_enrollment_id IS NOT NULL THEN
        -- Count total lessons in the course
        SELECT COUNT(*) INTO v_total_lessons
        FROM course_lessons cl
        INNER JOIN course_modules cm ON cl.module_id = cm.id
        INNER JOIN enrollments e ON e.course_id = cm.course_id
        WHERE e.id = v_enrollment_id
        AND cl.is_published = TRUE;

        -- Count completed lessons
        SELECT COUNT(*) INTO v_completed_lessons
        FROM lesson_completions lc
        INNER JOIN course_lessons cl ON lc.lesson_id = cl.id
        INNER JOIN course_modules cm ON cl.module_id = cm.id
        INNER JOIN enrollments e ON e.course_id = cm.course_id
        WHERE e.id = v_enrollment_id
        AND lc.user_id = NEW.user_id;

        -- Calculate progress percentage
        IF v_total_lessons > 0 THEN
            v_progress_percentage := (v_completed_lessons::DECIMAL / v_total_lessons) * 100;
        ELSE
            v_progress_percentage := 0;
        END IF;

        -- Update enrollment progress
        UPDATE enrollments
        SET progress_percentage = v_progress_percentage,
            status = CASE
                WHEN v_progress_percentage >= 100 THEN 'completed'
                ELSE status
            END
        WHERE id = v_enrollment_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_enrollment_progress
    AFTER INSERT ON lesson_completions
    FOR EACH ROW
    EXECUTE FUNCTION update_enrollment_progress();

-- =============================================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- =============================================================================

-- Enable RLS
ALTER TABLE lesson_completions ENABLE ROW LEVEL SECURITY;
ALTER TABLE quiz_attempts ENABLE ROW LEVEL SECURITY;
ALTER TABLE assignment_submissions ENABLE ROW LEVEL SECURITY;

-- Policies for lesson_completions
CREATE POLICY lesson_completions_student_own
    ON lesson_completions
    FOR ALL
    USING (user_id = auth.uid());

CREATE POLICY lesson_completions_institution_view
    ON lesson_completions
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM course_lessons cl
            INNER JOIN course_modules cm ON cl.module_id = cm.id
            INNER JOIN courses c ON cm.course_id = c.id
            WHERE cl.id = lesson_completions.lesson_id
            AND c.institution_id = auth.uid()
        )
    );

-- Policies for quiz_attempts
CREATE POLICY quiz_attempts_student_own
    ON quiz_attempts
    FOR ALL
    USING (user_id = auth.uid());

CREATE POLICY quiz_attempts_institution_view
    ON quiz_attempts
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM lesson_quizzes lq
            INNER JOIN course_lessons cl ON lq.lesson_id = cl.id
            INNER JOIN course_modules cm ON cl.module_id = cm.id
            INNER JOIN courses c ON cm.course_id = c.id
            WHERE lq.id = quiz_attempts.quiz_id
            AND c.institution_id = auth.uid()
        )
    );

-- Policies for assignment_submissions
CREATE POLICY assignment_submissions_student_own
    ON assignment_submissions
    FOR ALL
    USING (user_id = auth.uid());

CREATE POLICY assignment_submissions_institution_manage
    ON assignment_submissions
    FOR ALL
    USING (
        EXISTS (
            SELECT 1 FROM lesson_assignments la
            INNER JOIN course_lessons cl ON la.lesson_id = cl.id
            INNER JOIN course_modules cm ON cl.module_id = cm.id
            INNER JOIN courses c ON cm.course_id = c.id
            WHERE la.id = assignment_submissions.assignment_id
            AND c.institution_id = auth.uid()
        )
    );

-- =============================================================================
-- COMMENTS
-- =============================================================================

COMMENT ON TABLE lesson_completions IS 'Tracks which lessons students have completed';
COMMENT ON TABLE quiz_attempts IS 'Stores student quiz attempts and scores';
COMMENT ON TABLE assignment_submissions IS 'Stores student assignment submissions and grades';

COMMENT ON COLUMN lesson_completions.time_spent_minutes IS 'Actual time student spent on the lesson';
COMMENT ON COLUMN quiz_attempts.answers IS 'JSONB array of student answers with scoring';
COMMENT ON COLUMN quiz_attempts.status IS 'Status of the quiz attempt: in_progress, submitted, or graded';
COMMENT ON COLUMN assignment_submissions.status IS 'Submission status: draft, submitted, grading, graded, or returned';
COMMENT ON COLUMN assignment_submissions.rubric_scores IS 'JSONB array of scores for each rubric criterion';

-- =============================================================================
-- SAMPLE DATA (for testing - remove in production)
-- =============================================================================

-- Example lesson completion:
-- INSERT INTO lesson_completions (lesson_id, user_id, time_spent_minutes)
-- VALUES (
--     'some-lesson-uuid',
--     'some-user-uuid',
--     15
-- );

-- Example quiz attempt:
-- INSERT INTO quiz_attempts (quiz_id, user_id, attempt_number, status, score, points_earned, points_possible, passed, submitted_at, answers)
-- VALUES (
--     'some-quiz-uuid',
--     'some-user-uuid',
--     1,
--     'graded',
--     85.00,
--     17,
--     20,
--     TRUE,
--     NOW(),
--     '[
--         {"question_id": "q1", "answer": "Paris", "is_correct": true, "points": 2},
--         {"question_id": "q2", "answer": "false", "is_correct": true, "points": 1}
--     ]'::JSONB
-- );

-- Example assignment submission:
-- INSERT INTO assignment_submissions (assignment_id, user_id, status, text_submission, submitted_at, points_earned, points_possible, grade_percentage)
-- VALUES (
--     'some-assignment-uuid',
--     'some-user-uuid',
--     'graded',
--     'This is my solution to the assignment...',
--     NOW(),
--     95,
--     100,
--     95.00
-- );
