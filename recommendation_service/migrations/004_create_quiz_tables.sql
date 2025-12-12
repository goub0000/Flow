-- Migration: Create Quiz Structure Tables
-- Description: Tables for quiz questions and answer options
-- Dependencies: Requires lesson_quizzes table to exist

-- =============================================================================
-- CREATE TYPE: Question Type Enum
-- =============================================================================

DO $$ BEGIN
    CREATE TYPE question_type AS ENUM (
        'multiple_choice',
        'true_false',
        'short_answer',
        'essay'
    );
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- =============================================================================
-- TABLE: quiz_questions
-- =============================================================================

CREATE TABLE IF NOT EXISTS quiz_questions (
    -- Primary Key
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Foreign Key to lesson_quizzes table
    quiz_id UUID NOT NULL REFERENCES lesson_quizzes(id) ON DELETE CASCADE,

    -- Question Information
    question_text TEXT NOT NULL,
    question_type question_type NOT NULL DEFAULT 'multiple_choice',

    -- Ordering
    order_index INTEGER NOT NULL DEFAULT 0,

    -- Points
    points INTEGER NOT NULL DEFAULT 1,

    -- Multiple Choice / True-False specific fields
    correct_answer TEXT, -- For true_false: 'true' or 'false'; for short_answer: the correct answer

    -- Essay/Short Answer - Sample answer for reference
    sample_answer TEXT,

    -- Explanation shown after answering
    explanation TEXT,

    -- Optional hint
    hint TEXT,

    -- Settings
    is_required BOOLEAN DEFAULT TRUE, -- Must be answered to submit quiz

    -- Timestamps
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),

    -- Constraints
    CONSTRAINT valid_order_index CHECK (order_index >= 0),
    CONSTRAINT valid_points CHECK (points > 0),
    CONSTRAINT unique_quiz_order UNIQUE(quiz_id, order_index)
);

-- =============================================================================
-- TABLE: quiz_question_options
-- =============================================================================

CREATE TABLE IF NOT EXISTS quiz_question_options (
    -- Primary Key
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Foreign Key to quiz_questions table
    question_id UUID NOT NULL REFERENCES quiz_questions(id) ON DELETE CASCADE,

    -- Option Information
    option_text TEXT NOT NULL,

    -- Ordering
    order_index INTEGER NOT NULL DEFAULT 0,

    -- Correct answer flag
    is_correct BOOLEAN DEFAULT FALSE,

    -- Optional feedback for this specific option
    feedback TEXT,

    -- Timestamps
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),

    -- Constraints
    CONSTRAINT valid_order_index CHECK (order_index >= 0),
    CONSTRAINT unique_question_order UNIQUE(question_id, order_index)
);

-- =============================================================================
-- CREATE INDEXES
-- =============================================================================

-- Indexes for quiz_questions
CREATE INDEX idx_quiz_questions_quiz_id ON quiz_questions(quiz_id);
CREATE INDEX idx_quiz_questions_order ON quiz_questions(quiz_id, order_index);
CREATE INDEX idx_quiz_questions_type ON quiz_questions(question_type);

-- Indexes for quiz_question_options
CREATE INDEX idx_quiz_question_options_question_id ON quiz_question_options(question_id);
CREATE INDEX idx_quiz_question_options_order ON quiz_question_options(question_id, order_index);
CREATE INDEX idx_quiz_question_options_correct ON quiz_question_options(is_correct);

-- =============================================================================
-- TRIGGERS: Auto-update updated_at timestamps
-- =============================================================================

-- Trigger for quiz_questions
CREATE OR REPLACE FUNCTION update_quiz_questions_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_quiz_questions_updated_at
    BEFORE UPDATE ON quiz_questions
    FOR EACH ROW
    EXECUTE FUNCTION update_quiz_questions_updated_at();

