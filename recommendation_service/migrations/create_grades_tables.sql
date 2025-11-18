-- Create grades tracking tables for parent-child grade sync
-- This supports Phase 3.4 - Parent-Child Grade Sync API

-- 1. Parent-Children Relationship Table
CREATE TABLE IF NOT EXISTS parent_children (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    parent_id UUID NOT NULL,
    child_id UUID NOT NULL,
    relationship_type VARCHAR(50) DEFAULT 'parent', -- parent, guardian, foster_parent
    is_primary BOOLEAN DEFAULT false,
    can_view_grades BOOLEAN DEFAULT true,
    can_view_attendance BOOLEAN DEFAULT true,
    can_view_discipline BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Foreign keys
    CONSTRAINT fk_parent_children_parent
        FOREIGN KEY (parent_id)
        REFERENCES auth.users(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_parent_children_child
        FOREIGN KEY (child_id)
        REFERENCES auth.users(id)
        ON DELETE CASCADE,

    -- Prevent duplicate relationships
    CONSTRAINT unique_parent_child
        UNIQUE (parent_id, child_id)
);

-- 2. Courses Table
CREATE TABLE IF NOT EXISTS courses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    course_code VARCHAR(50) NOT NULL,
    course_name VARCHAR(255) NOT NULL,
    teacher_id UUID,
    school_year VARCHAR(20) NOT NULL, -- e.g., "2024-2025"
    semester VARCHAR(20), -- Fall, Spring, Summer
    credits DECIMAL(3,1),
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_courses_teacher
        FOREIGN KEY (teacher_id)
        REFERENCES auth.users(id)
        ON DELETE SET NULL
);

-- 3. Student Enrollments (linking students to courses)
CREATE TABLE IF NOT EXISTS course_enrollments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    student_id UUID NOT NULL,
    course_id UUID NOT NULL,
    enrollment_date DATE NOT NULL DEFAULT CURRENT_DATE,
    status VARCHAR(20) DEFAULT 'active', -- active, completed, dropped, withdrawn
    final_grade VARCHAR(5), -- A+, A, B+, etc.
    final_percentage DECIMAL(5,2), -- 0-100
    gpa_points DECIMAL(3,2), -- 0.00-4.00
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_course_enrollments_student
        FOREIGN KEY (student_id)
        REFERENCES auth.users(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_course_enrollments_course
        FOREIGN KEY (course_id)
        REFERENCES courses(id)
        ON DELETE CASCADE,

    CONSTRAINT unique_student_course
        UNIQUE (student_id, course_id)
);