-- Trigger for quiz_question_options
CREATE OR REPLACE FUNCTION update_quiz_question_options_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_quiz_question_options_updated_at
    BEFORE UPDATE ON quiz_question_options
    FOR EACH ROW
    EXECUTE FUNCTION update_quiz_question_options_updated_at();

-- =============================================================================
-- TRIGGER: Auto-update total_points in lesson_quizzes table
-- =============================================================================

CREATE OR REPLACE FUNCTION update_quiz_total_points()
RETURNS TRIGGER AS $$
BEGIN
    -- Update the quiz's total_points
    UPDATE lesson_quizzes
    SET total_points = (
        SELECT COALESCE(SUM(points), 0)
        FROM quiz_questions
        WHERE quiz_id = COALESCE(NEW.quiz_id, OLD.quiz_id)
    )
    WHERE id = COALESCE(NEW.quiz_id, OLD.quiz_id);

    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_quiz_total_points_insert
    AFTER INSERT ON quiz_questions
    FOR EACH ROW
    EXECUTE FUNCTION update_quiz_total_points();

CREATE TRIGGER trigger_update_quiz_total_points_update
    AFTER UPDATE OF points ON quiz_questions
    FOR EACH ROW
    EXECUTE FUNCTION update_quiz_total_points();

CREATE TRIGGER trigger_update_quiz_total_points_delete
    AFTER DELETE ON quiz_questions
    FOR EACH ROW
    EXECUTE FUNCTION update_quiz_total_points();

-- =============================================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- =============================================================================

-- Enable RLS
ALTER TABLE quiz_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE quiz_question_options ENABLE ROW LEVEL SECURITY;

-- Policies for quiz_questions
CREATE POLICY quiz_questions_institution_manage
    ON quiz_questions
    FOR ALL
    USING (
        EXISTS (
            SELECT 1 FROM lesson_quizzes lq
            INNER JOIN course_lessons cl ON lq.lesson_id = cl.id
            INNER JOIN course_modules cm ON cl.module_id = cm.id
            INNER JOIN courses c ON cm.course_id = c.id
            WHERE lq.id = quiz_questions.quiz_id
            AND c.institution_id = auth.uid()
        )
    );

CREATE POLICY quiz_questions_student_view
    ON quiz_questions
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM lesson_quizzes lq
            INNER JOIN course_lessons cl ON lq.lesson_id = cl.id
            INNER JOIN course_modules cm ON cl.module_id = cm.id
            INNER JOIN courses c ON cm.course_id = c.id
            INNER JOIN enrollments e ON e.course_id = c.id
            WHERE lq.id = quiz_questions.quiz_id
            AND cl.is_published = TRUE
            AND e.student_id = auth.uid()
            AND e.status = 'active'
        )
    );

-- Policies for quiz_question_options
CREATE POLICY quiz_question_options_institution_manage
    ON quiz_question_options
    FOR ALL
    USING (
        EXISTS (
            SELECT 1 FROM quiz_questions qq
            INNER JOIN lesson_quizzes lq ON qq.quiz_id = lq.id
            INNER JOIN course_lessons cl ON lq.lesson_id = cl.id
            INNER JOIN course_modules cm ON cl.module_id = cm.id
            INNER JOIN courses c ON cm.course_id = c.id
            WHERE qq.id = quiz_question_options.question_id
            AND c.institution_id = auth.uid()
        )
    );

CREATE POLICY quiz_question_options_student_view
    ON quiz_question_options
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM quiz_questions qq
            INNER JOIN lesson_quizzes lq ON qq.quiz_id = lq.id
            INNER JOIN course_lessons cl ON lq.lesson_id = cl.id
            INNER JOIN course_modules cm ON cl.module_id = cm.id
            INNER JOIN courses c ON cm.course_id = c.id
            INNER JOIN enrollments e ON e.course_id = c.id
            WHERE qq.id = quiz_question_options.question_id
            AND cl.is_published = TRUE
            AND e.student_id = auth.uid()
            AND e.status = 'active'
        )
    );

-- =============================================================================
-- VIEWS: Helper views for querying quiz data
-- =============================================================================

-- View: Questions with their options
CREATE OR REPLACE VIEW quiz_questions_with_options AS
SELECT
    qq.id,
    qq.quiz_id,
    qq.question_text,
    qq.question_type,
    qq.order_index,
    qq.points,
    qq.correct_answer,
    qq.sample_answer,
    qq.explanation,
    qq.hint,
    qq.is_required,
    qq.created_at,
    qq.updated_at,
    -- Aggregate options as JSONB array
    COALESCE(
        jsonb_agg(
            jsonb_build_object(
                'id', qo.id,
                'option_text', qo.option_text,
                'order_index', qo.order_index,
                'is_correct', qo.is_correct,
                'feedback', qo.feedback
            )
            ORDER BY qo.order_index
        ) FILTER (WHERE qo.id IS NOT NULL),
        '[]'::jsonb
    ) AS options
FROM quiz_questions qq
LEFT JOIN quiz_question_options qo ON qo.question_id = qq.id
GROUP BY qq.id;

-- =============================================================================
-- COMMENTS
-- =============================================================================

COMMENT ON TABLE quiz_questions IS 'Stores individual questions for quizzes';
COMMENT ON TABLE quiz_question_options IS 'Stores answer options for multiple choice questions';

COMMENT ON COLUMN quiz_questions.question_text IS 'The question text shown to students';
COMMENT ON COLUMN quiz_questions.question_type IS 'Type of question: multiple_choice, true_false, short_answer, or essay';
COMMENT ON COLUMN quiz_questions.correct_answer IS 'For true_false or short_answer questions - the correct answer';
COMMENT ON COLUMN quiz_questions.explanation IS 'Explanation shown after answering (if show_feedback is enabled)';
COMMENT ON COLUMN quiz_questions.hint IS 'Optional hint available to students';

COMMENT ON COLUMN quiz_question_options.option_text IS 'Text for this answer option';
COMMENT ON COLUMN quiz_question_options.is_correct IS 'Whether this is the correct answer';
COMMENT ON COLUMN quiz_question_options.feedback IS 'Optional feedback shown when this option is selected';

COMMENT ON TYPE question_type IS 'Types of quiz questions';

-- =============================================================================
-- SAMPLE DATA (for testing - remove in production)
-- =============================================================================

-- Example multiple choice question:
-- INSERT INTO quiz_questions (quiz_id, question_text, question_type, order_index, points, explanation)
-- VALUES (
--     'some-quiz-uuid',
--     'What is the capital of France?',
--     'multiple_choice',
--     0,
--     2,
--     'Paris has been the capital of France since 987 AD.'
-- );

-- Example options for the question above:
-- INSERT INTO quiz_question_options (question_id, option_text, order_index, is_correct)
-- VALUES
--     ('question-uuid', 'London', 0, FALSE),
--     ('question-uuid', 'Paris', 1, TRUE),
--     ('question-uuid', 'Berlin', 2, FALSE),
--     ('question-uuid', 'Madrid', 3, FALSE);

-- Example true/false question:
-- INSERT INTO quiz_questions (quiz_id, question_text, question_type, order_index, points, correct_answer, explanation)
-- VALUES (
--     'some-quiz-uuid',
--     'Python is a compiled programming language.',
--     'true_false',
--     1,
--     1,
--     'false',
--     'Python is an interpreted language, not a compiled one.'
-- );

-- Example short answer question:
-- INSERT INTO quiz_questions (quiz_id, question_text, question_type, order_index, points, correct_answer, hint)
-- VALUES (
--     'some-quiz-uuid',
--     'What does HTML stand for?',
--     'short_answer',
--     2,
--     3,
--     'HyperText Markup Language',
--     'Think about how web pages are structured.'
-- );