-- 4. Grades Table (individual assignments/exams)
CREATE TABLE IF NOT EXISTS grades (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    student_id UUID NOT NULL,
    course_id UUID NOT NULL,
    enrollment_id UUID NOT NULL,

    -- Grade details
    assignment_name VARCHAR(255) NOT NULL,
    category VARCHAR(50) NOT NULL, -- quiz, assignment, exam, project, participation, homework
    points_earned DECIMAL(6,2),
    points_possible DECIMAL(6,2),
    percentage DECIMAL(5,2), -- 0-100
    letter_grade VARCHAR(5), -- A+, A, A-, B+, etc.

    -- Weighting
    weight DECIMAL(5,2) DEFAULT 1.0, -- Weight in category

    -- Dates
    assigned_date DATE,
    due_date DATE,
    submitted_date DATE,
    graded_date DATE,

    -- Status
    status VARCHAR(20) DEFAULT 'graded', -- pending, submitted, graded, late, missing, excused
    is_extra_credit BOOLEAN DEFAULT false,

    -- Notes
    teacher_comments TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_grades_student
        FOREIGN KEY (student_id)
        REFERENCES auth.users(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_grades_course
        FOREIGN KEY (course_id)
        REFERENCES courses(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_grades_enrollment
        FOREIGN KEY (enrollment_id)
        REFERENCES course_enrollments(id)
        ON DELETE CASCADE
);

-- 5. GPA History Table
CREATE TABLE IF NOT EXISTS gpa_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    student_id UUID NOT NULL,
    school_year VARCHAR(20) NOT NULL,
    semester VARCHAR(20), -- Fall, Spring, Summer, or NULL for yearly

    -- GPA values
    gpa DECIMAL(3,2) NOT NULL, -- 0.00-4.00
    weighted_gpa DECIMAL(3,2), -- For weighted/honors courses
    cumulative_gpa DECIMAL(3,2),

    -- Credits
    credits_attempted DECIMAL(5,2),
    credits_earned DECIMAL(5,2),

    -- Ranking
    class_rank INTEGER,
    class_size INTEGER,
    percentile DECIMAL(5,2),

    calculated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_gpa_history_student
        FOREIGN KEY (student_id)
        REFERENCES auth.users(id)
        ON DELETE CASCADE
);

-- 6. Grade Alerts Table
CREATE TABLE IF NOT EXISTS grade_alerts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    student_id UUID NOT NULL,
    parent_id UUID NOT NULL,
    grade_id UUID,
    course_id UUID,

    alert_type VARCHAR(50) NOT NULL, -- grade_drop, missing_assignment, low_grade, improved_grade
    severity VARCHAR(20) DEFAULT 'medium', -- low, medium, high, critical

    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,

    -- Alert details
    current_value VARCHAR(50), -- Current grade/percentage
    previous_value VARCHAR(50), -- Previous grade/percentage
    threshold_value VARCHAR(50), -- Alert threshold that was crossed

    -- Status
    is_read BOOLEAN DEFAULT false,
    is_acknowledged BOOLEAN DEFAULT false,
    read_at TIMESTAMPTZ,
    acknowledged_at TIMESTAMPTZ,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_grade_alerts_student
        FOREIGN KEY (student_id)
        REFERENCES auth.users(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_grade_alerts_parent
        FOREIGN KEY (parent_id)
        REFERENCES auth.users(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_grade_alerts_grade
        FOREIGN KEY (grade_id)
        REFERENCES grades(id)
        ON DELETE SET NULL,

    CONSTRAINT fk_grade_alerts_course
        FOREIGN KEY (course_id)
        REFERENCES courses(id)
        ON DELETE SET NULL
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_parent_children_parent_id ON parent_children(parent_id);
CREATE INDEX IF NOT EXISTS idx_parent_children_child_id ON parent_children(child_id);

CREATE INDEX IF NOT EXISTS idx_courses_teacher_id ON courses(teacher_id);
CREATE INDEX IF NOT EXISTS idx_courses_school_year ON courses(school_year);

CREATE INDEX IF NOT EXISTS idx_course_enrollments_student_id ON course_enrollments(student_id);
CREATE INDEX IF NOT EXISTS idx_course_enrollments_course_id ON course_enrollments(course_id);
CREATE INDEX IF NOT EXISTS idx_course_enrollments_status ON course_enrollments(status);

CREATE INDEX IF NOT EXISTS idx_grades_student_id ON grades(student_id);
CREATE INDEX IF NOT EXISTS idx_grades_course_id ON grades(course_id);
CREATE INDEX IF NOT EXISTS idx_grades_enrollment_id ON grades(enrollment_id);
CREATE INDEX IF NOT EXISTS idx_grades_category ON grades(category);
CREATE INDEX IF NOT EXISTS idx_grades_graded_date ON grades(graded_date DESC);

CREATE INDEX IF NOT EXISTS idx_gpa_history_student_id ON gpa_history(student_id);
CREATE INDEX IF NOT EXISTS idx_gpa_history_school_year ON gpa_history(school_year);

CREATE INDEX IF NOT EXISTS idx_grade_alerts_student_id ON grade_alerts(student_id);
CREATE INDEX IF NOT EXISTS idx_grade_alerts_parent_id ON grade_alerts(parent_id);
CREATE INDEX IF NOT EXISTS idx_grade_alerts_is_read ON grade_alerts(is_read);
CREATE INDEX IF NOT EXISTS idx_grade_alerts_created_at ON grade_alerts(created_at DESC);

-- Add RLS (Row Level Security) policies
ALTER TABLE parent_children ENABLE ROW LEVEL SECURITY;
ALTER TABLE courses ENABLE ROW LEVEL SECURITY;
ALTER TABLE course_enrollments ENABLE ROW LEVEL SECURITY;
ALTER TABLE grades ENABLE ROW LEVEL SECURITY;
ALTER TABLE gpa_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE grade_alerts ENABLE ROW LEVEL SECURITY;

-- Parent-Children Policies
CREATE POLICY "Parents can view their children relationships"
    ON parent_children FOR SELECT
    USING (auth.uid() = parent_id);

CREATE POLICY "Students can view their parent relationships"
    ON parent_children FOR SELECT
    USING (auth.uid() = child_id);

-- Grades Policies
CREATE POLICY "Students can view own grades"
    ON grades FOR SELECT
    USING (auth.uid() = student_id);

CREATE POLICY "Parents can view children grades"
    ON grades FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM parent_children
            WHERE parent_id = auth.uid()
            AND child_id = grades.student_id
            AND can_view_grades = true
        )
    );

-- GPA History Policies
CREATE POLICY "Students can view own GPA history"
    ON gpa_history FOR SELECT
    USING (auth.uid() = student_id);

CREATE POLICY "Parents can view children GPA history"
    ON gpa_history FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM parent_children
            WHERE parent_id = auth.uid()
            AND child_id = gpa_history.student_id
            AND can_view_grades = true
        )
    );

-- Grade Alerts Policies
CREATE POLICY "Parents can view own alerts"
    ON grade_alerts FOR SELECT
    USING (auth.uid() = parent_id);

CREATE POLICY "Service role can insert alerts"
    ON grade_alerts FOR INSERT
    WITH CHECK (true);

-- Comments
COMMENT ON TABLE parent_children IS 'Links parents/guardians to their children students';
COMMENT ON TABLE courses IS 'School courses/classes';
COMMENT ON TABLE course_enrollments IS 'Student enrollment in courses';
COMMENT ON TABLE grades IS 'Individual assignment/exam grades';
COMMENT ON TABLE gpa_history IS 'Historical GPA tracking by semester/year';
COMMENT ON TABLE grade_alerts IS 'Automated alerts for parents about grade changes';
