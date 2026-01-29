create extension if not exists "pg_net" with schema "public";

create type "public"."lesson_type" as enum ('video', 'text', 'quiz', 'assignment');

create type "public"."notification_type" as enum ('application_status', 'grade_posted', 'message_received', 'meeting_scheduled', 'meeting_reminder', 'achievement_earned', 'deadline_reminder', 'recommendation_ready', 'system_announcement', 'comment_received', 'mention', 'event_reminder');

create type "public"."question_type" as enum ('multiple_choice', 'true_false', 'short_answer', 'essay');

create type "public"."quiz_attempt_status" as enum ('in_progress', 'submitted', 'graded');

create type "public"."submission_status" as enum ('draft', 'submitted', 'grading', 'graded', 'returned');

create type "public"."submission_type" as enum ('text', 'file', 'url', 'both');

create sequence "public"."enrichment_cache_id_seq";

create sequence "public"."programs_id_seq";

create sequence "public"."recommendations_id_seq";

create sequence "public"."student_profiles_id_seq";

create sequence "public"."system_logs_id_seq";

create sequence "public"."universities_id_seq";


  create table "public"."achievements" (
    "id" uuid not null default gen_random_uuid(),
    "student_id" uuid not null,
    "name" character varying(255) not null,
    "description" text,
    "category" character varying(50),
    "icon" character varying(50) default '🏆'::character varying,
    "points" integer default 0,
    "level" character varying(20),
    "metadata" jsonb default '{}'::jsonb,
    "earned_at" timestamp with time zone not null default now(),
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
      );


alter table "public"."achievements" enable row level security;


  create table "public"."activity_log" (
    "id" uuid not null default gen_random_uuid(),
    "timestamp" timestamp with time zone not null default now(),
    "user_id" uuid,
    "user_name" text,
    "user_email" text,
    "user_role" text,
    "action_type" text not null,
    "description" text not null,
    "metadata" jsonb default '{}'::jsonb,
    "ip_address" text,
    "user_agent" text,
    "created_at" timestamp with time zone not null default now()
      );


alter table "public"."activity_log" enable row level security;


  create table "public"."admin_users" (
    "id" uuid not null,
    "admin_role" text not null,
    "permissions" text[] not null default ARRAY[]::text[],
    "mfa_enabled" boolean default false,
    "regional_scope" text,
    "is_active" boolean default true,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );


alter table "public"."admin_users" enable row level security;


  create table "public"."app_config" (
    "key" text not null,
    "value" text not null,
    "description" text,
    "is_secret" boolean default false,
    "updated_at" timestamp without time zone default now(),
    "created_at" timestamp without time zone default now()
      );


alter table "public"."app_config" enable row level security;


  create table "public"."applications" (
    "id" uuid not null default gen_random_uuid(),
    "student_id" uuid not null,
    "institution_id" uuid not null,
    "program_id" text,
    "institution_name" text not null,
    "program_name" text not null,
    "status" text default 'pending'::text,
    "submitted_at" timestamp with time zone default now(),
    "reviewed_at" timestamp with time zone,
    "review_notes" text,
    "documents" jsonb default '{}'::jsonb,
    "personal_info" jsonb not null,
    "academic_info" jsonb not null,
    "application_fee" numeric(10,2),
    "fee_paid" boolean default false,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now(),
    "application_type" text default 'undergraduate'::text,
    "essay" text,
    "references" jsonb default '[]'::jsonb,
    "extracurricular" jsonb default '[]'::jsonb,
    "work_experience" jsonb default '[]'::jsonb,
    "is_submitted" boolean default false,
    "metadata" jsonb default '{}'::jsonb,
    "reviewed_by" uuid,
    "reviewer_notes" text,
    "decision_date" timestamp with time zone
      );


alter table "public"."applications" enable row level security;


  create table "public"."assignment_submissions" (
    "id" uuid not null default gen_random_uuid(),
    "assignment_id" uuid not null,
    "user_id" uuid not null,
    "status" public.submission_status default 'draft'::public.submission_status,
    "text_submission" text,
    "file_urls" jsonb default '[]'::jsonb,
    "external_url" text,
    "points_earned" numeric(5,2),
    "points_possible" integer,
    "grade_percentage" numeric(5,2),
    "instructor_feedback" text,
    "rubric_scores" jsonb default '[]'::jsonb,
    "graded_by" uuid,
    "graded_at" timestamp with time zone,
    "submitted_at" timestamp with time zone,
    "returned_at" timestamp with time zone,
    "is_late" boolean default false,
    "late_days" integer default 0,
    "late_penalty_applied" numeric(5,2) default 0.00,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );


alter table "public"."assignment_submissions" enable row level security;


  create table "public"."chatbot_conversations" (
    "id" uuid not null default gen_random_uuid(),
    "user_id" uuid not null,
    "messages" jsonb default '[]'::jsonb,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now(),
    "status" character varying(20) default 'active'::character varying,
    "summary" text,
    "topics" jsonb default '[]'::jsonb,
    "context" jsonb default '{}'::jsonb,
    "ai_provider" character varying(20),
    "message_count" integer default 0,
    "user_message_count" integer default 0,
    "bot_message_count" integer default 0,
    "agent_message_count" integer default 0,
    "user_name" character varying(255)
      );


alter table "public"."chatbot_conversations" enable row level security;


  create table "public"."chatbot_faqs" (
    "id" uuid not null default extensions.uuid_generate_v4(),
    "question" text not null,
    "answer" text not null,
    "keywords" jsonb default '[]'::jsonb,
    "category" character varying(50) default 'general'::character varying,
    "priority" integer default 0,
    "is_active" boolean default true,
    "usage_count" integer default 0,
    "helpful_count" integer default 0,
    "not_helpful_count" integer default 0,
    "quick_actions" jsonb default '[]'::jsonb,
    "created_by" uuid,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );


alter table "public"."chatbot_faqs" enable row level security;


  create table "public"."chatbot_feedback_analytics" (
    "id" uuid not null default extensions.uuid_generate_v4(),
    "date" date not null,
    "total_messages" integer default 0,
    "helpful_count" integer default 0,
    "not_helpful_count" integer default 0,
    "escalation_count" integer default 0,
    "avg_confidence" double precision,
    "top_topics" jsonb default '[]'::jsonb,
    "ai_provider_stats" jsonb default '{}'::jsonb,
    "created_at" timestamp with time zone default now()
      );


alter table "public"."chatbot_feedback_analytics" enable row level security;


  create table "public"."chatbot_messages" (
    "id" uuid not null default extensions.uuid_generate_v4(),
    "conversation_id" uuid not null,
    "sender" character varying(20) not null,
    "content" text not null,
    "message_type" character varying(30) default 'text'::character varying,
    "metadata" jsonb default '{}'::jsonb,
    "ai_provider" character varying(20),
    "ai_confidence" double precision,
    "tokens_used" integer,
    "feedback" character varying(20),
    "feedback_comment" text,
    "created_at" timestamp with time zone default now()
      );


alter table "public"."chatbot_messages" enable row level security;


  create table "public"."chatbot_support_queue" (
    "id" uuid not null default gen_random_uuid(),
    "conversation_id" uuid not null,
    "priority" character varying(10) default 'normal'::character varying,
    "reason" text,
    "assigned_to" uuid,
    "status" character varying(20) default 'pending'::character varying,
    "created_at" timestamp with time zone default now(),
    "resolved_at" timestamp with time zone,
    "escalation_type" character varying(50),
    "assigned_at" timestamp with time zone,
    "notes" text,
    "response_time_seconds" integer
      );


alter table "public"."chatbot_support_queue" enable row level security;


  create table "public"."children" (
    "id" uuid not null default gen_random_uuid(),
    "parent_id" uuid not null,
    "student_id" uuid,
    "name" text not null,
    "email" text,
    "date_of_birth" date,
    "photo_url" text,
    "school_name" text,
    "grade" text,
    "average_grade" numeric(5,2),
    "last_active" timestamp with time zone,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );


alter table "public"."children" enable row level security;


  create table "public"."communication_campaigns" (
    "id" uuid not null default gen_random_uuid(),
    "name" text not null,
    "type" text not null,
    "status" text default 'draft'::text,
    "target_audience" jsonb default '{}'::jsonb,
    "content" jsonb default '{}'::jsonb,
    "scheduled_at" timestamp with time zone,
    "sent_at" timestamp with time zone,
    "stats" jsonb default '{"sent": 0, "opened": 0, "clicked": 0, "delivered": 0}'::jsonb,
    "created_by" uuid,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );


alter table "public"."communication_campaigns" enable row level security;


  create table "public"."content_assignments" (
    "id" uuid not null default extensions.uuid_generate_v4(),
    "content_id" uuid not null,
    "target_type" character varying(50) not null,
    "target_id" uuid,
    "is_required" boolean default false,
    "due_date" timestamp without time zone,
    "assigned_by" uuid not null,
    "assigned_at" timestamp without time zone default now(),
    "status" character varying(50) default 'assigned'::character varying,
    "progress" integer default 0,
    "created_at" timestamp without time zone default now(),
    "updated_at" timestamp without time zone default now()
      );


alter table "public"."content_assignments" enable row level security;


  create table "public"."conversations" (
    "id" uuid not null default gen_random_uuid(),
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now(),
    "participant_ids" uuid[] not null default ARRAY[]::uuid[],
    "conversation_type" text default 'direct'::text,
    "title" text,
    "last_message_at" timestamp with time zone,
    "last_message_preview" text,
    "metadata" jsonb default '{}'::jsonb,
    "unread_count" integer default 0
      );



  create table "public"."cookie_consents" (
    "id" uuid not null default gen_random_uuid(),
    "user_id" uuid,
    "session_id" text,
    "necessary" boolean default true,
    "analytics" boolean default false,
    "marketing" boolean default false,
    "preferences" boolean default false,
    "consent_date" timestamp with time zone default now(),
    "last_updated" timestamp with time zone default now(),
    "ip_address" text,
    "user_agent" text
      );


alter table "public"."cookie_consents" enable row level security;


  create table "public"."counseling_sessions" (
    "id" uuid not null default gen_random_uuid(),
    "student_id" uuid not null,
    "counselor_id" uuid not null,
    "student_name" text,
    "scheduled_date" timestamp with time zone not null,
    "duration_minutes" integer default 60,
    "type" text,
    "status" text default 'scheduled'::text,
    "notes" text,
    "summary" text,
    "action_items" text[],
    "location" text,
    "follow_up_date" timestamp with time zone,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );


alter table "public"."counseling_sessions" enable row level security;


  create table "public"."course_lessons" (
    "id" uuid not null default gen_random_uuid(),
    "module_id" uuid not null,
    "title" character varying(255) not null,
    "description" text,
    "lesson_type" public.lesson_type not null,
    "order_index" integer not null default 0,
    "duration_minutes" integer default 0,
    "content_url" text,
    "is_mandatory" boolean default true,
    "is_published" boolean default false,
    "allow_preview" boolean default false,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );


alter table "public"."course_lessons" enable row level security;


  create table "public"."course_modules" (
    "id" uuid not null default gen_random_uuid(),
    "course_id" uuid not null,
    "title" character varying(255) not null,
    "description" text,
    "order_index" integer not null default 0,
    "duration_minutes" integer default 0,
    "lesson_count" integer default 0,
    "learning_objectives" jsonb default '[]'::jsonb,
    "is_published" boolean default false,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );


alter table "public"."course_modules" enable row level security;


  create table "public"."courses" (
    "id" uuid not null default gen_random_uuid(),
    "institution_id" uuid,
    "title" character varying(200) not null,
    "description" text not null,
    "course_type" character varying(50) not null,
    "level" character varying(50) not null,
    "duration_hours" numeric(10,2),
    "price" numeric(10,2) not null default 0.0,
    "currency" character varying(3) not null default 'USD'::character varying,
    "thumbnail_url" text,
    "preview_video_url" text,
    "category" character varying(100),
    "tags" text[] default ARRAY[]::text[],
    "learning_outcomes" text[] default ARRAY[]::text[],
    "prerequisites" text[] default ARRAY[]::text[],
    "enrolled_count" integer not null default 0,
    "max_students" integer,
    "rating" numeric(3,2),
    "review_count" integer not null default 0,
    "syllabus" jsonb,
    "metadata" jsonb,
    "status" character varying(50) not null default 'draft'::character varying,
    "is_published" boolean not null default false,
    "published_at" timestamp with time zone,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now(),
    "module_count" integer not null default 0
      );


alter table "public"."courses" enable row level security;


  create table "public"."documents" (
    "id" uuid not null default gen_random_uuid(),
    "name" text not null,
    "type" text not null,
    "size" bigint not null,
    "url" text not null,
    "storage_path" text not null,
    "uploaded_by" uuid not null,
    "uploaded_by_name" text,
    "uploaded_at" timestamp with time zone default now(),
    "category" text,
    "description" text,
    "is_verified" boolean default false,
    "related_entity_type" text,
    "related_entity_id" text
      );


alter table "public"."documents" enable row level security;


  create table "public"."enrichment_cache" (
    "id" bigint not null default nextval('public.enrichment_cache_id_seq'::regclass),
    "university_id" integer not null,
    "field_name" text not null,
    "field_value" text,
    "data_source" text not null,
    "cached_at" timestamp without time zone not null default now(),
    "expires_at" timestamp without time zone not null,
    "metadata" jsonb default '{}'::jsonb,
    "created_at" timestamp without time zone default now(),
    "updated_at" timestamp without time zone default now()
      );



  create table "public"."enrichment_jobs" (
    "job_id" text not null,
    "status" text not null,
    "created_at" timestamp without time zone not null default now(),
    "started_at" timestamp without time zone,
    "completed_at" timestamp without time zone,
    "university_limit" integer,
    "university_ids" integer[],
    "max_concurrent" integer not null default 5,
    "total_universities" integer not null default 0,
    "processed_universities" integer not null default 0,
    "successful_updates" integer not null default 0,
    "total_fields_filled" integer not null default 0,
    "errors_count" integer not null default 0,
    "error_message" text,
    "results" jsonb default '{}'::jsonb,
    "updated_at" timestamp without time zone default now()
      );



  create table "public"."enrollment_permissions" (
    "id" uuid not null default gen_random_uuid(),
    "student_id" uuid not null,
    "course_id" uuid not null,
    "institution_id" uuid not null,
    "status" character varying(50) not null default 'pending'::character varying,
    "granted_by" character varying(50) not null,
    "granted_by_user_id" uuid,
    "reviewed_at" timestamp with time zone,
    "reviewed_by_user_id" uuid,
    "denial_reason" text,
    "valid_from" timestamp with time zone default now(),
    "valid_until" timestamp with time zone,
    "notes" text,
    "metadata" jsonb,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
      );


alter table "public"."enrollment_permissions" enable row level security;


  create table "public"."enrollments" (
    "id" uuid not null default gen_random_uuid(),
    "student_id" uuid not null,
    "course_id" uuid not null,
    "status" character varying(50) not null default 'active'::character varying,
    "progress_percentage" numeric(5,2) not null default 0.0,
    "enrolled_at" timestamp with time zone not null default now(),
    "completed_at" timestamp with time zone,
    "dropped_at" timestamp with time zone,
    "last_accessed_at" timestamp with time zone,
    "metadata" jsonb,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
      );


alter table "public"."enrollments" enable row level security;


  create table "public"."gpa_history" (
    "id" uuid not null default gen_random_uuid(),
    "student_id" uuid not null,
    "school_year" character varying(20) not null,
    "semester" character varying(20),
    "gpa" numeric(3,2) not null,
    "weighted_gpa" numeric(3,2),
    "cumulative_gpa" numeric(3,2),
    "credits_attempted" numeric(5,2),
    "credits_earned" numeric(5,2),
    "class_rank" integer,
    "class_size" integer,
    "percentile" numeric(5,2),
    "calculated_at" timestamp with time zone not null default now(),
    "created_at" timestamp with time zone not null default now()
      );


alter table "public"."gpa_history" enable row level security;


  create table "public"."grade_alerts" (
    "id" uuid not null default gen_random_uuid(),
    "student_id" uuid not null,
    "parent_id" uuid not null,
    "grade_id" uuid,
    "course_id" uuid,
    "alert_type" character varying(50) not null,
    "severity" character varying(20) default 'medium'::character varying,
    "title" character varying(255) not null,
    "message" text not null,
    "current_value" character varying(50),
    "previous_value" character varying(50),
    "threshold_value" character varying(50),
    "is_read" boolean default false,
    "is_acknowledged" boolean default false,
    "read_at" timestamp with time zone,
    "acknowledged_at" timestamp with time zone,
    "created_at" timestamp with time zone not null default now()
      );


alter table "public"."grade_alerts" enable row level security;


  create table "public"."grades" (
    "id" uuid not null default gen_random_uuid(),
    "student_id" uuid not null,
    "course_id" uuid not null,
    "enrollment_id" uuid not null,
    "assignment_name" character varying(255) not null,
    "category" character varying(50) not null,
    "points_earned" numeric(6,2),
    "points_possible" numeric(6,2),
    "percentage" numeric(5,2),
    "letter_grade" character varying(5),
    "weight" numeric(5,2) default 1.0,
    "assigned_date" date,
    "due_date" date,
    "submitted_date" date,
    "graded_date" date,
    "status" character varying(20) default 'graded'::character varying,
    "is_extra_credit" boolean default false,
    "teacher_comments" text,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
      );


alter table "public"."grades" enable row level security;


  create table "public"."institution_programs" (
    "id" uuid not null default gen_random_uuid(),
    "institution_id" uuid not null,
    "name" text not null,
    "description" text,
    "category" text not null,
    "level" text not null,
    "duration_days" integer not null,
    "fee" numeric(10,2) not null,
    "currency" text default 'USD'::text,
    "max_students" integer,
    "enrolled_students" integer default 0,
    "requirements" text[],
    "application_deadline" timestamp with time zone,
    "start_date" timestamp with time zone,
    "is_active" boolean default true,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );


alter table "public"."institution_programs" enable row level security;


  create table "public"."lesson_assignments" (
    "id" uuid not null default gen_random_uuid(),
    "lesson_id" uuid not null,
    "title" character varying(255) not null,
    "instructions" text not null,
    "submission_type" public.submission_type default 'both'::public.submission_type,
    "allowed_file_types" jsonb default '[]'::jsonb,
    "max_file_size_mb" integer default 10,
    "points_possible" integer not null default 100,
    "rubric" jsonb default '[]'::jsonb,
    "due_date" timestamp with time zone,
    "allow_late_submission" boolean default true,
    "late_penalty_percent" numeric(5,2) default 0.00,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );


alter table "public"."lesson_assignments" enable row level security;


  create table "public"."lesson_completions" (
    "id" uuid not null default gen_random_uuid(),
    "lesson_id" uuid not null,
    "user_id" uuid not null,
    "completed_at" timestamp with time zone default now(),
    "time_spent_minutes" integer default 0,
    "completed_from_device" character varying(50),
    "completion_percentage" numeric(5,2) default 100.00,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );


alter table "public"."lesson_completions" enable row level security;


  create table "public"."lesson_quizzes" (
    "id" uuid not null default gen_random_uuid(),
    "lesson_id" uuid not null,
    "title" character varying(255),
    "instructions" text,
    "passing_score" numeric(5,2) default 70.00,
    "max_attempts" integer,
    "time_limit_minutes" integer,
    "shuffle_questions" boolean default false,
    "shuffle_options" boolean default false,
    "show_correct_answers" boolean default true,
    "show_feedback" boolean default true,
    "total_points" integer default 0,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );


alter table "public"."lesson_quizzes" enable row level security;


  create table "public"."lesson_texts" (
    "id" uuid not null default gen_random_uuid(),
    "lesson_id" uuid not null,
    "content" text not null,
    "content_format" character varying(20) default 'markdown'::character varying,
    "estimated_reading_time" integer,
    "attachments" jsonb default '[]'::jsonb,
    "external_links" jsonb default '[]'::jsonb,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );


alter table "public"."lesson_texts" enable row level security;


  create table "public"."lesson_videos" (
    "id" uuid not null default gen_random_uuid(),
    "lesson_id" uuid not null,
    "video_url" text not null,
    "video_platform" character varying(50) default 'youtube'::character varying,
    "thumbnail_url" text,
    "duration_seconds" integer,
    "transcript" text,
    "allow_download" boolean default false,
    "auto_play" boolean default false,
    "show_controls" boolean default true,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );


alter table "public"."lesson_videos" enable row level security;


  create table "public"."letter_of_recommendations" (
    "id" uuid not null default gen_random_uuid(),
    "request_id" uuid not null,
    "content" text not null,
    "letter_type" character varying(50),
    "word_count" integer,
    "character_count" integer,
    "status" character varying(20) default 'draft'::character varying,
    "is_template_based" boolean default false,
    "template_id" uuid,
    "is_visible_to_student" boolean default false,
    "share_token" character varying(255),
    "attachment_url" text,
    "attachment_filename" character varying(255),
    "drafted_at" timestamp with time zone not null default now(),
    "submitted_at" timestamp with time zone,
    "last_edited_at" timestamp with time zone not null default now(),
    "created_at" timestamp with time zone not null default now()
      );


alter table "public"."letter_of_recommendations" enable row level security;


  create table "public"."meetings" (
    "id" uuid not null default gen_random_uuid(),
    "parent_id" uuid not null,
    "student_id" uuid not null,
    "staff_id" uuid not null,
    "staff_type" text not null,
    "meeting_type" text not null,
    "status" text not null default 'pending'::text,
    "scheduled_date" timestamp with time zone,
    "duration_minutes" integer not null default 30,
    "meeting_mode" text not null,
    "meeting_link" text,
    "location" text,
    "subject" text not null,
    "notes" text,
    "parent_notes" text,
    "staff_notes" text,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
      );


alter table "public"."meetings" enable row level security;


  create table "public"."messages" (
    "id" uuid not null default gen_random_uuid(),
    "conversation_id" uuid not null,
    "sender_id" uuid not null,
    "content" text not null,
    "message_type" text default 'text'::text,
    "attachment_url" text,
    "reply_to_id" uuid,
    "is_edited" boolean default false,
    "is_deleted" boolean default false,
    "read_by" uuid[] default ARRAY[]::uuid[],
    "delivered_at" timestamp with time zone default now(),
    "read_at" timestamp with time zone,
    "metadata" jsonb default '{}'::jsonb,
    "timestamp" timestamp with time zone default now(),
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );



  create table "public"."notification_preferences" (
    "id" uuid not null default gen_random_uuid(),
    "user_id" uuid not null,
    "notification_type" public.notification_type not null,
    "in_app_enabled" boolean default true,
    "email_enabled" boolean default true,
    "push_enabled" boolean default true,
    "quiet_hours_start" time without time zone,
    "quiet_hours_end" time without time zone,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );


alter table "public"."notification_preferences" enable row level security;


  create table "public"."notifications" (
    "id" uuid not null default gen_random_uuid(),
    "user_id" uuid not null,
    "title" text not null,
    "message" text not null,
    "type" text not null,
    "data" jsonb default '{}'::jsonb,
    "is_read" boolean default false,
    "created_at" timestamp with time zone default now(),
    "deleted_at" timestamp with time zone,
    "metadata" jsonb default '{}'::jsonb,
    "action_url" text,
    "priority" integer default 0,
    "is_archived" boolean default false,
    "archived_at" timestamp with time zone,
    "read_at" timestamp with time zone
      );


alter table "public"."notifications" enable row level security;


  create table "public"."page_cache" (
    "url_hash" text not null,
    "url" text not null,
    "content" text not null,
    "cached_at" timestamp without time zone not null default now(),
    "expires_at" timestamp without time zone not null,
    "metadata" jsonb default '{}'::jsonb,
    "content_size" integer,
    "created_at" timestamp without time zone default now()
      );



  create table "public"."page_contents" (
    "id" uuid not null default gen_random_uuid(),
    "page_slug" character varying(50) not null,
    "title" character varying(200) not null,
    "subtitle" character varying(500),
    "content" jsonb not null default '{}'::jsonb,
    "meta_description" character varying(300),
    "status" character varying(20) default 'published'::character varying,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now(),
    "created_by" uuid,
    "updated_by" uuid
      );


alter table "public"."page_contents" enable row level security;


  create table "public"."parent_alerts" (
    "id" uuid not null default gen_random_uuid(),
    "parent_id" uuid not null,
    "child_id" uuid,
    "title" text not null,
    "message" text not null,
    "type" text,
    "severity" text default 'info'::text,
    "is_read" boolean default false,
    "created_at" timestamp with time zone default now()
      );


alter table "public"."parent_alerts" enable row level security;


  create table "public"."parent_children" (
    "id" uuid not null default gen_random_uuid(),
    "parent_id" uuid not null,
    "child_id" uuid not null,
    "relationship_type" character varying(50) default 'parent'::character varying,
    "is_primary" boolean default false,
    "can_view_grades" boolean default true,
    "can_view_attendance" boolean default true,
    "can_view_discipline" boolean default true,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
      );


alter table "public"."parent_children" enable row level security;


  create table "public"."parent_student_links" (
    "id" uuid not null default gen_random_uuid(),
    "parent_id" uuid not null,
    "student_id" uuid not null,
    "relationship" character varying(50) not null default 'parent'::character varying,
    "status" character varying(20) not null default 'pending'::character varying,
    "can_view_grades" boolean not null default true,
    "can_view_activity" boolean not null default true,
    "can_view_messages" boolean not null default false,
    "can_receive_alerts" boolean not null default true,
    "linked_at" timestamp with time zone,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
      );


alter table "public"."parent_student_links" enable row level security;


  create table "public"."payments" (
    "id" uuid not null default gen_random_uuid(),
    "user_id" uuid not null,
    "item_id" text not null,
    "item_name" text not null,
    "item_type" text not null,
    "amount" numeric(10,2) not null,
    "currency" text default 'USD'::text,
    "method" text,
    "status" text default 'pending'::text,
    "created_at" timestamp with time zone default now(),
    "completed_at" timestamp with time zone,
    "transaction_id" text,
    "reference" text,
    "metadata" jsonb default '{}'::jsonb,
    "failure_reason" text
      );


alter table "public"."payments" enable row level security;


  create table "public"."programs" (
    "id" bigint not null default nextval('public.programs_id_seq'::regclass),
    "name" character varying(255) not null,
    "degree_type" character varying(50),
    "field" character varying(100),
    "description" text,
    "median_salary" double precision,
    "created_at" timestamp with time zone default now(),
    "application_deadline" timestamp without time zone,
    "start_date" timestamp without time zone,
    "updated_at" timestamp without time zone default now(),
    "institution_id" uuid not null,
    "institution_name" text not null,
    "category" text not null,
    "level" text not null,
    "duration_days" integer not null,
    "fee" numeric(12,2) not null,
    "currency" text default 'USD'::text,
    "max_students" integer not null,
    "enrolled_students" integer default 0,
    "requirements" jsonb default '[]'::jsonb,
    "is_active" boolean default true
      );


alter table "public"."programs" enable row level security;


  create table "public"."quiz_attempts" (
    "id" uuid not null default gen_random_uuid(),
    "quiz_id" uuid not null,
    "user_id" uuid not null,
    "attempt_number" integer not null default 1,
    "status" public.quiz_attempt_status default 'in_progress'::public.quiz_attempt_status,
    "score" numeric(5,2) default 0.00,
    "points_earned" integer default 0,
    "points_possible" integer default 0,
    "passed" boolean default false,
    "started_at" timestamp with time zone default now(),
    "submitted_at" timestamp with time zone,
    "time_taken_minutes" integer,
    "answers" jsonb default '[]'::jsonb,
    "instructor_feedback" text,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );


alter table "public"."quiz_attempts" enable row level security;


  create table "public"."quiz_question_options" (
    "id" uuid not null default gen_random_uuid(),
    "question_id" uuid not null,
    "option_text" text not null,
    "is_correct" boolean default false,
    "order_index" integer not null default 0,
    "feedback" text,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );


alter table "public"."quiz_question_options" enable row level security;


  create table "public"."quiz_questions" (
    "id" uuid not null default gen_random_uuid(),
    "quiz_id" uuid not null,
    "question_text" text not null,
    "question_type" public.question_type not null,
    "order_index" integer not null default 0,
    "points" integer not null default 1,
    "hint" text,
    "explanation" text,
    "required" boolean default true,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );


alter table "public"."quiz_questions" enable row level security;


  create table "public"."recommendation_clicks" (
    "id" uuid not null default gen_random_uuid(),
    "impression_id" uuid not null,
    "student_id" uuid not null,
    "university_id" integer not null,
    "action_type" character varying(50) not null,
    "time_to_click_seconds" integer,
    "device_type" character varying(20),
    "referrer" character varying(255),
    "clicked_at" timestamp with time zone not null default now(),
    "created_at" timestamp with time zone not null default now()
      );


alter table "public"."recommendation_clicks" enable row level security;


  create table "public"."recommendation_feedback" (
    "id" uuid not null default gen_random_uuid(),
    "student_id" uuid not null,
    "university_id" integer not null,
    "impression_id" uuid,
    "feedback_type" character varying(50) not null,
    "rating" integer,
    "comment" text,
    "reasons" jsonb,
    "submitted_at" timestamp with time zone not null default now(),
    "created_at" timestamp with time zone not null default now()
      );


alter table "public"."recommendation_feedback" enable row level security;


  create table "public"."recommendation_impressions" (
    "id" uuid not null default gen_random_uuid(),
    "student_id" uuid not null,
    "university_id" integer not null,
    "match_score" numeric(5,2),
    "category" character varying(20),
    "position" integer,
    "recommendation_session_id" uuid,
    "source" character varying(50) default 'dashboard'::character varying,
    "match_reasons" jsonb,
    "match_explanation" text,
    "shown_at" timestamp with time zone not null default now(),
    "created_at" timestamp with time zone not null default now()
      );


alter table "public"."recommendation_impressions" enable row level security;


  create table "public"."recommendation_letters" (
    "id" uuid not null default gen_random_uuid(),
    "student_id" uuid not null,
    "counselor_id" uuid not null,
    "student_name" text not null,
    "student_email" text not null,
    "institution_name" text not null,
    "program_name" text not null,
    "status" text default 'pending'::text,
    "content" text,
    "requested_date" timestamp with time zone default now(),
    "submitted_date" timestamp with time zone,
    "deadline" timestamp with time zone
      );


alter table "public"."recommendation_letters" enable row level security;


  create table "public"."recommendation_reminders" (
    "id" uuid not null default gen_random_uuid(),
    "request_id" uuid not null,
    "reminder_type" character varying(50) not null,
    "days_before_deadline" integer,
    "sent_at" timestamp with time zone,
    "is_sent" boolean default false,
    "message" text,
    "created_at" timestamp with time zone not null default now()
      );


alter table "public"."recommendation_reminders" enable row level security;


  create table "public"."recommendation_requests" (
    "id" uuid not null default gen_random_uuid(),
    "student_id" uuid not null,
    "recommender_id" uuid,
    "request_type" character varying(50) not null,
    "purpose" text not null,
    "institution_name" character varying(255),
    "deadline" date not null,
    "status" character varying(20) default 'pending'::character varying,
    "priority" character varying(20) default 'normal'::character varying,
    "student_message" text,
    "achievements" text,
    "goals" text,
    "relationship_context" text,
    "accepted_at" timestamp with time zone,
    "declined_at" timestamp with time zone,
    "decline_reason" text,
    "requested_at" timestamp with time zone not null default now(),
    "completed_at" timestamp with time zone,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now(),
    "recommender_email" character varying(255),
    "recommender_name" character varying(255)
      );


alter table "public"."recommendation_requests" enable row level security;


  create table "public"."recommendation_templates" (
    "id" uuid not null default gen_random_uuid(),
    "name" character varying(255) not null,
    "description" text,
    "category" character varying(50) not null,
    "content" text not null,
    "custom_fields" jsonb default '[]'::jsonb,
    "usage_count" integer default 0,
    "is_public" boolean default true,
    "created_by" uuid,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
      );


alter table "public"."recommendation_templates" enable row level security;


  create table "public"."recommendations" (
    "id" bigint not null default nextval('public.recommendations_id_seq'::regclass),
    "student_id" bigint not null,
    "university_id" bigint not null,
    "match_score" double precision not null,
    "category" character varying(20) not null,
    "academic_score" double precision,
    "financial_score" double precision,
    "program_score" double precision,
    "location_score" double precision,
    "characteristics_score" double precision,
    "strengths" jsonb,
    "concerns" jsonb,
    "favorited" integer default 0,
    "notes" text,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );


alter table "public"."recommendations" enable row level security;


  create table "public"."scheduled_report_executions" (
    "id" uuid not null default gen_random_uuid(),
    "scheduled_report_id" uuid not null,
    "status" text not null,
    "started_at" timestamp with time zone,
    "completed_at" timestamp with time zone,
    "error_message" text,
    "report_data" jsonb,
    "file_url" text,
    "recipients_notified" text[],
    "created_at" timestamp with time zone default now()
      );


alter table "public"."scheduled_report_executions" enable row level security;


  create table "public"."scheduled_reports" (
    "id" uuid not null default gen_random_uuid(),
    "title" text not null,
    "description" text,
    "frequency" text not null,
    "format" text not null,
    "recipients" text[] not null,
    "metrics" text[] not null,
    "next_run_at" timestamp with time zone not null,
    "last_run_at" timestamp with time zone,
    "is_active" boolean default true,
    "created_by" uuid,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );


alter table "public"."scheduled_reports" enable row level security;


  create table "public"."staff_availability" (
    "id" uuid not null default gen_random_uuid(),
    "staff_id" uuid not null,
    "day_of_week" integer not null,
    "start_time" time without time zone not null,
    "end_time" time without time zone not null,
    "is_active" boolean not null default true,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
      );


alter table "public"."staff_availability" enable row level security;


  create table "public"."student_activities" (
    "id" uuid not null default gen_random_uuid(),
    "student_id" uuid not null,
    "activity_type" character varying(50) not null,
    "title" character varying(255) not null,
    "description" text not null,
    "icon" character varying(10) not null,
    "related_entity_id" uuid,
    "metadata" jsonb default '{}'::jsonb,
    "timestamp" timestamp with time zone not null default now(),
    "created_at" timestamp with time zone not null default now()
      );


alter table "public"."student_activities" enable row level security;


  create table "public"."student_counselor_assignments" (
    "id" uuid not null default extensions.uuid_generate_v4(),
    "student_id" uuid not null,
    "counselor_id" uuid not null,
    "assigned_by" uuid,
    "is_active" boolean default true,
    "assigned_at" timestamp with time zone default now(),
    "ended_at" timestamp with time zone,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );



  create table "public"."student_interaction_summary" (
    "id" uuid not null default gen_random_uuid(),
    "student_id" uuid not null,
    "total_impressions" integer default 0,
    "total_clicks" integer default 0,
    "total_applications" integer default 0,
    "total_favorites" integer default 0,
    "ctr_percentage" numeric(5,2),
    "preferred_categories" jsonb,
    "preferred_locations" jsonb,
    "preferred_cost_range" jsonb,
    "last_interaction_at" timestamp with time zone,
    "updated_at" timestamp with time zone not null default now(),
    "created_at" timestamp with time zone not null default now()
      );


alter table "public"."student_interaction_summary" enable row level security;


  create table "public"."student_invite_codes" (
    "id" uuid not null default gen_random_uuid(),
    "code" character varying(12) not null,
    "student_id" uuid not null,
    "expires_at" timestamp with time zone not null,
    "max_uses" integer not null default 1,
    "uses_remaining" integer not null default 1,
    "is_active" boolean not null default true,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );


alter table "public"."student_invite_codes" enable row level security;


  create table "public"."student_profiles" (
    "id" bigint not null default nextval('public.student_profiles_id_seq'::regclass),
    "user_id" character varying(100) not null,
    "grading_system" character varying(50),
    "grade_value" character varying(20),
    "nationality" character varying(10),
    "current_country" character varying(10),
    "current_region" character varying(100),
    "standardized_test_type" character varying(50),
    "test_scores" jsonb,
    "gpa" double precision,
    "sat_total" integer,
    "sat_math" integer,
    "sat_ebrw" integer,
    "act_composite" integer,
    "class_rank" integer,
    "class_size" integer,
    "intended_major" character varying(100),
    "field_of_study" character varying(100),
    "career_goals" text,
    "alternative_majors" jsonb,
    "career_focused" integer default 1,
    "research_opportunities" integer default 0,
    "preferred_states" jsonb,
    "preferred_regions" jsonb,
    "preferred_countries" jsonb,
    "location_type_preference" character varying(50),
    "budget_range" character varying(50),
    "max_budget_per_year" double precision,
    "need_financial_aid" integer default 0,
    "eligible_for_in_state" character varying(50),
    "preferred_university_type" character varying(50),
    "university_size_preference" character varying(100),
    "university_type_preference" character varying(100),
    "preferred_size" character varying(50),
    "interested_in_sports" integer default 0,
    "sports_important" integer default 0,
    "features_desired" jsonb,
    "deal_breakers" jsonb,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );


alter table "public"."student_profiles" enable row level security;


  create table "public"."student_records" (
    "id" uuid not null default gen_random_uuid(),
    "student_id" uuid not null,
    "counselor_id" uuid not null,
    "grade" text,
    "gpa" numeric(3,2),
    "school_name" text,
    "interests" text[],
    "strengths" text[],
    "challenges" text[],
    "total_sessions" integer default 0,
    "last_session_date" timestamp with time zone,
    "status" text default 'active'::text,
    "goals" text[],
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now()
      );


alter table "public"."student_records" enable row level security;


  create table "public"."support_tickets" (
    "id" uuid not null default gen_random_uuid(),
    "user_id" uuid,
    "user_name" text,
    "user_email" text,
    "subject" text not null,
    "description" text,
    "category" text default 'general'::text,
    "priority" text default 'medium'::text,
    "status" text default 'open'::text,
    "assigned_to" uuid,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now(),
    "resolved_at" timestamp with time zone
      );


alter table "public"."support_tickets" enable row level security;


  create table "public"."system_logs" (
    "id" bigint not null default nextval('public.system_logs_id_seq'::regclass),
    "timestamp" timestamp without time zone not null default now(),
    "level" text not null,
    "logger_name" text not null,
    "message" text not null,
    "module" text,
    "function_name" text,
    "line_number" integer,
    "exception_type" text,
    "exception_message" text,
    "stack_trace" text,
    "extra_data" jsonb default '{}'::jsonb,
    "process_id" integer,
    "thread_id" bigint,
    "created_at" timestamp without time zone default now()
      );



  create table "public"."transactions" (
    "id" uuid not null default gen_random_uuid(),
    "user_id" uuid,
    "user_name" text,
    "type" text not null,
    "amount" numeric(10,2) not null,
    "currency" text default 'USD'::text,
    "status" text default 'completed'::text,
    "description" text,
    "metadata" jsonb default '{}'::jsonb,
    "created_at" timestamp with time zone default now()
      );


alter table "public"."transactions" enable row level security;


  create table "public"."typing_indicators" (
    "id" uuid not null default gen_random_uuid(),
    "conversation_id" uuid not null,
    "user_id" uuid not null,
    "is_typing" boolean default true,
    "created_at" timestamp with time zone default now(),
    "expires_at" timestamp with time zone default (now() + '00:00:10'::interval)
      );


alter table "public"."typing_indicators" enable row level security;


  create table "public"."universities" (
    "id" bigint not null default nextval('public.universities_id_seq'::regclass),
    "name" character varying(255) not null,
    "country" character varying(100) not null,
    "state" character varying(100),
    "city" character varying(100),
    "website" character varying(255),
    "logo_url" character varying(500),
    "description" text,
    "university_type" character varying(50),
    "location_type" character varying(50),
    "total_students" integer,
    "global_rank" integer,
    "national_rank" integer,
    "acceptance_rate" double precision,
    "gpa_average" double precision,
    "sat_math_25th" integer,
    "sat_math_75th" integer,
    "sat_ebrw_25th" integer,
    "sat_ebrw_75th" integer,
    "act_composite_25th" integer,
    "act_composite_75th" integer,
    "tuition_out_state" double precision,
    "total_cost" double precision,
    "graduation_rate_4year" double precision,
    "median_earnings_10year" double precision,
    "created_at" timestamp with time zone default now(),
    "updated_at" timestamp with time zone default now(),
    "data_sources" jsonb default '{}'::jsonb,
    "data_confidence" jsonb default '{}'::jsonb,
    "last_scraped_at" timestamp without time zone,
    "field_last_updated" jsonb default '{}'::jsonb
      );



  create table "public"."users" (
    "id" uuid not null,
    "email" text not null,
    "display_name" text,
    "phone_number" text,
    "photo_url" text,
    "active_role" text not null default 'student'::text,
    "available_roles" text[] not null default ARRAY['student'::text],
    "created_at" timestamp with time zone default now(),
    "last_login_at" timestamp with time zone,
    "email_verified" boolean default false,
    "phone_verified" boolean default false,
    "metadata" jsonb default '{}'::jsonb,
    "updated_at" timestamp with time zone default now(),
    "profile_completed" boolean default false,
    "onboarding_completed" boolean default false,
    "preferences" jsonb default '{}'::jsonb,
    "institution_id" uuid,
    "school" character varying(255),
    "grade" character varying(50),
    "graduation_year" integer,
    "institution_type" character varying(100),
    "location" character varying(255),
    "website" character varying(255),
    "programs_count" integer default 0,
    "specialty" character varying(255),
    "students_count" integer default 0,
    "sessions_count" integer default 0,
    "years_experience" integer,
    "recommender_type" character varying(100),
    "organization" character varying(255),
    "position" character varying(255),
    "requests_count" integer default 0,
    "completed_count" integer default 0,
    "children_count" integer default 0,
    "occupation" character varying(255),
    "bio" text,
    "address" character varying(500),
    "city" character varying(100),
    "country" character varying(100),
    "is_active" boolean default true
      );


alter table "public"."users" enable row level security;

alter sequence "public"."enrichment_cache_id_seq" owned by "public"."enrichment_cache"."id";

alter sequence "public"."programs_id_seq" owned by "public"."programs"."id";

alter sequence "public"."recommendations_id_seq" owned by "public"."recommendations"."id";

alter sequence "public"."student_profiles_id_seq" owned by "public"."student_profiles"."id";

alter sequence "public"."system_logs_id_seq" owned by "public"."system_logs"."id";

alter sequence "public"."universities_id_seq" owned by "public"."universities"."id";

CREATE UNIQUE INDEX achievements_pkey ON public.achievements USING btree (id);

CREATE UNIQUE INDEX activity_log_pkey ON public.activity_log USING btree (id);

CREATE UNIQUE INDEX admin_users_pkey ON public.admin_users USING btree (id);

CREATE UNIQUE INDEX app_config_pkey ON public.app_config USING btree (key);

CREATE UNIQUE INDEX applications_pkey ON public.applications USING btree (id);

CREATE UNIQUE INDEX assignment_submissions_pkey ON public.assignment_submissions USING btree (id);

CREATE UNIQUE INDEX chatbot_conversations_pkey ON public.chatbot_conversations USING btree (id);

CREATE UNIQUE INDEX chatbot_faqs_pkey ON public.chatbot_faqs USING btree (id);

CREATE UNIQUE INDEX chatbot_feedback_analytics_pkey ON public.chatbot_feedback_analytics USING btree (id);

CREATE UNIQUE INDEX chatbot_messages_pkey ON public.chatbot_messages USING btree (id);

CREATE UNIQUE INDEX chatbot_support_queue_pkey ON public.chatbot_support_queue USING btree (id);

CREATE UNIQUE INDEX children_pkey ON public.children USING btree (id);

CREATE UNIQUE INDEX communication_campaigns_pkey ON public.communication_campaigns USING btree (id);

CREATE UNIQUE INDEX content_assignments_pkey ON public.content_assignments USING btree (id);

CREATE UNIQUE INDEX conversations_pkey ON public.conversations USING btree (id);

CREATE UNIQUE INDEX cookie_consents_pkey ON public.cookie_consents USING btree (id);

CREATE UNIQUE INDEX counseling_sessions_pkey ON public.counseling_sessions USING btree (id);

CREATE UNIQUE INDEX course_lessons_pkey ON public.course_lessons USING btree (id);

CREATE UNIQUE INDEX course_modules_pkey ON public.course_modules USING btree (id);

CREATE UNIQUE INDEX courses_pkey ON public.courses USING btree (id);

CREATE UNIQUE INDEX documents_pkey ON public.documents USING btree (id);

CREATE UNIQUE INDEX enrichment_cache_pkey ON public.enrichment_cache USING btree (id);

CREATE UNIQUE INDEX enrichment_jobs_pkey ON public.enrichment_jobs USING btree (job_id);

CREATE UNIQUE INDEX enrollment_permissions_pkey ON public.enrollment_permissions USING btree (id);

CREATE UNIQUE INDEX enrollments_pkey ON public.enrollments USING btree (id);

CREATE UNIQUE INDEX gpa_history_pkey ON public.gpa_history USING btree (id);

CREATE UNIQUE INDEX grade_alerts_pkey ON public.grade_alerts USING btree (id);

CREATE UNIQUE INDEX grades_pkey ON public.grades USING btree (id);

CREATE INDEX idx_achievements_category ON public.achievements USING btree (category);

CREATE INDEX idx_achievements_earned_at ON public.achievements USING btree (earned_at DESC);

CREATE INDEX idx_achievements_student_earned ON public.achievements USING btree (student_id, earned_at DESC);

CREATE INDEX idx_achievements_student_id ON public.achievements USING btree (student_id);

CREATE INDEX idx_activity_log_action_type ON public.activity_log USING btree (action_type);

CREATE INDEX idx_activity_log_created_at ON public.activity_log USING btree (created_at DESC);

CREATE INDEX idx_activity_log_timestamp ON public.activity_log USING btree ("timestamp" DESC);

CREATE INDEX idx_activity_log_user_action ON public.activity_log USING btree (user_id, action_type, "timestamp" DESC);

CREATE INDEX idx_activity_log_user_id ON public.activity_log USING btree (user_id);

CREATE INDEX idx_alerts_child ON public.parent_alerts USING btree (child_id);

CREATE INDEX idx_alerts_parent ON public.parent_alerts USING btree (parent_id);

CREATE INDEX idx_alerts_read ON public.parent_alerts USING btree (is_read);

CREATE INDEX idx_app_config_key ON public.app_config USING btree (key);

CREATE INDEX idx_applications_institution ON public.applications USING btree (institution_id);

CREATE INDEX idx_applications_program ON public.applications USING btree (program_id);

CREATE INDEX idx_applications_status ON public.applications USING btree (status);

CREATE INDEX idx_applications_student ON public.applications USING btree (student_id);

CREATE INDEX idx_assignment_submissions_assignment_id ON public.assignment_submissions USING btree (assignment_id);

CREATE INDEX idx_assignment_submissions_graded_by ON public.assignment_submissions USING btree (graded_by);

CREATE INDEX idx_assignment_submissions_status ON public.assignment_submissions USING btree (status);

CREATE INDEX idx_assignment_submissions_submitted_at ON public.assignment_submissions USING btree (submitted_at);

CREATE INDEX idx_assignment_submissions_user_id ON public.assignment_submissions USING btree (user_id);

CREATE INDEX idx_assignments_counselor ON public.student_counselor_assignments USING btree (counselor_id);

CREATE INDEX idx_assignments_student ON public.student_counselor_assignments USING btree (student_id);

CREATE UNIQUE INDEX idx_chatbot_analytics_date ON public.chatbot_feedback_analytics USING btree (date);

CREATE INDEX idx_chatbot_conversations_created_at ON public.chatbot_conversations USING btree (created_at DESC);

CREATE INDEX idx_chatbot_conversations_status ON public.chatbot_conversations USING btree (status);

CREATE INDEX idx_chatbot_conversations_user_id ON public.chatbot_conversations USING btree (user_id);

CREATE INDEX idx_chatbot_faqs_category ON public.chatbot_faqs USING btree (category);

CREATE INDEX idx_chatbot_faqs_is_active ON public.chatbot_faqs USING btree (is_active);

CREATE INDEX idx_chatbot_faqs_priority ON public.chatbot_faqs USING btree (priority DESC);

CREATE INDEX idx_chatbot_messages_conversation_id ON public.chatbot_messages USING btree (conversation_id);

CREATE INDEX idx_chatbot_messages_created_at ON public.chatbot_messages USING btree (created_at);

CREATE INDEX idx_chatbot_messages_feedback ON public.chatbot_messages USING btree (feedback) WHERE (feedback IS NOT NULL);

CREATE INDEX idx_chatbot_messages_sender ON public.chatbot_messages USING btree (sender);

CREATE INDEX idx_chatbot_support_queue_conversation_id ON public.chatbot_support_queue USING btree (conversation_id);

CREATE INDEX idx_chatbot_support_queue_status ON public.chatbot_support_queue USING btree (status);

CREATE INDEX idx_chatbot_user ON public.chatbot_conversations USING btree (user_id);

CREATE INDEX idx_children_parent ON public.children USING btree (parent_id);

CREATE INDEX idx_children_student ON public.children USING btree (student_id);

CREATE INDEX idx_clicks_action_type ON public.recommendation_clicks USING btree (action_type);

CREATE INDEX idx_clicks_clicked_at ON public.recommendation_clicks USING btree (clicked_at DESC);

CREATE INDEX idx_clicks_device_type ON public.recommendation_clicks USING btree (device_type);

CREATE INDEX idx_clicks_impression_id ON public.recommendation_clicks USING btree (impression_id);

CREATE INDEX idx_clicks_student_id ON public.recommendation_clicks USING btree (student_id);

CREATE INDEX idx_clicks_student_university_perf ON public.recommendation_clicks USING btree (student_id, university_id);

CREATE INDEX idx_clicks_time_to_click ON public.recommendation_clicks USING btree (time_to_click_seconds) WHERE (time_to_click_seconds IS NOT NULL);

CREATE INDEX idx_clicks_university_id ON public.recommendation_clicks USING btree (university_id);

CREATE INDEX idx_communication_campaigns_created_at ON public.communication_campaigns USING btree (created_at DESC);

CREATE INDEX idx_communication_campaigns_status ON public.communication_campaigns USING btree (status);

CREATE INDEX idx_communication_campaigns_type ON public.communication_campaigns USING btree (type);

CREATE INDEX idx_content_assignments_content ON public.content_assignments USING btree (content_id);

CREATE INDEX idx_content_assignments_content_id ON public.content_assignments USING btree (content_id);

CREATE INDEX idx_content_assignments_status ON public.content_assignments USING btree (status);

CREATE INDEX idx_content_assignments_target ON public.content_assignments USING btree (target_id, target_type);

CREATE INDEX idx_content_assignments_target_id ON public.content_assignments USING btree (target_id);

CREATE INDEX idx_content_assignments_target_type ON public.content_assignments USING btree (target_type);

CREATE INDEX idx_conversations_last_message ON public.conversations USING btree (last_message_at DESC NULLS LAST);

CREATE INDEX idx_conversations_participant_ids ON public.conversations USING gin (participant_ids);

CREATE INDEX idx_conversations_participant_ids_gin ON public.conversations USING gin (participant_ids);

CREATE INDEX idx_conversations_participants ON public.conversations USING gin (participant_ids);

CREATE INDEX idx_cookie_session ON public.cookie_consents USING btree (session_id);

CREATE INDEX idx_cookie_user ON public.cookie_consents USING btree (user_id);

CREATE INDEX idx_counseling_sessions_counselor ON public.counseling_sessions USING btree (counselor_id);

CREATE INDEX idx_counseling_sessions_student ON public.counseling_sessions USING btree (student_id);

CREATE INDEX idx_course_lessons_created_at ON public.course_lessons USING btree (created_at);

CREATE INDEX idx_course_lessons_module_id ON public.course_lessons USING btree (module_id);

CREATE INDEX idx_course_lessons_order ON public.course_lessons USING btree (module_id, order_index);

CREATE INDEX idx_course_lessons_published ON public.course_lessons USING btree (module_id, is_published);

CREATE INDEX idx_course_lessons_type ON public.course_lessons USING btree (lesson_type);

CREATE INDEX idx_course_lessons_updated_at ON public.course_lessons USING btree (updated_at);

CREATE INDEX idx_course_modules_course_id ON public.course_modules USING btree (course_id);

CREATE INDEX idx_course_modules_created_at ON public.course_modules USING btree (created_at);

CREATE INDEX idx_course_modules_order ON public.course_modules USING btree (course_id, order_index);

CREATE INDEX idx_course_modules_published ON public.course_modules USING btree (course_id, is_published);

CREATE INDEX idx_course_modules_updated_at ON public.course_modules USING btree (updated_at);

CREATE INDEX idx_courses_category ON public.courses USING btree (category);

CREATE INDEX idx_courses_course_type ON public.courses USING btree (course_type);

CREATE INDEX idx_courses_created_at ON public.courses USING btree (created_at DESC);

CREATE INDEX idx_courses_enrolled_count ON public.courses USING btree (enrolled_count DESC);

CREATE INDEX idx_courses_institution_id ON public.courses USING btree (institution_id);

CREATE INDEX idx_courses_institution_published_perf ON public.courses USING btree (institution_id, is_published, created_at DESC);

CREATE INDEX idx_courses_is_published ON public.courses USING btree (is_published);

CREATE INDEX idx_courses_level ON public.courses USING btree (level);

CREATE INDEX idx_courses_module_count ON public.courses USING btree (module_count);

CREATE INDEX idx_courses_price_perf ON public.courses USING btree (price) WHERE (price IS NOT NULL);

CREATE INDEX idx_courses_rating_perf ON public.courses USING btree (rating) WHERE (rating IS NOT NULL);

CREATE INDEX idx_courses_status ON public.courses USING btree (status);

CREATE INDEX idx_courses_title_search ON public.courses USING gin (to_tsvector('english'::regconfig, (title)::text));

CREATE INDEX idx_documents_category ON public.documents USING btree (category);

CREATE INDEX idx_documents_related_entity ON public.documents USING btree (related_entity_type, related_entity_id);

CREATE INDEX idx_documents_uploaded_by ON public.documents USING btree (uploaded_by);

CREATE INDEX idx_enrichment_cache_expires_at ON public.enrichment_cache USING btree (expires_at);

CREATE INDEX idx_enrichment_cache_source ON public.enrichment_cache USING btree (data_source);

CREATE UNIQUE INDEX idx_enrichment_cache_uni_field ON public.enrichment_cache USING btree (university_id, field_name);

CREATE INDEX idx_enrichment_cache_university ON public.enrichment_cache USING btree (university_id);

CREATE INDEX idx_enrichment_jobs_cleanup ON public.enrichment_jobs USING btree (status, completed_at) WHERE (status = ANY (ARRAY['completed'::text, 'failed'::text, 'cancelled'::text]));

CREATE INDEX idx_enrichment_jobs_created_at ON public.enrichment_jobs USING btree (created_at DESC);

CREATE INDEX idx_enrichment_jobs_status ON public.enrichment_jobs USING btree (status);

CREATE INDEX idx_enrichment_jobs_status_created ON public.enrichment_jobs USING btree (status, created_at DESC);

CREATE INDEX idx_enrollment_permissions_course ON public.enrollment_permissions USING btree (course_id);

CREATE INDEX idx_enrollment_permissions_course_id ON public.enrollment_permissions USING btree (course_id);

CREATE INDEX idx_enrollment_permissions_course_status ON public.enrollment_permissions USING btree (course_id, status);

CREATE INDEX idx_enrollment_permissions_institution ON public.enrollment_permissions USING btree (institution_id);

CREATE INDEX idx_enrollment_permissions_institution_id ON public.enrollment_permissions USING btree (institution_id);

CREATE INDEX idx_enrollment_permissions_status ON public.enrollment_permissions USING btree (status);

CREATE INDEX idx_enrollment_permissions_student ON public.enrollment_permissions USING btree (student_id);

CREATE INDEX idx_enrollment_permissions_student_course ON public.enrollment_permissions USING btree (student_id, course_id);

CREATE INDEX idx_enrollment_permissions_student_id ON public.enrollment_permissions USING btree (student_id);

CREATE INDEX idx_enrollment_permissions_student_status ON public.enrollment_permissions USING btree (student_id, status);

CREATE INDEX idx_enrollments_completed_at_perf ON public.enrollments USING btree (completed_at DESC) WHERE (completed_at IS NOT NULL);

CREATE INDEX idx_enrollments_course_id ON public.enrollments USING btree (course_id);

CREATE INDEX idx_enrollments_enrolled_at ON public.enrollments USING btree (enrolled_at DESC);

CREATE INDEX idx_enrollments_last_accessed ON public.enrollments USING btree (last_accessed_at DESC) WHERE (last_accessed_at IS NOT NULL);

CREATE INDEX idx_enrollments_progress_perf ON public.enrollments USING btree (progress_percentage) WHERE ((status)::text = 'active'::text);

CREATE INDEX idx_enrollments_status ON public.enrollments USING btree (status);

CREATE INDEX idx_enrollments_student_id ON public.enrollments USING btree (student_id);

CREATE INDEX idx_enrollments_student_status ON public.enrollments USING btree (student_id, status);

CREATE INDEX idx_feedback_reasons ON public.recommendation_feedback USING gin (reasons);

CREATE INDEX idx_feedback_student_id ON public.recommendation_feedback USING btree (student_id);

CREATE INDEX idx_feedback_student_university_perf ON public.recommendation_feedback USING btree (student_id, university_id);

CREATE INDEX idx_feedback_submitted_at ON public.recommendation_feedback USING btree (submitted_at DESC);

CREATE INDEX idx_feedback_type ON public.recommendation_feedback USING btree (feedback_type);

CREATE INDEX idx_feedback_university_id ON public.recommendation_feedback USING btree (university_id);

CREATE INDEX idx_gpa_history_school_year ON public.gpa_history USING btree (school_year);

CREATE INDEX idx_gpa_history_student_id ON public.gpa_history USING btree (student_id);

CREATE INDEX idx_grade_alerts_created_at ON public.grade_alerts USING btree (created_at DESC);

CREATE INDEX idx_grade_alerts_is_read ON public.grade_alerts USING btree (is_read);

CREATE INDEX idx_grade_alerts_parent_id ON public.grade_alerts USING btree (parent_id);

CREATE INDEX idx_grade_alerts_student_id ON public.grade_alerts USING btree (student_id);

CREATE INDEX idx_grades_category ON public.grades USING btree (category);

CREATE INDEX idx_grades_course_id ON public.grades USING btree (course_id);

CREATE INDEX idx_grades_enrollment_id ON public.grades USING btree (enrollment_id);

CREATE INDEX idx_grades_graded_date ON public.grades USING btree (graded_date DESC);

CREATE INDEX idx_grades_student_id ON public.grades USING btree (student_id);

CREATE INDEX idx_impressions_category ON public.recommendation_impressions USING btree (category);

CREATE INDEX idx_impressions_match_reasons ON public.recommendation_impressions USING gin (match_reasons);

CREATE INDEX idx_impressions_recommendation_session_id ON public.recommendation_impressions USING btree (recommendation_session_id);

CREATE INDEX idx_impressions_session_id ON public.recommendation_impressions USING btree (recommendation_session_id);

CREATE INDEX idx_impressions_shown_at ON public.recommendation_impressions USING btree (shown_at DESC);

CREATE INDEX idx_impressions_source ON public.recommendation_impressions USING btree (source);

CREATE INDEX idx_impressions_student_id ON public.recommendation_impressions USING btree (student_id);

CREATE INDEX idx_impressions_student_shown ON public.recommendation_impressions USING btree (student_id, shown_at DESC);

CREATE INDEX idx_impressions_university_id ON public.recommendation_impressions USING btree (university_id);

CREATE INDEX idx_institution_programs_category ON public.institution_programs USING btree (category);

CREATE INDEX idx_institution_programs_institution ON public.institution_programs USING btree (institution_id);

CREATE INDEX idx_institution_programs_is_active ON public.institution_programs USING btree (is_active);

CREATE INDEX idx_interaction_ctr ON public.student_interaction_summary USING btree (ctr_percentage DESC) WHERE (ctr_percentage IS NOT NULL);

CREATE INDEX idx_interaction_preferred_categories ON public.student_interaction_summary USING gin (preferred_categories);

CREATE INDEX idx_interaction_preferred_locations ON public.student_interaction_summary USING gin (preferred_locations);

CREATE INDEX idx_interaction_summary_last_interaction ON public.student_interaction_summary USING btree (last_interaction_at DESC);

CREATE INDEX idx_interaction_summary_student_id ON public.student_interaction_summary USING btree (student_id);

CREATE INDEX idx_lesson_assignments_due_date ON public.lesson_assignments USING btree (due_date);

CREATE INDEX idx_lesson_assignments_lesson_id ON public.lesson_assignments USING btree (lesson_id);

CREATE INDEX idx_lesson_completions_completed_at ON public.lesson_completions USING btree (completed_at);

CREATE INDEX idx_lesson_completions_lesson_id ON public.lesson_completions USING btree (lesson_id);

CREATE INDEX idx_lesson_completions_user_id ON public.lesson_completions USING btree (user_id);

CREATE INDEX idx_lesson_completions_user_lesson ON public.lesson_completions USING btree (user_id, lesson_id);

CREATE INDEX idx_lesson_quizzes_lesson_id ON public.lesson_quizzes USING btree (lesson_id);

CREATE INDEX idx_lesson_texts_format ON public.lesson_texts USING btree (content_format);

CREATE INDEX idx_lesson_texts_lesson_id ON public.lesson_texts USING btree (lesson_id);

CREATE INDEX idx_lesson_videos_lesson_id ON public.lesson_videos USING btree (lesson_id);

CREATE INDEX idx_lesson_videos_platform ON public.lesson_videos USING btree (video_platform);

CREATE INDEX idx_letter_of_recommendations_request_id ON public.letter_of_recommendations USING btree (request_id);

CREATE INDEX idx_letter_of_recommendations_status ON public.letter_of_recommendations USING btree (status);

CREATE INDEX idx_letter_of_recommendations_template_id ON public.letter_of_recommendations USING btree (template_id);

CREATE INDEX idx_meetings_created_at ON public.meetings USING btree (created_at DESC);

CREATE INDEX idx_meetings_parent_id ON public.meetings USING btree (parent_id);

CREATE INDEX idx_meetings_parent_status ON public.meetings USING btree (parent_id, status);

CREATE INDEX idx_meetings_scheduled_date ON public.meetings USING btree (scheduled_date);

CREATE INDEX idx_meetings_scheduled_upcoming ON public.meetings USING btree (scheduled_date, status) WHERE (status = 'approved'::text);

CREATE INDEX idx_meetings_staff_id ON public.meetings USING btree (staff_id);

CREATE INDEX idx_meetings_staff_status ON public.meetings USING btree (staff_id, status);

CREATE INDEX idx_meetings_status ON public.meetings USING btree (status);

CREATE INDEX idx_meetings_student_id ON public.meetings USING btree (student_id);

CREATE INDEX idx_messages_conversation ON public.messages USING btree (conversation_id, "timestamp" DESC);

CREATE INDEX idx_notification_preferences_type ON public.notification_preferences USING btree (notification_type);

CREATE INDEX idx_notification_preferences_user_id ON public.notification_preferences USING btree (user_id);

CREATE INDEX idx_notifications_created ON public.notifications USING btree (created_at DESC);

CREATE INDEX idx_notifications_created_at ON public.notifications USING btree (created_at DESC);

CREATE INDEX idx_notifications_metadata ON public.notifications USING gin (metadata);

CREATE INDEX idx_notifications_read ON public.notifications USING btree (user_id, is_read);

CREATE INDEX idx_notifications_type ON public.notifications USING btree (type);

CREATE INDEX idx_notifications_user ON public.notifications USING btree (user_id);

CREATE INDEX idx_notifications_user_created ON public.notifications USING btree (user_id, created_at DESC) WHERE (deleted_at IS NULL);

CREATE INDEX idx_notifications_user_id ON public.notifications USING btree (user_id);

CREATE INDEX idx_notifications_user_unread ON public.notifications USING btree (user_id, is_read) WHERE (deleted_at IS NULL);

CREATE INDEX idx_page_cache_expires_at ON public.page_cache USING btree (expires_at);

CREATE INDEX idx_page_cache_url ON public.page_cache USING btree (url);

CREATE INDEX idx_page_contents_slug ON public.page_contents USING btree (page_slug);

CREATE INDEX idx_page_contents_status ON public.page_contents USING btree (status);

CREATE INDEX idx_parent_children_child_id ON public.parent_children USING btree (child_id);

CREATE INDEX idx_parent_children_parent_id ON public.parent_children USING btree (parent_id);

CREATE INDEX idx_parent_student_links_parent_id ON public.parent_student_links USING btree (parent_id);

CREATE INDEX idx_parent_student_links_status ON public.parent_student_links USING btree (status);

CREATE INDEX idx_parent_student_links_student_id ON public.parent_student_links USING btree (student_id);

CREATE INDEX idx_payments_created ON public.payments USING btree (created_at DESC);

CREATE INDEX idx_payments_status ON public.payments USING btree (status);

CREATE INDEX idx_payments_transaction ON public.payments USING btree (transaction_id);

CREATE INDEX idx_payments_user ON public.payments USING btree (user_id);

CREATE INDEX idx_programs_application_deadline ON public.programs USING btree (application_deadline);

CREATE INDEX idx_programs_application_deadline_optimized ON public.programs USING btree (application_deadline) WHERE (application_deadline IS NOT NULL);

CREATE INDEX idx_programs_category ON public.programs USING btree (category);

CREATE INDEX idx_programs_category_institution ON public.programs USING btree (category, institution_id);

CREATE INDEX idx_programs_created_at ON public.programs USING btree (created_at DESC);

CREATE INDEX idx_programs_fee ON public.programs USING btree (fee) WHERE (fee IS NOT NULL);

CREATE INDEX idx_programs_field ON public.programs USING btree (field);

CREATE INDEX idx_programs_institution_active ON public.programs USING btree (institution_id, is_active, created_at DESC);

CREATE INDEX idx_programs_institution_id ON public.programs USING btree (institution_id);

CREATE INDEX idx_programs_is_active ON public.programs USING btree (is_active);

CREATE INDEX idx_programs_is_active_optimized ON public.programs USING btree (is_active) WHERE (is_active = true);

CREATE INDEX idx_programs_level ON public.programs USING btree (level);

CREATE INDEX idx_programs_level_optimized ON public.programs USING btree (level) WHERE (level IS NOT NULL);

CREATE INDEX idx_programs_name_search ON public.programs USING gin (to_tsvector('english'::regconfig, (name)::text));

CREATE INDEX idx_programs_requirements ON public.programs USING gin (requirements);

CREATE INDEX idx_programs_start_date ON public.programs USING btree (start_date);

CREATE INDEX idx_quiz_attempts_quiz_id ON public.quiz_attempts USING btree (quiz_id);

CREATE INDEX idx_quiz_attempts_status ON public.quiz_attempts USING btree (status);

CREATE INDEX idx_quiz_attempts_submitted_at ON public.quiz_attempts USING btree (submitted_at);

CREATE INDEX idx_quiz_attempts_user_id ON public.quiz_attempts USING btree (user_id);

CREATE INDEX idx_quiz_attempts_user_quiz ON public.quiz_attempts USING btree (user_id, quiz_id);

CREATE INDEX idx_quiz_question_options_order ON public.quiz_question_options USING btree (question_id, order_index);

CREATE INDEX idx_quiz_question_options_question_id ON public.quiz_question_options USING btree (question_id);

CREATE INDEX idx_quiz_questions_order ON public.quiz_questions USING btree (quiz_id, order_index);

CREATE INDEX idx_quiz_questions_quiz_id ON public.quiz_questions USING btree (quiz_id);

CREATE INDEX idx_quiz_questions_type ON public.quiz_questions USING btree (question_type);

CREATE INDEX idx_recommendation_reminders_is_sent ON public.recommendation_reminders USING btree (is_sent);

CREATE INDEX idx_recommendation_reminders_request_id ON public.recommendation_reminders USING btree (request_id);

CREATE INDEX idx_recommendation_requests_deadline ON public.recommendation_requests USING btree (deadline);

CREATE INDEX idx_recommendation_requests_recommender_id ON public.recommendation_requests USING btree (recommender_id);

CREATE INDEX idx_recommendation_requests_requested_at ON public.recommendation_requests USING btree (requested_at DESC);

CREATE INDEX idx_recommendation_requests_status ON public.recommendation_requests USING btree (status);

CREATE INDEX idx_recommendation_requests_student_id ON public.recommendation_requests USING btree (student_id);

CREATE INDEX idx_recommendation_templates_category ON public.recommendation_templates USING btree (category);

CREATE INDEX idx_recommendation_templates_created_by ON public.recommendation_templates USING btree (created_by);

CREATE INDEX idx_recommendation_templates_is_public ON public.recommendation_templates USING btree (is_public);

CREATE INDEX idx_recommendations_academic_score ON public.recommendations USING btree (academic_score) WHERE (academic_score IS NOT NULL);

CREATE INDEX idx_recommendations_category ON public.recommendations USING btree (category) WHERE (category IS NOT NULL);

CREATE INDEX idx_recommendations_created_at ON public.recommendations USING btree (student_id, created_at DESC);

CREATE INDEX idx_recommendations_favorited ON public.recommendations USING btree (favorited) WHERE (favorited = 1);

CREATE INDEX idx_recommendations_financial_score ON public.recommendations USING btree (financial_score) WHERE (financial_score IS NOT NULL);

CREATE INDEX idx_recommendations_match_score ON public.recommendations USING btree (match_score);

CREATE INDEX idx_recommendations_program_score ON public.recommendations USING btree (program_score) WHERE (program_score IS NOT NULL);

CREATE INDEX idx_recommendations_student_category ON public.recommendations USING btree (student_id, category, match_score DESC);

CREATE INDEX idx_recommendations_student_id ON public.recommendations USING btree (student_id);

CREATE INDEX idx_recommendations_student_score ON public.recommendations USING btree (student_id, match_score DESC);

CREATE INDEX idx_recommendations_university_id ON public.recommendations USING btree (university_id);

CREATE INDEX idx_recommendations_university_id_optimized ON public.recommendations USING btree (university_id);

CREATE INDEX idx_report_executions_scheduled_report ON public.scheduled_report_executions USING btree (scheduled_report_id);

CREATE INDEX idx_report_executions_status ON public.scheduled_report_executions USING btree (status);

CREATE INDEX idx_scheduled_reports_created_by ON public.scheduled_reports USING btree (created_by);

CREATE INDEX idx_scheduled_reports_next_run ON public.scheduled_reports USING btree (next_run_at) WHERE (is_active = true);

CREATE INDEX idx_sessions_counselor ON public.counseling_sessions USING btree (counselor_id);

CREATE INDEX idx_sessions_date ON public.counseling_sessions USING btree (scheduled_date);

CREATE INDEX idx_sessions_status ON public.counseling_sessions USING btree (status);

CREATE INDEX idx_sessions_student ON public.counseling_sessions USING btree (student_id);

CREATE INDEX idx_staff_availability_day_of_week ON public.staff_availability USING btree (day_of_week);

CREATE INDEX idx_staff_availability_is_active ON public.staff_availability USING btree (is_active);

CREATE INDEX idx_staff_availability_staff_active ON public.staff_availability USING btree (staff_id, is_active);

CREATE INDEX idx_staff_availability_staff_id ON public.staff_availability USING btree (staff_id);

CREATE INDEX idx_student_activities_student_id ON public.student_activities USING btree (student_id);

CREATE INDEX idx_student_activities_student_timestamp ON public.student_activities USING btree (student_id, "timestamp" DESC);

CREATE INDEX idx_student_activities_timestamp ON public.student_activities USING btree ("timestamp" DESC);

CREATE INDEX idx_student_activities_type ON public.student_activities USING btree (activity_type);

CREATE INDEX idx_student_invite_codes_code ON public.student_invite_codes USING btree (code);

CREATE INDEX idx_student_invite_codes_student_id ON public.student_invite_codes USING btree (student_id);

CREATE INDEX idx_student_profiles_act_composite ON public.student_profiles USING btree (act_composite) WHERE (act_composite IS NOT NULL);

CREATE INDEX idx_student_profiles_field_of_study ON public.student_profiles USING btree (field_of_study) WHERE (field_of_study IS NOT NULL);

CREATE INDEX idx_student_profiles_gpa ON public.student_profiles USING btree (gpa) WHERE (gpa IS NOT NULL);

CREATE INDEX idx_student_profiles_grading_system ON public.student_profiles USING btree (grading_system) WHERE (grading_system IS NOT NULL);

CREATE INDEX idx_student_profiles_intended_major ON public.student_profiles USING btree (intended_major) WHERE (intended_major IS NOT NULL);

CREATE INDEX idx_student_profiles_nationality ON public.student_profiles USING btree (nationality) WHERE (nationality IS NOT NULL);

CREATE INDEX idx_student_profiles_preferred_countries ON public.student_profiles USING gin (preferred_countries);

CREATE INDEX idx_student_profiles_sat_total ON public.student_profiles USING btree (sat_total) WHERE (sat_total IS NOT NULL);

CREATE INDEX idx_student_profiles_test_scores ON public.student_profiles USING gin (test_scores);

CREATE INDEX idx_student_profiles_user_id ON public.student_profiles USING btree (user_id);

CREATE INDEX idx_student_records_counselor ON public.student_records USING btree (counselor_id);

CREATE INDEX idx_student_records_student ON public.student_records USING btree (student_id);

CREATE INDEX idx_support_tickets_assigned_to ON public.support_tickets USING btree (assigned_to);

CREATE INDEX idx_support_tickets_created_at ON public.support_tickets USING btree (created_at DESC);

CREATE INDEX idx_support_tickets_priority ON public.support_tickets USING btree (priority);

CREATE INDEX idx_support_tickets_status ON public.support_tickets USING btree (status);

CREATE INDEX idx_support_tickets_user_id ON public.support_tickets USING btree (user_id);

CREATE INDEX idx_system_logs_errors ON public.system_logs USING btree ("timestamp" DESC) WHERE (level = ANY (ARRAY['ERROR'::text, 'CRITICAL'::text]));

CREATE INDEX idx_system_logs_level ON public.system_logs USING btree (level);

CREATE INDEX idx_system_logs_logger ON public.system_logs USING btree (logger_name);

CREATE INDEX idx_system_logs_logger_level_time ON public.system_logs USING btree (logger_name, level, "timestamp" DESC);

CREATE INDEX idx_system_logs_timestamp ON public.system_logs USING btree ("timestamp" DESC);

CREATE INDEX idx_transactions_created_at ON public.transactions USING btree (created_at DESC);

CREATE INDEX idx_transactions_status ON public.transactions USING btree (status);

CREATE INDEX idx_transactions_type ON public.transactions USING btree (type);

CREATE INDEX idx_transactions_user_id ON public.transactions USING btree (user_id);

CREATE INDEX idx_typing_indicators_conversation ON public.typing_indicators USING btree (conversation_id);

CREATE INDEX idx_typing_indicators_expires ON public.typing_indicators USING btree (expires_at);

CREATE INDEX idx_universities_acceptance_rate ON public.universities USING btree (acceptance_rate) WHERE (acceptance_rate IS NOT NULL);

CREATE INDEX idx_universities_country ON public.universities USING btree (country);

CREATE INDEX idx_universities_country_state ON public.universities USING btree (country, state);

CREATE INDEX idx_universities_data_sources ON public.universities USING gin (data_sources);

CREATE INDEX idx_universities_field_updates ON public.universities USING gin (field_last_updated);

CREATE INDEX idx_universities_filters ON public.universities USING btree (country, university_type, acceptance_rate, total_cost) WHERE (country IS NOT NULL);

CREATE INDEX idx_universities_global_rank ON public.universities USING btree (global_rank);

CREATE INDEX idx_universities_gpa_average ON public.universities USING btree (gpa_average) WHERE (gpa_average IS NOT NULL);

CREATE INDEX idx_universities_graduation_rate ON public.universities USING btree (graduation_rate_4year) WHERE (graduation_rate_4year IS NOT NULL);

CREATE INDEX idx_universities_last_scraped ON public.universities USING btree (last_scraped_at);

CREATE INDEX idx_universities_location_type ON public.universities USING btree (location_type) WHERE (location_type IS NOT NULL);

CREATE INDEX idx_universities_median_earnings ON public.universities USING btree (median_earnings_10year) WHERE (median_earnings_10year IS NOT NULL);

CREATE INDEX idx_universities_name ON public.universities USING btree (name);

CREATE INDEX idx_universities_name_country ON public.universities USING btree (name, country);

CREATE INDEX idx_universities_name_search ON public.universities USING gin (to_tsvector('english'::regconfig, (name)::text));

CREATE INDEX idx_universities_national_rank ON public.universities USING btree (national_rank) WHERE (national_rank IS NOT NULL);

CREATE INDEX idx_universities_sat_math ON public.universities USING btree (sat_math_25th, sat_math_75th) WHERE (sat_math_25th IS NOT NULL);

CREATE INDEX idx_universities_total_cost ON public.universities USING btree (total_cost) WHERE (total_cost IS NOT NULL);

CREATE INDEX idx_universities_total_students ON public.universities USING btree (total_students) WHERE (total_students IS NOT NULL);

CREATE INDEX idx_universities_tuition ON public.universities USING btree (tuition_out_state) WHERE (tuition_out_state IS NOT NULL);

CREATE INDEX idx_universities_type ON public.universities USING btree (university_type) WHERE (university_type IS NOT NULL);

CREATE INDEX idx_users_active_role ON public.users USING btree (active_role);

CREATE INDEX idx_users_email ON public.users USING btree (email);

CREATE INDEX idx_users_institution_type ON public.users USING btree (institution_type);

CREATE INDEX idx_users_is_active ON public.users USING btree (is_active);

CREATE INDEX idx_users_location ON public.users USING btree (location);

CREATE INDEX idx_users_school ON public.users USING btree (school);

CREATE INDEX idx_users_specialty ON public.users USING btree (specialty);

CREATE UNIQUE INDEX institution_programs_pkey ON public.institution_programs USING btree (id);

CREATE UNIQUE INDEX lesson_assignments_lesson_id_key ON public.lesson_assignments USING btree (lesson_id);

CREATE UNIQUE INDEX lesson_assignments_pkey ON public.lesson_assignments USING btree (id);

CREATE UNIQUE INDEX lesson_completions_pkey ON public.lesson_completions USING btree (id);

CREATE UNIQUE INDEX lesson_quizzes_lesson_id_key ON public.lesson_quizzes USING btree (lesson_id);

CREATE UNIQUE INDEX lesson_quizzes_pkey ON public.lesson_quizzes USING btree (id);

CREATE UNIQUE INDEX lesson_texts_lesson_id_key ON public.lesson_texts USING btree (lesson_id);

CREATE UNIQUE INDEX lesson_texts_pkey ON public.lesson_texts USING btree (id);

CREATE UNIQUE INDEX lesson_videos_lesson_id_key ON public.lesson_videos USING btree (lesson_id);

CREATE UNIQUE INDEX lesson_videos_pkey ON public.lesson_videos USING btree (id);

CREATE UNIQUE INDEX letter_of_recommendations_pkey ON public.letter_of_recommendations USING btree (id);

CREATE UNIQUE INDEX letter_of_recommendations_share_token_key ON public.letter_of_recommendations USING btree (share_token);

CREATE UNIQUE INDEX meetings_pkey ON public.meetings USING btree (id);

CREATE UNIQUE INDEX messages_pkey ON public.messages USING btree (id);

CREATE UNIQUE INDEX notification_preferences_pkey ON public.notification_preferences USING btree (id);

CREATE UNIQUE INDEX notification_preferences_user_id_notification_type_key ON public.notification_preferences USING btree (user_id, notification_type);

CREATE UNIQUE INDEX notifications_pkey ON public.notifications USING btree (id);

CREATE UNIQUE INDEX page_cache_pkey ON public.page_cache USING btree (url_hash);

CREATE UNIQUE INDEX page_contents_page_slug_key ON public.page_contents USING btree (page_slug);

CREATE UNIQUE INDEX page_contents_pkey ON public.page_contents USING btree (id);

CREATE UNIQUE INDEX parent_alerts_pkey ON public.parent_alerts USING btree (id);

CREATE UNIQUE INDEX parent_children_pkey ON public.parent_children USING btree (id);

CREATE UNIQUE INDEX parent_student_links_parent_id_student_id_key ON public.parent_student_links USING btree (parent_id, student_id);

CREATE UNIQUE INDEX parent_student_links_pkey ON public.parent_student_links USING btree (id);

CREATE UNIQUE INDEX payments_pkey ON public.payments USING btree (id);

CREATE UNIQUE INDEX payments_transaction_id_key ON public.payments USING btree (transaction_id);

CREATE UNIQUE INDEX programs_pkey ON public.programs USING btree (id);

CREATE UNIQUE INDEX quiz_attempts_pkey ON public.quiz_attempts USING btree (id);

CREATE UNIQUE INDEX quiz_question_options_pkey ON public.quiz_question_options USING btree (id);

CREATE UNIQUE INDEX quiz_questions_pkey ON public.quiz_questions USING btree (id);

CREATE UNIQUE INDEX recommendation_clicks_pkey ON public.recommendation_clicks USING btree (id);

CREATE UNIQUE INDEX recommendation_feedback_pkey ON public.recommendation_feedback USING btree (id);

CREATE UNIQUE INDEX recommendation_impressions_pkey ON public.recommendation_impressions USING btree (id);

CREATE UNIQUE INDEX recommendation_letters_pkey ON public.recommendation_letters USING btree (id);

CREATE UNIQUE INDEX recommendation_reminders_pkey ON public.recommendation_reminders USING btree (id);

CREATE UNIQUE INDEX recommendation_requests_pkey ON public.recommendation_requests USING btree (id);

CREATE UNIQUE INDEX recommendation_templates_pkey ON public.recommendation_templates USING btree (id);

CREATE UNIQUE INDEX recommendations_pkey ON public.recommendations USING btree (id);

CREATE UNIQUE INDEX scheduled_report_executions_pkey ON public.scheduled_report_executions USING btree (id);

CREATE UNIQUE INDEX scheduled_reports_pkey ON public.scheduled_reports USING btree (id);

CREATE UNIQUE INDEX staff_availability_pkey ON public.staff_availability USING btree (id);

CREATE UNIQUE INDEX student_activities_pkey ON public.student_activities USING btree (id);

CREATE UNIQUE INDEX student_counselor_assignments_pkey ON public.student_counselor_assignments USING btree (id);

CREATE UNIQUE INDEX student_counselor_assignments_student_id_counselor_id_key ON public.student_counselor_assignments USING btree (student_id, counselor_id);

CREATE UNIQUE INDEX student_interaction_summary_pkey ON public.student_interaction_summary USING btree (id);

CREATE UNIQUE INDEX student_interaction_summary_student_id_key ON public.student_interaction_summary USING btree (student_id);

CREATE UNIQUE INDEX student_invite_codes_code_key ON public.student_invite_codes USING btree (code);

CREATE UNIQUE INDEX student_invite_codes_pkey ON public.student_invite_codes USING btree (id);

CREATE UNIQUE INDEX student_profiles_pkey ON public.student_profiles USING btree (id);

CREATE UNIQUE INDEX student_profiles_user_id_key ON public.student_profiles USING btree (user_id);

CREATE UNIQUE INDEX student_records_pkey ON public.student_records USING btree (id);

CREATE UNIQUE INDEX student_records_student_id_counselor_id_key ON public.student_records USING btree (student_id, counselor_id);

CREATE UNIQUE INDEX support_tickets_pkey ON public.support_tickets USING btree (id);

CREATE UNIQUE INDEX system_logs_pkey ON public.system_logs USING btree (id);

CREATE UNIQUE INDEX transactions_pkey ON public.transactions USING btree (id);

CREATE UNIQUE INDEX typing_indicators_conversation_id_user_id_key ON public.typing_indicators USING btree (conversation_id, user_id);

CREATE UNIQUE INDEX typing_indicators_pkey ON public.typing_indicators USING btree (id);

CREATE UNIQUE INDEX unique_assignment_user ON public.assignment_submissions USING btree (assignment_id, user_id);

CREATE UNIQUE INDEX unique_course_order ON public.course_modules USING btree (course_id, order_index);

CREATE UNIQUE INDEX unique_lesson_user ON public.lesson_completions USING btree (lesson_id, user_id);

CREATE UNIQUE INDEX unique_module_order ON public.course_lessons USING btree (module_id, order_index);

CREATE UNIQUE INDEX unique_parent_child ON public.parent_children USING btree (parent_id, child_id);

CREATE UNIQUE INDEX unique_question_order ON public.quiz_question_options USING btree (question_id, order_index);

CREATE UNIQUE INDEX unique_quiz_order ON public.quiz_questions USING btree (quiz_id, order_index);

CREATE UNIQUE INDEX unique_staff_day ON public.staff_availability USING btree (staff_id, day_of_week);

CREATE UNIQUE INDEX unique_student_course ON public.enrollments USING btree (student_id, course_id);

CREATE UNIQUE INDEX unique_student_course_permission ON public.enrollment_permissions USING btree (student_id, course_id);

CREATE UNIQUE INDEX universities_pkey ON public.universities USING btree (id);

CREATE UNIQUE INDEX users_email_key ON public.users USING btree (email);

CREATE UNIQUE INDEX users_pkey ON public.users USING btree (id);

alter table "public"."achievements" add constraint "achievements_pkey" PRIMARY KEY using index "achievements_pkey";

alter table "public"."activity_log" add constraint "activity_log_pkey" PRIMARY KEY using index "activity_log_pkey";

alter table "public"."admin_users" add constraint "admin_users_pkey" PRIMARY KEY using index "admin_users_pkey";

alter table "public"."app_config" add constraint "app_config_pkey" PRIMARY KEY using index "app_config_pkey";

alter table "public"."applications" add constraint "applications_pkey" PRIMARY KEY using index "applications_pkey";

alter table "public"."assignment_submissions" add constraint "assignment_submissions_pkey" PRIMARY KEY using index "assignment_submissions_pkey";

alter table "public"."chatbot_conversations" add constraint "chatbot_conversations_pkey" PRIMARY KEY using index "chatbot_conversations_pkey";

alter table "public"."chatbot_faqs" add constraint "chatbot_faqs_pkey" PRIMARY KEY using index "chatbot_faqs_pkey";

alter table "public"."chatbot_feedback_analytics" add constraint "chatbot_feedback_analytics_pkey" PRIMARY KEY using index "chatbot_feedback_analytics_pkey";

alter table "public"."chatbot_messages" add constraint "chatbot_messages_pkey" PRIMARY KEY using index "chatbot_messages_pkey";

alter table "public"."chatbot_support_queue" add constraint "chatbot_support_queue_pkey" PRIMARY KEY using index "chatbot_support_queue_pkey";

alter table "public"."children" add constraint "children_pkey" PRIMARY KEY using index "children_pkey";

alter table "public"."communication_campaigns" add constraint "communication_campaigns_pkey" PRIMARY KEY using index "communication_campaigns_pkey";

alter table "public"."content_assignments" add constraint "content_assignments_pkey" PRIMARY KEY using index "content_assignments_pkey";

alter table "public"."conversations" add constraint "conversations_pkey" PRIMARY KEY using index "conversations_pkey";

alter table "public"."cookie_consents" add constraint "cookie_consents_pkey" PRIMARY KEY using index "cookie_consents_pkey";

alter table "public"."counseling_sessions" add constraint "counseling_sessions_pkey" PRIMARY KEY using index "counseling_sessions_pkey";

alter table "public"."course_lessons" add constraint "course_lessons_pkey" PRIMARY KEY using index "course_lessons_pkey";

alter table "public"."course_modules" add constraint "course_modules_pkey" PRIMARY KEY using index "course_modules_pkey";

alter table "public"."courses" add constraint "courses_pkey" PRIMARY KEY using index "courses_pkey";

alter table "public"."documents" add constraint "documents_pkey" PRIMARY KEY using index "documents_pkey";

alter table "public"."enrichment_cache" add constraint "enrichment_cache_pkey" PRIMARY KEY using index "enrichment_cache_pkey";

alter table "public"."enrichment_jobs" add constraint "enrichment_jobs_pkey" PRIMARY KEY using index "enrichment_jobs_pkey";

alter table "public"."enrollment_permissions" add constraint "enrollment_permissions_pkey" PRIMARY KEY using index "enrollment_permissions_pkey";

alter table "public"."enrollments" add constraint "enrollments_pkey" PRIMARY KEY using index "enrollments_pkey";

alter table "public"."gpa_history" add constraint "gpa_history_pkey" PRIMARY KEY using index "gpa_history_pkey";

alter table "public"."grade_alerts" add constraint "grade_alerts_pkey" PRIMARY KEY using index "grade_alerts_pkey";

alter table "public"."grades" add constraint "grades_pkey" PRIMARY KEY using index "grades_pkey";

alter table "public"."institution_programs" add constraint "institution_programs_pkey" PRIMARY KEY using index "institution_programs_pkey";

alter table "public"."lesson_assignments" add constraint "lesson_assignments_pkey" PRIMARY KEY using index "lesson_assignments_pkey";

alter table "public"."lesson_completions" add constraint "lesson_completions_pkey" PRIMARY KEY using index "lesson_completions_pkey";

alter table "public"."lesson_quizzes" add constraint "lesson_quizzes_pkey" PRIMARY KEY using index "lesson_quizzes_pkey";

alter table "public"."lesson_texts" add constraint "lesson_texts_pkey" PRIMARY KEY using index "lesson_texts_pkey";

alter table "public"."lesson_videos" add constraint "lesson_videos_pkey" PRIMARY KEY using index "lesson_videos_pkey";

alter table "public"."letter_of_recommendations" add constraint "letter_of_recommendations_pkey" PRIMARY KEY using index "letter_of_recommendations_pkey";

alter table "public"."meetings" add constraint "meetings_pkey" PRIMARY KEY using index "meetings_pkey";

alter table "public"."messages" add constraint "messages_pkey" PRIMARY KEY using index "messages_pkey";

alter table "public"."notification_preferences" add constraint "notification_preferences_pkey" PRIMARY KEY using index "notification_preferences_pkey";

alter table "public"."notifications" add constraint "notifications_pkey" PRIMARY KEY using index "notifications_pkey";

alter table "public"."page_cache" add constraint "page_cache_pkey" PRIMARY KEY using index "page_cache_pkey";

alter table "public"."page_contents" add constraint "page_contents_pkey" PRIMARY KEY using index "page_contents_pkey";

alter table "public"."parent_alerts" add constraint "parent_alerts_pkey" PRIMARY KEY using index "parent_alerts_pkey";

alter table "public"."parent_children" add constraint "parent_children_pkey" PRIMARY KEY using index "parent_children_pkey";

alter table "public"."parent_student_links" add constraint "parent_student_links_pkey" PRIMARY KEY using index "parent_student_links_pkey";

alter table "public"."payments" add constraint "payments_pkey" PRIMARY KEY using index "payments_pkey";

alter table "public"."programs" add constraint "programs_pkey" PRIMARY KEY using index "programs_pkey";

alter table "public"."quiz_attempts" add constraint "quiz_attempts_pkey" PRIMARY KEY using index "quiz_attempts_pkey";

alter table "public"."quiz_question_options" add constraint "quiz_question_options_pkey" PRIMARY KEY using index "quiz_question_options_pkey";

alter table "public"."quiz_questions" add constraint "quiz_questions_pkey" PRIMARY KEY using index "quiz_questions_pkey";

alter table "public"."recommendation_clicks" add constraint "recommendation_clicks_pkey" PRIMARY KEY using index "recommendation_clicks_pkey";

alter table "public"."recommendation_feedback" add constraint "recommendation_feedback_pkey" PRIMARY KEY using index "recommendation_feedback_pkey";

alter table "public"."recommendation_impressions" add constraint "recommendation_impressions_pkey" PRIMARY KEY using index "recommendation_impressions_pkey";

alter table "public"."recommendation_letters" add constraint "recommendation_letters_pkey" PRIMARY KEY using index "recommendation_letters_pkey";

alter table "public"."recommendation_reminders" add constraint "recommendation_reminders_pkey" PRIMARY KEY using index "recommendation_reminders_pkey";

alter table "public"."recommendation_requests" add constraint "recommendation_requests_pkey" PRIMARY KEY using index "recommendation_requests_pkey";

alter table "public"."recommendation_templates" add constraint "recommendation_templates_pkey" PRIMARY KEY using index "recommendation_templates_pkey";

alter table "public"."recommendations" add constraint "recommendations_pkey" PRIMARY KEY using index "recommendations_pkey";

alter table "public"."scheduled_report_executions" add constraint "scheduled_report_executions_pkey" PRIMARY KEY using index "scheduled_report_executions_pkey";

alter table "public"."scheduled_reports" add constraint "scheduled_reports_pkey" PRIMARY KEY using index "scheduled_reports_pkey";

alter table "public"."staff_availability" add constraint "staff_availability_pkey" PRIMARY KEY using index "staff_availability_pkey";

alter table "public"."student_activities" add constraint "student_activities_pkey" PRIMARY KEY using index "student_activities_pkey";

alter table "public"."student_counselor_assignments" add constraint "student_counselor_assignments_pkey" PRIMARY KEY using index "student_counselor_assignments_pkey";

alter table "public"."student_interaction_summary" add constraint "student_interaction_summary_pkey" PRIMARY KEY using index "student_interaction_summary_pkey";

alter table "public"."student_invite_codes" add constraint "student_invite_codes_pkey" PRIMARY KEY using index "student_invite_codes_pkey";

alter table "public"."student_profiles" add constraint "student_profiles_pkey" PRIMARY KEY using index "student_profiles_pkey";

alter table "public"."student_records" add constraint "student_records_pkey" PRIMARY KEY using index "student_records_pkey";

alter table "public"."support_tickets" add constraint "support_tickets_pkey" PRIMARY KEY using index "support_tickets_pkey";

alter table "public"."system_logs" add constraint "system_logs_pkey" PRIMARY KEY using index "system_logs_pkey";

alter table "public"."transactions" add constraint "transactions_pkey" PRIMARY KEY using index "transactions_pkey";

alter table "public"."typing_indicators" add constraint "typing_indicators_pkey" PRIMARY KEY using index "typing_indicators_pkey";

alter table "public"."universities" add constraint "universities_pkey" PRIMARY KEY using index "universities_pkey";

alter table "public"."users" add constraint "users_pkey" PRIMARY KEY using index "users_pkey";

alter table "public"."achievements" add constraint "achievements_student_id_fkey" FOREIGN KEY (student_id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."achievements" validate constraint "achievements_student_id_fkey";

alter table "public"."activity_log" add constraint "activity_log_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE SET NULL not valid;

alter table "public"."activity_log" validate constraint "activity_log_user_id_fkey";

alter table "public"."admin_users" add constraint "admin_users_admin_role_check" CHECK ((admin_role = ANY (ARRAY['superadmin'::text, 'regionaladmin'::text, 'contentadmin'::text, 'supportadmin'::text, 'financeadmin'::text, 'analyticsadmin'::text]))) not valid;

alter table "public"."admin_users" validate constraint "admin_users_admin_role_check";

alter table "public"."admin_users" add constraint "admin_users_id_fkey" FOREIGN KEY (id) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."admin_users" validate constraint "admin_users_id_fkey";

alter table "public"."applications" add constraint "applications_institution_id_fkey" FOREIGN KEY (institution_id) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."applications" validate constraint "applications_institution_id_fkey";

alter table "public"."applications" add constraint "applications_reviewed_by_fkey" FOREIGN KEY (reviewed_by) REFERENCES public.users(id) ON DELETE SET NULL not valid;

alter table "public"."applications" validate constraint "applications_reviewed_by_fkey";

alter table "public"."applications" add constraint "applications_status_check" CHECK ((status = ANY (ARRAY['pending'::text, 'under_review'::text, 'accepted'::text, 'rejected'::text, 'waitlisted'::text, 'withdrawn'::text]))) not valid;

alter table "public"."applications" validate constraint "applications_status_check";

alter table "public"."applications" add constraint "applications_student_id_fkey" FOREIGN KEY (student_id) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."applications" validate constraint "applications_student_id_fkey";

alter table "public"."applications" add constraint "check_application_type" CHECK ((application_type = ANY (ARRAY['undergraduate'::text, 'graduate'::text, 'certificate'::text, 'diploma'::text, 'exchange'::text]))) not valid;

alter table "public"."applications" validate constraint "check_application_type";

alter table "public"."assignment_submissions" add constraint "assignment_submissions_assignment_id_fkey" FOREIGN KEY (assignment_id) REFERENCES public.lesson_assignments(id) ON DELETE CASCADE not valid;

alter table "public"."assignment_submissions" validate constraint "assignment_submissions_assignment_id_fkey";

alter table "public"."assignment_submissions" add constraint "assignment_submissions_graded_by_fkey" FOREIGN KEY (graded_by) REFERENCES public.users(id) not valid;

alter table "public"."assignment_submissions" validate constraint "assignment_submissions_graded_by_fkey";

alter table "public"."assignment_submissions" add constraint "assignment_submissions_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."assignment_submissions" validate constraint "assignment_submissions_user_id_fkey";

alter table "public"."assignment_submissions" add constraint "unique_assignment_user" UNIQUE using index "unique_assignment_user";

alter table "public"."assignment_submissions" add constraint "valid_grade_percentage" CHECK (((grade_percentage IS NULL) OR ((grade_percentage >= (0)::numeric) AND (grade_percentage <= (100)::numeric)))) not valid;

alter table "public"."assignment_submissions" validate constraint "valid_grade_percentage";

alter table "public"."assignment_submissions" add constraint "valid_late_days" CHECK ((late_days >= 0)) not valid;

alter table "public"."assignment_submissions" validate constraint "valid_late_days";

alter table "public"."assignment_submissions" add constraint "valid_late_penalty" CHECK (((late_penalty_applied >= (0)::numeric) AND (late_penalty_applied <= (100)::numeric))) not valid;

alter table "public"."assignment_submissions" validate constraint "valid_late_penalty";

alter table "public"."assignment_submissions" add constraint "valid_points_earned" CHECK (((points_earned IS NULL) OR (points_earned >= (0)::numeric))) not valid;

alter table "public"."assignment_submissions" validate constraint "valid_points_earned";

alter table "public"."assignment_submissions" add constraint "valid_points_possible" CHECK (((points_possible IS NULL) OR (points_possible >= 0))) not valid;

alter table "public"."assignment_submissions" validate constraint "valid_points_possible";

alter table "public"."chatbot_conversations" add constraint "chatbot_conversations_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."chatbot_conversations" validate constraint "chatbot_conversations_user_id_fkey";

alter table "public"."chatbot_faqs" add constraint "chatbot_faqs_created_by_fkey" FOREIGN KEY (created_by) REFERENCES public.users(id) not valid;

alter table "public"."chatbot_faqs" validate constraint "chatbot_faqs_created_by_fkey";

alter table "public"."chatbot_messages" add constraint "chatbot_messages_conversation_id_fkey" FOREIGN KEY (conversation_id) REFERENCES public.chatbot_conversations(id) ON DELETE CASCADE not valid;

alter table "public"."chatbot_messages" validate constraint "chatbot_messages_conversation_id_fkey";

alter table "public"."chatbot_support_queue" add constraint "chatbot_support_queue_assigned_to_fkey" FOREIGN KEY (assigned_to) REFERENCES public.users(id) ON DELETE SET NULL not valid;

alter table "public"."chatbot_support_queue" validate constraint "chatbot_support_queue_assigned_to_fkey";

alter table "public"."chatbot_support_queue" add constraint "chatbot_support_queue_conversation_id_fkey" FOREIGN KEY (conversation_id) REFERENCES public.chatbot_conversations(id) ON DELETE CASCADE not valid;

alter table "public"."chatbot_support_queue" validate constraint "chatbot_support_queue_conversation_id_fkey";

alter table "public"."children" add constraint "children_average_grade_check" CHECK (((average_grade >= (0)::numeric) AND (average_grade <= (100)::numeric))) not valid;

alter table "public"."children" validate constraint "children_average_grade_check";

alter table "public"."children" add constraint "children_parent_id_fkey" FOREIGN KEY (parent_id) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."children" validate constraint "children_parent_id_fkey";

alter table "public"."children" add constraint "children_student_id_fkey" FOREIGN KEY (student_id) REFERENCES public.users(id) ON DELETE SET NULL not valid;

alter table "public"."children" validate constraint "children_student_id_fkey";

alter table "public"."communication_campaigns" add constraint "communication_campaigns_created_by_fkey" FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL not valid;

alter table "public"."communication_campaigns" validate constraint "communication_campaigns_created_by_fkey";

alter table "public"."content_assignments" add constraint "content_assignments_content_id_fkey" FOREIGN KEY (content_id) REFERENCES public.courses(id) not valid;

alter table "public"."content_assignments" validate constraint "content_assignments_content_id_fkey";

alter table "public"."cookie_consents" add constraint "cookie_consents_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."cookie_consents" validate constraint "cookie_consents_user_id_fkey";

alter table "public"."counseling_sessions" add constraint "counseling_sessions_counselor_id_fkey" FOREIGN KEY (counselor_id) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."counseling_sessions" validate constraint "counseling_sessions_counselor_id_fkey";

alter table "public"."counseling_sessions" add constraint "counseling_sessions_duration_minutes_check" CHECK ((duration_minutes > 0)) not valid;

alter table "public"."counseling_sessions" validate constraint "counseling_sessions_duration_minutes_check";

alter table "public"."counseling_sessions" add constraint "counseling_sessions_status_check" CHECK ((status = ANY (ARRAY['scheduled'::text, 'completed'::text, 'cancelled'::text, 'no_show'::text]))) not valid;

alter table "public"."counseling_sessions" validate constraint "counseling_sessions_status_check";

alter table "public"."counseling_sessions" add constraint "counseling_sessions_student_id_fkey" FOREIGN KEY (student_id) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."counseling_sessions" validate constraint "counseling_sessions_student_id_fkey";

alter table "public"."counseling_sessions" add constraint "counseling_sessions_type_check" CHECK ((type = ANY (ARRAY['individual'::text, 'group'::text, 'career'::text, 'academic'::text, 'personal'::text]))) not valid;

alter table "public"."counseling_sessions" validate constraint "counseling_sessions_type_check";

alter table "public"."course_lessons" add constraint "course_lessons_module_id_fkey" FOREIGN KEY (module_id) REFERENCES public.course_modules(id) ON DELETE CASCADE not valid;

alter table "public"."course_lessons" validate constraint "course_lessons_module_id_fkey";

alter table "public"."course_lessons" add constraint "unique_module_order" UNIQUE using index "unique_module_order";

alter table "public"."course_lessons" add constraint "valid_duration" CHECK ((duration_minutes >= 0)) not valid;

alter table "public"."course_lessons" validate constraint "valid_duration";

alter table "public"."course_lessons" add constraint "valid_order_index" CHECK ((order_index >= 0)) not valid;

alter table "public"."course_lessons" validate constraint "valid_order_index";

alter table "public"."course_modules" add constraint "course_modules_course_id_fkey" FOREIGN KEY (course_id) REFERENCES public.courses(id) ON DELETE CASCADE not valid;

alter table "public"."course_modules" validate constraint "course_modules_course_id_fkey";

alter table "public"."course_modules" add constraint "unique_course_order" UNIQUE using index "unique_course_order";

alter table "public"."course_modules" add constraint "valid_duration" CHECK ((duration_minutes >= 0)) not valid;

alter table "public"."course_modules" validate constraint "valid_duration";

alter table "public"."course_modules" add constraint "valid_lesson_count" CHECK ((lesson_count >= 0)) not valid;

alter table "public"."course_modules" validate constraint "valid_lesson_count";

alter table "public"."course_modules" add constraint "valid_order_index" CHECK ((order_index >= 0)) not valid;

alter table "public"."course_modules" validate constraint "valid_order_index";

alter table "public"."courses" add constraint "courses_course_type_check" CHECK (((course_type)::text = ANY ((ARRAY['video'::character varying, 'text'::character varying, 'interactive'::character varying, 'live'::character varying, 'hybrid'::character varying])::text[]))) not valid;

alter table "public"."courses" validate constraint "courses_course_type_check";

alter table "public"."courses" add constraint "courses_level_check" CHECK (((level)::text = ANY ((ARRAY['beginner'::character varying, 'intermediate'::character varying, 'advanced'::character varying, 'expert'::character varying])::text[]))) not valid;

alter table "public"."courses" validate constraint "courses_level_check";

alter table "public"."courses" add constraint "courses_status_check" CHECK (((status)::text = ANY ((ARRAY['draft'::character varying, 'published'::character varying, 'archived'::character varying])::text[]))) not valid;

alter table "public"."courses" validate constraint "courses_status_check";

alter table "public"."courses" add constraint "published_status_match" CHECK ((((is_published = true) AND ((status)::text = 'published'::text)) OR ((is_published = false) AND ((status)::text <> 'published'::text)))) not valid;

alter table "public"."courses" validate constraint "published_status_match";

alter table "public"."courses" add constraint "valid_enrolled_count" CHECK ((enrolled_count >= 0)) not valid;

alter table "public"."courses" validate constraint "valid_enrolled_count";

alter table "public"."courses" add constraint "valid_module_count" CHECK ((module_count >= 0)) not valid;

alter table "public"."courses" validate constraint "valid_module_count";

alter table "public"."courses" add constraint "valid_price" CHECK ((price >= (0)::numeric)) not valid;

alter table "public"."courses" validate constraint "valid_price";

alter table "public"."courses" add constraint "valid_rating" CHECK (((rating IS NULL) OR ((rating >= (0)::numeric) AND (rating <= (5)::numeric)))) not valid;

alter table "public"."courses" validate constraint "valid_rating";

alter table "public"."courses" add constraint "valid_review_count" CHECK ((review_count >= 0)) not valid;

alter table "public"."courses" validate constraint "valid_review_count";

alter table "public"."documents" add constraint "documents_category_check" CHECK ((category = ANY (ARRAY['transcript'::text, 'certificate'::text, 'id'::text, 'essay'::text, 'recommendation'::text, 'resume'::text, 'portfolio'::text, 'other'::text]))) not valid;

alter table "public"."documents" validate constraint "documents_category_check";

alter table "public"."documents" add constraint "documents_size_check" CHECK ((size >= 0)) not valid;

alter table "public"."documents" validate constraint "documents_size_check";

alter table "public"."documents" add constraint "documents_uploaded_by_fkey" FOREIGN KEY (uploaded_by) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."documents" validate constraint "documents_uploaded_by_fkey";

alter table "public"."enrichment_jobs" add constraint "enrichment_jobs_status_check" CHECK ((status = ANY (ARRAY['pending'::text, 'running'::text, 'completed'::text, 'failed'::text, 'cancelled'::text]))) not valid;

alter table "public"."enrichment_jobs" validate constraint "enrichment_jobs_status_check";

alter table "public"."enrollment_permissions" add constraint "enrollment_permissions_granted_by_check" CHECK (((granted_by)::text = ANY ((ARRAY['institution'::character varying, 'student_request'::character varying, 'auto_admission'::character varying])::text[]))) not valid;

alter table "public"."enrollment_permissions" validate constraint "enrollment_permissions_granted_by_check";

alter table "public"."enrollment_permissions" add constraint "enrollment_permissions_status_check" CHECK (((status)::text = ANY ((ARRAY['pending'::character varying, 'approved'::character varying, 'denied'::character varying, 'revoked'::character varying])::text[]))) not valid;

alter table "public"."enrollment_permissions" validate constraint "enrollment_permissions_status_check";

alter table "public"."enrollment_permissions" add constraint "fk_course" FOREIGN KEY (course_id) REFERENCES public.courses(id) ON DELETE CASCADE not valid;

alter table "public"."enrollment_permissions" validate constraint "fk_course";

alter table "public"."enrollment_permissions" add constraint "unique_student_course_permission" UNIQUE using index "unique_student_course_permission";

alter table "public"."enrollments" add constraint "enrollments_progress_percentage_check" CHECK (((progress_percentage >= (0)::numeric) AND (progress_percentage <= (100)::numeric))) not valid;

alter table "public"."enrollments" validate constraint "enrollments_progress_percentage_check";

alter table "public"."enrollments" add constraint "enrollments_status_check" CHECK (((status)::text = ANY ((ARRAY['active'::character varying, 'completed'::character varying, 'dropped'::character varying, 'suspended'::character varying])::text[]))) not valid;

alter table "public"."enrollments" validate constraint "enrollments_status_check";

alter table "public"."enrollments" add constraint "unique_student_course" UNIQUE using index "unique_student_course";

alter table "public"."enrollments" add constraint "valid_completion" CHECK (((((status)::text = 'completed'::text) AND (completed_at IS NOT NULL) AND (progress_percentage = (100)::numeric)) OR ((status)::text <> 'completed'::text))) not valid;

alter table "public"."enrollments" validate constraint "valid_completion";

alter table "public"."gpa_history" add constraint "fk_gpa_history_student" FOREIGN KEY (student_id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."gpa_history" validate constraint "fk_gpa_history_student";

alter table "public"."grade_alerts" add constraint "fk_grade_alerts_grade" FOREIGN KEY (grade_id) REFERENCES public.grades(id) ON DELETE SET NULL not valid;

alter table "public"."grade_alerts" validate constraint "fk_grade_alerts_grade";

alter table "public"."grade_alerts" add constraint "fk_grade_alerts_parent" FOREIGN KEY (parent_id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."grade_alerts" validate constraint "fk_grade_alerts_parent";

alter table "public"."grade_alerts" add constraint "fk_grade_alerts_student" FOREIGN KEY (student_id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."grade_alerts" validate constraint "fk_grade_alerts_student";

alter table "public"."grades" add constraint "fk_grades_student" FOREIGN KEY (student_id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."grades" validate constraint "fk_grades_student";

alter table "public"."institution_programs" add constraint "institution_programs_institution_id_fkey" FOREIGN KEY (institution_id) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."institution_programs" validate constraint "institution_programs_institution_id_fkey";

alter table "public"."institution_programs" add constraint "institution_programs_level_check" CHECK ((level = ANY (ARRAY['certificate'::text, 'diploma'::text, 'undergraduate'::text, 'graduate'::text, 'postgraduate'::text, 'doctorate'::text]))) not valid;

alter table "public"."institution_programs" validate constraint "institution_programs_level_check";

alter table "public"."lesson_assignments" add constraint "lesson_assignments_lesson_id_fkey" FOREIGN KEY (lesson_id) REFERENCES public.course_lessons(id) ON DELETE CASCADE not valid;

alter table "public"."lesson_assignments" validate constraint "lesson_assignments_lesson_id_fkey";

alter table "public"."lesson_assignments" add constraint "lesson_assignments_lesson_id_key" UNIQUE using index "lesson_assignments_lesson_id_key";

alter table "public"."lesson_assignments" add constraint "valid_late_penalty" CHECK (((late_penalty_percent >= (0)::numeric) AND (late_penalty_percent <= (100)::numeric))) not valid;

alter table "public"."lesson_assignments" validate constraint "valid_late_penalty";

alter table "public"."lesson_assignments" add constraint "valid_max_file_size" CHECK ((max_file_size_mb > 0)) not valid;

alter table "public"."lesson_assignments" validate constraint "valid_max_file_size";

alter table "public"."lesson_assignments" add constraint "valid_points_possible" CHECK ((points_possible > 0)) not valid;

alter table "public"."lesson_assignments" validate constraint "valid_points_possible";

alter table "public"."lesson_completions" add constraint "lesson_completions_lesson_id_fkey" FOREIGN KEY (lesson_id) REFERENCES public.course_lessons(id) ON DELETE CASCADE not valid;

alter table "public"."lesson_completions" validate constraint "lesson_completions_lesson_id_fkey";

alter table "public"."lesson_completions" add constraint "lesson_completions_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."lesson_completions" validate constraint "lesson_completions_user_id_fkey";

alter table "public"."lesson_completions" add constraint "unique_lesson_user" UNIQUE using index "unique_lesson_user";

alter table "public"."lesson_completions" add constraint "valid_completion_percentage" CHECK (((completion_percentage >= (0)::numeric) AND (completion_percentage <= (100)::numeric))) not valid;

alter table "public"."lesson_completions" validate constraint "valid_completion_percentage";

alter table "public"."lesson_completions" add constraint "valid_time_spent" CHECK ((time_spent_minutes >= 0)) not valid;

alter table "public"."lesson_completions" validate constraint "valid_time_spent";

alter table "public"."lesson_quizzes" add constraint "lesson_quizzes_lesson_id_fkey" FOREIGN KEY (lesson_id) REFERENCES public.course_lessons(id) ON DELETE CASCADE not valid;

alter table "public"."lesson_quizzes" validate constraint "lesson_quizzes_lesson_id_fkey";

alter table "public"."lesson_quizzes" add constraint "lesson_quizzes_lesson_id_key" UNIQUE using index "lesson_quizzes_lesson_id_key";

alter table "public"."lesson_quizzes" add constraint "valid_max_attempts" CHECK (((max_attempts IS NULL) OR (max_attempts > 0))) not valid;

alter table "public"."lesson_quizzes" validate constraint "valid_max_attempts";

alter table "public"."lesson_quizzes" add constraint "valid_passing_score" CHECK (((passing_score >= (0)::numeric) AND (passing_score <= (100)::numeric))) not valid;

alter table "public"."lesson_quizzes" validate constraint "valid_passing_score";

alter table "public"."lesson_quizzes" add constraint "valid_time_limit" CHECK (((time_limit_minutes IS NULL) OR (time_limit_minutes > 0))) not valid;

alter table "public"."lesson_quizzes" validate constraint "valid_time_limit";

alter table "public"."lesson_quizzes" add constraint "valid_total_points" CHECK ((total_points >= 0)) not valid;

alter table "public"."lesson_quizzes" validate constraint "valid_total_points";

alter table "public"."lesson_texts" add constraint "lesson_texts_lesson_id_fkey" FOREIGN KEY (lesson_id) REFERENCES public.course_lessons(id) ON DELETE CASCADE not valid;

alter table "public"."lesson_texts" validate constraint "lesson_texts_lesson_id_fkey";

alter table "public"."lesson_texts" add constraint "lesson_texts_lesson_id_key" UNIQUE using index "lesson_texts_lesson_id_key";

alter table "public"."lesson_texts" add constraint "valid_reading_time" CHECK (((estimated_reading_time IS NULL) OR (estimated_reading_time >= 0))) not valid;

alter table "public"."lesson_texts" validate constraint "valid_reading_time";

alter table "public"."lesson_videos" add constraint "lesson_videos_lesson_id_fkey" FOREIGN KEY (lesson_id) REFERENCES public.course_lessons(id) ON DELETE CASCADE not valid;

alter table "public"."lesson_videos" validate constraint "lesson_videos_lesson_id_fkey";

alter table "public"."lesson_videos" add constraint "lesson_videos_lesson_id_key" UNIQUE using index "lesson_videos_lesson_id_key";

alter table "public"."lesson_videos" add constraint "valid_duration" CHECK (((duration_seconds IS NULL) OR (duration_seconds >= 0))) not valid;

alter table "public"."lesson_videos" validate constraint "valid_duration";

alter table "public"."letter_of_recommendations" add constraint "fk_letter_of_recommendations_request" FOREIGN KEY (request_id) REFERENCES public.recommendation_requests(id) ON DELETE CASCADE not valid;

alter table "public"."letter_of_recommendations" validate constraint "fk_letter_of_recommendations_request";

alter table "public"."letter_of_recommendations" add constraint "fk_letter_of_recommendations_template" FOREIGN KEY (template_id) REFERENCES public.recommendation_templates(id) ON DELETE SET NULL not valid;

alter table "public"."letter_of_recommendations" validate constraint "fk_letter_of_recommendations_template";

alter table "public"."letter_of_recommendations" add constraint "letter_of_recommendations_share_token_key" UNIQUE using index "letter_of_recommendations_share_token_key";

alter table "public"."meetings" add constraint "meetings_duration_minutes_check" CHECK ((duration_minutes = ANY (ARRAY[15, 30, 45, 60, 90, 120]))) not valid;

alter table "public"."meetings" validate constraint "meetings_duration_minutes_check";

alter table "public"."meetings" add constraint "meetings_meeting_mode_check" CHECK ((meeting_mode = ANY (ARRAY['in_person'::text, 'video_call'::text, 'phone_call'::text]))) not valid;

alter table "public"."meetings" validate constraint "meetings_meeting_mode_check";

alter table "public"."meetings" add constraint "meetings_meeting_type_check" CHECK ((meeting_type = ANY (ARRAY['parent_teacher'::text, 'parent_counselor'::text]))) not valid;

alter table "public"."meetings" validate constraint "meetings_meeting_type_check";

alter table "public"."meetings" add constraint "meetings_parent_id_fkey" FOREIGN KEY (parent_id) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."meetings" validate constraint "meetings_parent_id_fkey";

alter table "public"."meetings" add constraint "meetings_staff_id_fkey" FOREIGN KEY (staff_id) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."meetings" validate constraint "meetings_staff_id_fkey";

alter table "public"."meetings" add constraint "meetings_staff_type_check" CHECK ((staff_type = ANY (ARRAY['teacher'::text, 'counselor'::text]))) not valid;

alter table "public"."meetings" validate constraint "meetings_staff_type_check";

alter table "public"."meetings" add constraint "meetings_status_check" CHECK ((status = ANY (ARRAY['pending'::text, 'approved'::text, 'declined'::text, 'cancelled'::text, 'completed'::text]))) not valid;

alter table "public"."meetings" validate constraint "meetings_status_check";

alter table "public"."meetings" add constraint "meetings_student_id_fkey" FOREIGN KEY (student_id) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."meetings" validate constraint "meetings_student_id_fkey";

alter table "public"."messages" add constraint "messages_conversation_id_fkey" FOREIGN KEY (conversation_id) REFERENCES public.conversations(id) ON DELETE CASCADE not valid;

alter table "public"."messages" validate constraint "messages_conversation_id_fkey";

alter table "public"."notification_preferences" add constraint "notification_preferences_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."notification_preferences" validate constraint "notification_preferences_user_id_fkey";

alter table "public"."notification_preferences" add constraint "notification_preferences_user_id_notification_type_key" UNIQUE using index "notification_preferences_user_id_notification_type_key";

alter table "public"."notifications" add constraint "notifications_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."notifications" validate constraint "notifications_user_id_fkey";

alter table "public"."page_contents" add constraint "page_contents_created_by_fkey" FOREIGN KEY (created_by) REFERENCES auth.users(id) not valid;

alter table "public"."page_contents" validate constraint "page_contents_created_by_fkey";

alter table "public"."page_contents" add constraint "page_contents_page_slug_key" UNIQUE using index "page_contents_page_slug_key";

alter table "public"."page_contents" add constraint "page_contents_status_check" CHECK (((status)::text = ANY ((ARRAY['draft'::character varying, 'published'::character varying, 'archived'::character varying])::text[]))) not valid;

alter table "public"."page_contents" validate constraint "page_contents_status_check";

alter table "public"."page_contents" add constraint "page_contents_updated_by_fkey" FOREIGN KEY (updated_by) REFERENCES auth.users(id) not valid;

alter table "public"."page_contents" validate constraint "page_contents_updated_by_fkey";

alter table "public"."parent_alerts" add constraint "parent_alerts_child_id_fkey" FOREIGN KEY (child_id) REFERENCES public.children(id) ON DELETE CASCADE not valid;

alter table "public"."parent_alerts" validate constraint "parent_alerts_child_id_fkey";

alter table "public"."parent_alerts" add constraint "parent_alerts_parent_id_fkey" FOREIGN KEY (parent_id) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."parent_alerts" validate constraint "parent_alerts_parent_id_fkey";

alter table "public"."parent_alerts" add constraint "parent_alerts_severity_check" CHECK ((severity = ANY (ARRAY['info'::text, 'warning'::text, 'critical'::text]))) not valid;

alter table "public"."parent_alerts" validate constraint "parent_alerts_severity_check";

alter table "public"."parent_alerts" add constraint "parent_alerts_type_check" CHECK ((type = ANY (ARRAY['grade'::text, 'attendance'::text, 'behavior'::text, 'assignment'::text, 'general'::text]))) not valid;

alter table "public"."parent_alerts" validate constraint "parent_alerts_type_check";

alter table "public"."parent_children" add constraint "fk_parent_children_child" FOREIGN KEY (child_id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."parent_children" validate constraint "fk_parent_children_child";

alter table "public"."parent_children" add constraint "fk_parent_children_parent" FOREIGN KEY (parent_id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."parent_children" validate constraint "fk_parent_children_parent";

alter table "public"."parent_children" add constraint "unique_parent_child" UNIQUE using index "unique_parent_child";

alter table "public"."parent_student_links" add constraint "parent_student_links_parent_id_fkey" FOREIGN KEY (parent_id) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."parent_student_links" validate constraint "parent_student_links_parent_id_fkey";

alter table "public"."parent_student_links" add constraint "parent_student_links_parent_id_student_id_key" UNIQUE using index "parent_student_links_parent_id_student_id_key";

alter table "public"."parent_student_links" add constraint "parent_student_links_status_check" CHECK (((status)::text = ANY ((ARRAY['pending'::character varying, 'active'::character varying, 'declined'::character varying, 'revoked'::character varying])::text[]))) not valid;

alter table "public"."parent_student_links" validate constraint "parent_student_links_status_check";

alter table "public"."parent_student_links" add constraint "parent_student_links_student_id_fkey" FOREIGN KEY (student_id) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."parent_student_links" validate constraint "parent_student_links_student_id_fkey";

alter table "public"."payments" add constraint "payments_amount_check" CHECK ((amount >= (0)::numeric)) not valid;

alter table "public"."payments" validate constraint "payments_amount_check";

alter table "public"."payments" add constraint "payments_item_type_check" CHECK ((item_type = ANY (ARRAY['program'::text, 'application'::text, 'subscription'::text, 'other'::text]))) not valid;

alter table "public"."payments" validate constraint "payments_item_type_check";

alter table "public"."payments" add constraint "payments_method_check" CHECK ((method = ANY (ARRAY['card'::text, 'mpesa'::text, 'flutterwave'::text, 'paypal'::text, 'stripe'::text]))) not valid;

alter table "public"."payments" validate constraint "payments_method_check";

alter table "public"."payments" add constraint "payments_status_check" CHECK ((status = ANY (ARRAY['pending'::text, 'processing'::text, 'completed'::text, 'failed'::text, 'refunded'::text]))) not valid;

alter table "public"."payments" validate constraint "payments_status_check";

alter table "public"."payments" add constraint "payments_transaction_id_key" UNIQUE using index "payments_transaction_id_key";

alter table "public"."payments" add constraint "payments_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."payments" validate constraint "payments_user_id_fkey";

alter table "public"."programs" add constraint "programs_level_check" CHECK ((level = ANY (ARRAY['certificate'::text, 'diploma'::text, 'undergraduate'::text, 'postgraduate'::text, 'doctoral'::text]))) not valid;

alter table "public"."programs" validate constraint "programs_level_check";

alter table "public"."quiz_attempts" add constraint "quiz_attempts_quiz_id_fkey" FOREIGN KEY (quiz_id) REFERENCES public.lesson_quizzes(id) ON DELETE CASCADE not valid;

alter table "public"."quiz_attempts" validate constraint "quiz_attempts_quiz_id_fkey";

alter table "public"."quiz_attempts" add constraint "quiz_attempts_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."quiz_attempts" validate constraint "quiz_attempts_user_id_fkey";

alter table "public"."quiz_attempts" add constraint "valid_attempt_number" CHECK ((attempt_number > 0)) not valid;

alter table "public"."quiz_attempts" validate constraint "valid_attempt_number";

alter table "public"."quiz_attempts" add constraint "valid_points_earned" CHECK ((points_earned >= 0)) not valid;

alter table "public"."quiz_attempts" validate constraint "valid_points_earned";

alter table "public"."quiz_attempts" add constraint "valid_points_possible" CHECK ((points_possible >= 0)) not valid;

alter table "public"."quiz_attempts" validate constraint "valid_points_possible";

alter table "public"."quiz_attempts" add constraint "valid_score" CHECK (((score >= (0)::numeric) AND (score <= (100)::numeric))) not valid;

alter table "public"."quiz_attempts" validate constraint "valid_score";

alter table "public"."quiz_attempts" add constraint "valid_time_taken" CHECK (((time_taken_minutes IS NULL) OR (time_taken_minutes >= 0))) not valid;

alter table "public"."quiz_attempts" validate constraint "valid_time_taken";

alter table "public"."quiz_question_options" add constraint "quiz_question_options_question_id_fkey" FOREIGN KEY (question_id) REFERENCES public.quiz_questions(id) ON DELETE CASCADE not valid;

alter table "public"."quiz_question_options" validate constraint "quiz_question_options_question_id_fkey";

alter table "public"."quiz_question_options" add constraint "unique_question_order" UNIQUE using index "unique_question_order";

alter table "public"."quiz_question_options" add constraint "valid_order_index" CHECK ((order_index >= 0)) not valid;

alter table "public"."quiz_question_options" validate constraint "valid_order_index";

alter table "public"."quiz_questions" add constraint "quiz_questions_quiz_id_fkey" FOREIGN KEY (quiz_id) REFERENCES public.lesson_quizzes(id) ON DELETE CASCADE not valid;

alter table "public"."quiz_questions" validate constraint "quiz_questions_quiz_id_fkey";

alter table "public"."quiz_questions" add constraint "unique_quiz_order" UNIQUE using index "unique_quiz_order";

alter table "public"."quiz_questions" add constraint "valid_order_index" CHECK ((order_index >= 0)) not valid;

alter table "public"."quiz_questions" validate constraint "valid_order_index";

alter table "public"."quiz_questions" add constraint "valid_points" CHECK ((points > 0)) not valid;

alter table "public"."quiz_questions" validate constraint "valid_points";

alter table "public"."recommendation_clicks" add constraint "fk_clicks_impression" FOREIGN KEY (impression_id) REFERENCES public.recommendation_impressions(id) ON DELETE CASCADE not valid;

alter table "public"."recommendation_clicks" validate constraint "fk_clicks_impression";

alter table "public"."recommendation_clicks" add constraint "fk_clicks_student" FOREIGN KEY (student_id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."recommendation_clicks" validate constraint "fk_clicks_student";

alter table "public"."recommendation_clicks" add constraint "fk_clicks_university" FOREIGN KEY (university_id) REFERENCES public.universities(id) ON DELETE CASCADE not valid;

alter table "public"."recommendation_clicks" validate constraint "fk_clicks_university";

alter table "public"."recommendation_feedback" add constraint "fk_feedback_impression" FOREIGN KEY (impression_id) REFERENCES public.recommendation_impressions(id) ON DELETE SET NULL not valid;

alter table "public"."recommendation_feedback" validate constraint "fk_feedback_impression";

alter table "public"."recommendation_feedback" add constraint "fk_feedback_student" FOREIGN KEY (student_id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."recommendation_feedback" validate constraint "fk_feedback_student";

alter table "public"."recommendation_feedback" add constraint "fk_feedback_university" FOREIGN KEY (university_id) REFERENCES public.universities(id) ON DELETE CASCADE not valid;

alter table "public"."recommendation_feedback" validate constraint "fk_feedback_university";

alter table "public"."recommendation_impressions" add constraint "fk_impressions_student" FOREIGN KEY (student_id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."recommendation_impressions" validate constraint "fk_impressions_student";

alter table "public"."recommendation_impressions" add constraint "fk_impressions_university" FOREIGN KEY (university_id) REFERENCES public.universities(id) ON DELETE CASCADE not valid;

alter table "public"."recommendation_impressions" validate constraint "fk_impressions_university";

alter table "public"."recommendation_letters" add constraint "recommendation_letters_counselor_id_fkey" FOREIGN KEY (counselor_id) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."recommendation_letters" validate constraint "recommendation_letters_counselor_id_fkey";

alter table "public"."recommendation_letters" add constraint "recommendation_letters_status_check" CHECK ((status = ANY (ARRAY['pending'::text, 'in_progress'::text, 'completed'::text, 'declined'::text]))) not valid;

alter table "public"."recommendation_letters" validate constraint "recommendation_letters_status_check";

alter table "public"."recommendation_letters" add constraint "recommendation_letters_student_id_fkey" FOREIGN KEY (student_id) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."recommendation_letters" validate constraint "recommendation_letters_student_id_fkey";

alter table "public"."recommendation_reminders" add constraint "fk_recommendation_reminders_request" FOREIGN KEY (request_id) REFERENCES public.recommendation_requests(id) ON DELETE CASCADE not valid;

alter table "public"."recommendation_reminders" validate constraint "fk_recommendation_reminders_request";

alter table "public"."recommendation_requests" add constraint "check_deadline_future" CHECK ((deadline >= CURRENT_DATE)) not valid;

alter table "public"."recommendation_requests" validate constraint "check_deadline_future";

alter table "public"."recommendation_requests" add constraint "fk_recommendation_requests_recommender" FOREIGN KEY (recommender_id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."recommendation_requests" validate constraint "fk_recommendation_requests_recommender";

alter table "public"."recommendation_requests" add constraint "fk_recommendation_requests_student" FOREIGN KEY (student_id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."recommendation_requests" validate constraint "fk_recommendation_requests_student";

alter table "public"."recommendation_templates" add constraint "fk_recommendation_templates_creator" FOREIGN KEY (created_by) REFERENCES auth.users(id) ON DELETE SET NULL not valid;

alter table "public"."recommendation_templates" validate constraint "fk_recommendation_templates_creator";

alter table "public"."recommendations" add constraint "recommendations_student_id_fkey" FOREIGN KEY (student_id) REFERENCES public.student_profiles(id) ON DELETE CASCADE not valid;

alter table "public"."recommendations" validate constraint "recommendations_student_id_fkey";

alter table "public"."recommendations" add constraint "recommendations_university_id_fkey" FOREIGN KEY (university_id) REFERENCES public.universities(id) ON DELETE CASCADE not valid;

alter table "public"."recommendations" validate constraint "recommendations_university_id_fkey";

alter table "public"."scheduled_report_executions" add constraint "scheduled_report_executions_scheduled_report_id_fkey" FOREIGN KEY (scheduled_report_id) REFERENCES public.scheduled_reports(id) ON DELETE CASCADE not valid;

alter table "public"."scheduled_report_executions" validate constraint "scheduled_report_executions_scheduled_report_id_fkey";

alter table "public"."scheduled_report_executions" add constraint "scheduled_report_executions_status_check" CHECK ((status = ANY (ARRAY['pending'::text, 'running'::text, 'completed'::text, 'failed'::text]))) not valid;

alter table "public"."scheduled_report_executions" validate constraint "scheduled_report_executions_status_check";

alter table "public"."scheduled_reports" add constraint "scheduled_reports_created_by_fkey" FOREIGN KEY (created_by) REFERENCES auth.users(id) not valid;

alter table "public"."scheduled_reports" validate constraint "scheduled_reports_created_by_fkey";

alter table "public"."scheduled_reports" add constraint "scheduled_reports_format_check" CHECK ((format = ANY (ARRAY['pdf'::text, 'csv'::text, 'json'::text]))) not valid;

alter table "public"."scheduled_reports" validate constraint "scheduled_reports_format_check";

alter table "public"."scheduled_reports" add constraint "scheduled_reports_frequency_check" CHECK ((frequency = ANY (ARRAY['daily'::text, 'weekly'::text, 'monthly'::text]))) not valid;

alter table "public"."scheduled_reports" validate constraint "scheduled_reports_frequency_check";

alter table "public"."staff_availability" add constraint "staff_availability_day_of_week_check" CHECK (((day_of_week >= 0) AND (day_of_week <= 6))) not valid;

alter table "public"."staff_availability" validate constraint "staff_availability_day_of_week_check";

alter table "public"."staff_availability" add constraint "staff_availability_staff_id_fkey" FOREIGN KEY (staff_id) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."staff_availability" validate constraint "staff_availability_staff_id_fkey";

alter table "public"."staff_availability" add constraint "unique_staff_day" UNIQUE using index "unique_staff_day";

alter table "public"."staff_availability" add constraint "valid_time_range" CHECK ((end_time > start_time)) not valid;

alter table "public"."staff_availability" validate constraint "valid_time_range";

alter table "public"."student_activities" add constraint "fk_student_activities_student" FOREIGN KEY (student_id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."student_activities" validate constraint "fk_student_activities_student";

alter table "public"."student_counselor_assignments" add constraint "student_counselor_assignments_student_id_counselor_id_key" UNIQUE using index "student_counselor_assignments_student_id_counselor_id_key";

alter table "public"."student_interaction_summary" add constraint "fk_interaction_summary_student" FOREIGN KEY (student_id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."student_interaction_summary" validate constraint "fk_interaction_summary_student";

alter table "public"."student_interaction_summary" add constraint "student_interaction_summary_student_id_key" UNIQUE using index "student_interaction_summary_student_id_key";

alter table "public"."student_invite_codes" add constraint "student_invite_codes_code_key" UNIQUE using index "student_invite_codes_code_key";

alter table "public"."student_invite_codes" add constraint "student_invite_codes_student_id_fkey" FOREIGN KEY (student_id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."student_invite_codes" validate constraint "student_invite_codes_student_id_fkey";

alter table "public"."student_profiles" add constraint "student_profiles_user_id_key" UNIQUE using index "student_profiles_user_id_key";

alter table "public"."student_records" add constraint "student_records_counselor_id_fkey" FOREIGN KEY (counselor_id) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."student_records" validate constraint "student_records_counselor_id_fkey";

alter table "public"."student_records" add constraint "student_records_gpa_check" CHECK (((gpa >= (0)::numeric) AND (gpa <= (4)::numeric))) not valid;

alter table "public"."student_records" validate constraint "student_records_gpa_check";

alter table "public"."student_records" add constraint "student_records_status_check" CHECK ((status = ANY (ARRAY['active'::text, 'inactive'::text, 'completed'::text]))) not valid;

alter table "public"."student_records" validate constraint "student_records_status_check";

alter table "public"."student_records" add constraint "student_records_student_id_counselor_id_key" UNIQUE using index "student_records_student_id_counselor_id_key";

alter table "public"."student_records" add constraint "student_records_student_id_fkey" FOREIGN KEY (student_id) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."student_records" validate constraint "student_records_student_id_fkey";

alter table "public"."support_tickets" add constraint "support_tickets_assigned_to_fkey" FOREIGN KEY (assigned_to) REFERENCES public.users(id) ON DELETE SET NULL not valid;

alter table "public"."support_tickets" validate constraint "support_tickets_assigned_to_fkey";

alter table "public"."support_tickets" add constraint "support_tickets_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL not valid;

alter table "public"."support_tickets" validate constraint "support_tickets_user_id_fkey";

alter table "public"."transactions" add constraint "transactions_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL not valid;

alter table "public"."transactions" validate constraint "transactions_user_id_fkey";

alter table "public"."typing_indicators" add constraint "typing_indicators_conversation_id_fkey" FOREIGN KEY (conversation_id) REFERENCES public.conversations(id) ON DELETE CASCADE not valid;

alter table "public"."typing_indicators" validate constraint "typing_indicators_conversation_id_fkey";

alter table "public"."typing_indicators" add constraint "typing_indicators_conversation_id_user_id_key" UNIQUE using index "typing_indicators_conversation_id_user_id_key";

alter table "public"."typing_indicators" add constraint "typing_indicators_user_id_fkey" FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE not valid;

alter table "public"."typing_indicators" validate constraint "typing_indicators_user_id_fkey";

alter table "public"."users" add constraint "users_active_role_check" CHECK ((active_role = ANY (ARRAY['student'::text, 'counselor'::text, 'parent'::text, 'institution'::text, 'recommender'::text, 'superadmin'::text, 'regionaladmin'::text, 'contentadmin'::text, 'supportadmin'::text, 'financeadmin'::text, 'analyticsadmin'::text]))) not valid;

alter table "public"."users" validate constraint "users_active_role_check";

alter table "public"."users" add constraint "users_email_key" UNIQUE using index "users_email_key";

alter table "public"."users" add constraint "users_id_fkey" FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."users" validate constraint "users_id_fkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.auto_complete_past_meetings()
 RETURNS void
 LANGUAGE plpgsql
AS $function$
  BEGIN
      UPDATE meetings
      SET status = 'completed', updated_at = NOW()
      WHERE status = 'approved'
        AND scheduled_date IS NOT NULL
        AND scheduled_date + (duration_minutes || ' minutes')::INTERVAL < NOW();
  END;
  $function$
;

CREATE OR REPLACE FUNCTION public.broadcast_changes_trigger()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
  -- Determine topic for conversation messages
  PERFORM realtime.broadcast_changes(
    'conversation:' || COALESCE(NEW.conversation_id, OLD.conversation_id)::text || ':messages',
    TG_OP,
    TG_OP,
    TG_TABLE_NAME,
    TG_TABLE_SCHEMA,
    to_jsonb(NEW),
    to_jsonb(OLD)
  );
  RETURN COALESCE(NEW, OLD);
END;
$function$
;

CREATE OR REPLACE FUNCTION public.calculate_next_run(current_run timestamp with time zone, freq text)
 RETURNS timestamp with time zone
 LANGUAGE plpgsql
AS $function$
  BEGIN
      CASE freq
          WHEN 'daily' THEN
              RETURN current_run + INTERVAL '1 day';
          WHEN 'weekly' THEN
              RETURN current_run + INTERVAL '1 week';
          WHEN 'monthly' THEN
              RETURN current_run + INTERVAL '1 month';
          ELSE
              RETURN current_run + INTERVAL '1 week';
      END CASE;
  END;
  $function$
;

CREATE OR REPLACE FUNCTION public.calculate_quiz_time_taken()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
  BEGIN
      IF NEW.status = 'submitted' AND NEW.submitted_at IS NOT NULL THEN
          NEW.time_taken_minutes := EXTRACT(EPOCH FROM (NEW.submitted_at - NEW.started_at)) / 60;
      END IF;
      RETURN NEW;
  END;
  $function$
;

CREATE OR REPLACE FUNCTION public.cleanup_expired_enrichment_cache()
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
  DECLARE
      deleted_count INTEGER;
  BEGIN
      DELETE FROM enrichment_cache WHERE expires_at < NOW();
      GET DIAGNOSTICS deleted_count = ROW_COUNT;
      RETURN deleted_count;
  END;
  $function$
;

CREATE OR REPLACE FUNCTION public.cleanup_expired_page_cache()
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
  DECLARE
      deleted_count INTEGER;
  BEGIN
      DELETE FROM page_cache WHERE expires_at < NOW();
      GET DIAGNOSTICS deleted_count = ROW_COUNT;
      RETURN deleted_count;
  END;
  $function$
;

CREATE OR REPLACE FUNCTION public.cleanup_old_activity_logs()
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
  BEGIN
      -- Delete activity logs older than 365 days
      DELETE FROM activity_log
      WHERE created_at < NOW() - INTERVAL '365 days';

      RAISE NOTICE 'Cleaned up old activity logs';
  END;
  $function$
;

CREATE OR REPLACE FUNCTION public.cleanup_old_logs()
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
  DECLARE
      deleted_count INTEGER;
  BEGIN
      DELETE FROM system_logs WHERE timestamp < NOW() - INTERVAL '30 days';
      GET DIAGNOSTICS deleted_count = ROW_COUNT;
      RETURN deleted_count;
  END;
  $function$
;

CREATE OR REPLACE FUNCTION public.cleanup_old_notifications(days_to_keep integer DEFAULT 90)
 RETURNS integer
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
  DECLARE
      deleted_count INTEGER;
  BEGIN
      UPDATE notifications
      SET deleted_at = NOW()
      WHERE created_at < NOW() - (days_to_keep || ' days')::INTERVAL
        AND deleted_at IS NULL
        AND (is_archived = true OR is_read = true);

      GET DIAGNOSTICS deleted_count = ROW_COUNT;
      RETURN deleted_count;
  END;
  $function$
;

create or replace view "public"."course_lessons_detailed" as  SELECT cl.id,
    cl.module_id,
    cl.title,
    cl.description,
    cl.lesson_type,
    cl.order_index,
    cl.duration_minutes,
    cl.content_url,
    cl.is_mandatory,
    cl.is_published,
    cl.allow_preview,
    cl.created_at,
    cl.updated_at,
    cm.title AS module_title,
    cm.course_id,
    c.title AS course_title,
    c.institution_id
   FROM ((public.course_lessons cl
     JOIN public.course_modules cm ON ((cl.module_id = cm.id)))
     JOIN public.courses c ON ((cm.course_id = c.id)));


CREATE OR REPLACE FUNCTION public.create_default_notification_preferences(target_user_id uuid)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
  DECLARE
      notif_type notification_type;
  BEGIN
      FOR notif_type IN
          SELECT unnest(enum_range(NULL::notification_type))
      LOOP
          INSERT INTO notification_preferences (user_id, notification_type, in_app_enabled, email_enabled, push_enabled)    
          VALUES (target_user_id, notif_type, true, true, true)
          ON CONFLICT (user_id, notification_type) DO NOTHING;
      END LOOP;
  END;
  $function$
;

CREATE OR REPLACE FUNCTION public.get_config(config_key text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
  DECLARE
      config_value TEXT;
  BEGIN
      SELECT value INTO config_value FROM app_config WHERE key = config_key;
      RETURN config_value;
  END;
  $function$
;

CREATE OR REPLACE FUNCTION public.get_enrichment_cache_stats()
 RETURNS TABLE(total_entries bigint, expired_entries bigint, valid_entries bigint, by_source jsonb, by_field jsonb)
 LANGUAGE plpgsql
AS $function$
  BEGIN
      RETURN QUERY
      SELECT
          COUNT(*)::BIGINT as total_entries,
          COUNT(*) FILTER (WHERE expires_at < NOW())::BIGINT as expired_entries,
          COUNT(*) FILTER (WHERE expires_at >= NOW())::BIGINT as valid_entries,
          jsonb_object_agg(data_source, source_count) as by_source,
          jsonb_object_agg(field_name, field_count) as by_field
      FROM (
          SELECT
              data_source,
              COUNT(*) as source_count
          FROM enrichment_cache
          WHERE expires_at >= NOW()
          GROUP BY data_source
      ) source_stats,
      (
          SELECT
              field_name,
              COUNT(*) as field_count
          FROM enrichment_cache
          WHERE expires_at >= NOW()
          GROUP BY field_name
      ) field_stats;
  END;
  $function$
;

CREATE OR REPLACE FUNCTION public.get_index_usage_stats()
 RETURNS TABLE(table_name text, index_name text, index_scans bigint, index_size text, table_size text)
 LANGUAGE plpgsql
AS $function$
  BEGIN
      RETURN QUERY
      SELECT
          schemaname||'.'||tablename AS table_name,
          indexrelname AS index_name,
          idx_scan AS index_scans,
          pg_size_pretty(pg_relation_size(indexrelid)) AS index_size,
          pg_size_pretty(pg_relation_size(tablename::regclass)) AS table_size
      FROM pg_stat_user_indexes
      WHERE schemaname = 'public'
      ORDER BY idx_scan DESC;
  END;
  $function$
;

CREATE OR REPLACE FUNCTION public.get_institution_user_ids()
 RETURNS TABLE(user_id uuid)
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
  BEGIN
      RETURN QUERY
      SELECT DISTINCT u.id
      FROM users u
      WHERE u.active_role = 'institution'
         OR 'institution' = ANY(u.available_roles);
  END;
  $function$
;

CREATE OR REPLACE FUNCTION public.get_log_statistics(days integer DEFAULT 7)
 RETURNS TABLE(level text, count bigint, first_occurrence timestamp without time zone, last_occurrence timestamp without time zone)
 LANGUAGE plpgsql
AS $function$
  BEGIN
      RETURN QUERY
      SELECT
          l.level,
          COUNT(*) as count,
          MIN(l.timestamp) as first_occurrence,
          MAX(l.timestamp) as last_occurrence
      FROM system_logs l
      WHERE l.timestamp > NOW() - (days || ' days')::INTERVAL
      GROUP BY l.level
      ORDER BY count DESC;
  END;
  $function$
;

CREATE OR REPLACE FUNCTION public.get_unread_notification_count()
 RETURNS integer
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
  BEGIN
      RETURN (
          SELECT COUNT(*)
          FROM notifications
          WHERE user_id = auth.uid()
            AND is_read = false
            AND deleted_at IS NULL
      )::INTEGER;
  END;
  $function$
;

CREATE OR REPLACE FUNCTION public.invalidate_field_cache(field text)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
  DECLARE
      deleted_count INTEGER;
  BEGIN
      DELETE FROM enrichment_cache WHERE field_name = field;
      GET DIAGNOSTICS deleted_count = ROW_COUNT;
      RETURN deleted_count;
  END;
  $function$
;

CREATE OR REPLACE FUNCTION public.invalidate_university_cache(uni_id integer)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
  DECLARE
      deleted_count INTEGER;
  BEGIN
      DELETE FROM enrichment_cache WHERE university_id = uni_id;
      GET DIAGNOSTICS deleted_count = ROW_COUNT;
      RETURN deleted_count;
  END;
  $function$
;

CREATE OR REPLACE FUNCTION public.mark_all_notifications_read()
 RETURNS integer
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
  DECLARE
      updated_count INTEGER;
  BEGIN
      UPDATE notifications
      SET is_read = true,
          read_at = NOW()
      WHERE user_id = auth.uid()
        AND is_read = false
        AND deleted_at IS NULL;

      GET DIAGNOSTICS updated_count = ROW_COUNT;
      RETURN updated_count;
  END;
  $function$
;

CREATE OR REPLACE FUNCTION public.mark_notification_read(notification_id uuid)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
  BEGIN
      UPDATE notifications
      SET is_read = true,
          read_at = NOW()
      WHERE id = notification_id
        AND user_id = auth.uid()
        AND is_read = false;
  END;
  $function$
;

CREATE OR REPLACE FUNCTION public.mark_report_executed(report_id uuid, execution_status text, error_msg text DEFAULT NULL::text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
  DECLARE
      current_freq TEXT;
      current_next_run TIMESTAMPTZ;
  BEGIN
      SELECT frequency, next_run_at
      INTO current_freq, current_next_run
      FROM scheduled_reports
      WHERE id = report_id;

      UPDATE scheduled_reports
      SET
          last_run_at = NOW(),
          next_run_at = calculate_next_run(current_next_run, current_freq)
      WHERE id = report_id;

      INSERT INTO scheduled_report_executions (
          scheduled_report_id,
          status,
          started_at,
          completed_at,
          error_message
      ) VALUES (
          report_id,
          execution_status,
          NOW(),
          NOW(),
          error_msg
      );
  END;
  $function$
;

create or replace view "public"."quiz_questions_with_options" as  SELECT qq.id AS question_id,
    qq.quiz_id,
    qq.question_text,
    qq.question_type,
    qq.order_index,
    qq.points,
    qq.hint,
    qq.explanation,
    qq.required,
    COALESCE(json_agg(json_build_object('id', qo.id, 'option_text', qo.option_text, 'is_correct', qo.is_correct, 'order_index', qo.order_index, 'feedback', qo.feedback) ORDER BY qo.order_index) FILTER (WHERE (qo.id IS NOT NULL)), '[]'::json) AS options
   FROM (public.quiz_questions qq
     LEFT JOIN public.quiz_question_options qo ON ((qo.question_id = qq.id)))
  GROUP BY qq.id, qq.quiz_id, qq.question_text, qq.question_type, qq.order_index, qq.points, qq.hint, qq.explanation, qq.required;


create materialized view "public"."recommendation_stats" as  SELECT student_id,
    category,
    count(*) AS total_recommendations,
    avg(match_score) AS avg_match_score,
    sum(
        CASE
            WHEN (favorited = 1) THEN 1
            ELSE 0
        END) AS favorited_count,
    max(created_at) AS last_recommendation_date
   FROM public.recommendations r
  GROUP BY student_id, category;


CREATE OR REPLACE FUNCTION public.set_config(config_key text, config_value text, config_description text DEFAULT NULL::text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
  BEGIN
      INSERT INTO app_config (key, value, description, updated_at)
      VALUES (config_key, config_value, config_description, NOW())
      ON CONFLICT (key)
      DO UPDATE SET value = config_value, description = config_description, updated_at = NOW();
  END;
  $function$
;

CREATE OR REPLACE FUNCTION public.trigger_update_timestamp()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
  BEGIN
      NEW.updated_at = NOW();
      RETURN NEW;
  END;
  $function$
;

CREATE OR REPLACE FUNCTION public.update_assignment_submissions_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
  BEGIN
      NEW.updated_at = NOW();
      RETURN NEW;
  END;
  $function$
;

CREATE OR REPLACE FUNCTION public.update_conversation_last_message()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
  BEGIN
    UPDATE public.conversations
    SET
      last_message_at = NEW.timestamp,
      last_message_preview = CASE
        WHEN NEW.is_deleted THEN '[Message deleted]'
        WHEN NEW.message_type != 'text' THEN CONCAT('[', NEW.message_type, ']')
        ELSE LEFT(NEW.content, 100)
      END,
      updated_at = NOW()
    WHERE id = NEW.conversation_id;
    RETURN NEW;
  END;
  $function$
;

CREATE OR REPLACE FUNCTION public.update_conversation_stats()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
  BEGIN
      UPDATE public.chatbot_conversations
      SET
          message_count = message_count + 1,
          user_message_count = user_message_count + CASE WHEN NEW.sender = 'user' THEN 1 ELSE 0 END,
          bot_message_count = bot_message_count + CASE WHEN NEW.sender = 'bot' THEN 1 ELSE 0 END,
          agent_message_count = agent_message_count + CASE WHEN NEW.sender = 'agent' THEN 1 ELSE 0 END,
          updated_at = NOW()
      WHERE id = NEW.conversation_id;
      RETURN NEW;
  END;
  $function$
;

CREATE OR REPLACE FUNCTION public.update_course_enrolled_count()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
  BEGIN
      IF TG_OP = 'INSERT' AND NEW.status IN ('active', 'completed') THEN
          -- Increment enrolled_count when student enrolls
          UPDATE courses
          SET enrolled_count = enrolled_count + 1
          WHERE id = NEW.course_id;
      ELSIF TG_OP = 'UPDATE' THEN
          -- Handle status changes
          IF OLD.status IN ('active', 'completed') AND NEW.status NOT IN ('active', 'completed') THEN
              -- Decrement when student drops/suspends
              UPDATE courses
              SET enrolled_count = GREATEST(enrolled_count - 1, 0)
              WHERE id = OLD.course_id;
          ELSIF OLD.status NOT IN ('active', 'completed') AND NEW.status IN ('active', 'completed') THEN
              -- Increment when re-enrolling
              UPDATE courses
              SET enrolled_count = enrolled_count + 1
              WHERE id = NEW.course_id;
          END IF;
      ELSIF TG_OP = 'DELETE' AND OLD.status IN ('active', 'completed') THEN
          -- Decrement when enrollment is deleted
          UPDATE courses
          SET enrolled_count = GREATEST(enrolled_count - 1, 0)
          WHERE id = OLD.course_id;
      END IF;
      RETURN COALESCE(NEW, OLD);
  END;
  $function$
;

CREATE OR REPLACE FUNCTION public.update_course_lessons_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
  BEGIN
      NEW.updated_at = NOW();
      RETURN NEW;
  END;
  $function$
;

CREATE OR REPLACE FUNCTION public.update_course_module_count()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
  BEGIN
      -- Update the course's module_count
      UPDATE courses
      SET module_count = (
          SELECT COUNT(*)
          FROM course_modules
          WHERE course_id = COALESCE(NEW.course_id, OLD.course_id)
      )
      WHERE id = COALESCE(NEW.course_id, OLD.course_id);

      RETURN COALESCE(NEW, OLD);
  END;
  $function$
;

CREATE OR REPLACE FUNCTION public.update_course_modules_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
  BEGIN
      NEW.updated_at = NOW();
      RETURN NEW;
  END;
  $function$
;

CREATE OR REPLACE FUNCTION public.update_courses_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
  BEGIN
      NEW.updated_at = NOW();
      RETURN NEW;
  END;
  $function$
;

CREATE OR REPLACE FUNCTION public.update_enrichment_jobs_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
  BEGIN
      NEW.updated_at = NOW();
      RETURN NEW;
  END;
  $function$
;

CREATE OR REPLACE FUNCTION public.update_enrollment_permissions_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
  BEGIN
      NEW.updated_at = NOW();
      RETURN NEW;
  END;
  $function$
;

CREATE OR REPLACE FUNCTION public.update_enrollment_progress()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
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
          SET progress = v_progress_percentage,
              status = CASE
                  WHEN v_progress_percentage >= 100 THEN 'completed'
                  ELSE status
              END
          WHERE id = v_enrollment_id;
      END IF;

      RETURN NEW;
  END;
  $function$
;

CREATE OR REPLACE FUNCTION public.update_enrollments_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
  BEGIN
      NEW.updated_at = NOW();
      RETURN NEW;
  END;
  $function$
;

CREATE OR REPLACE FUNCTION public.update_faq_stats()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
  BEGIN
      IF NEW.feedback = 'helpful' AND (OLD.feedback IS NULL OR OLD.feedback != 'helpful') THEN
          UPDATE public.chatbot_faqs
          SET helpful_count = helpful_count + 1, updated_at = NOW()
          WHERE id = (NEW.metadata->>'faq_id')::uuid;
      ELSIF NEW.feedback = 'not_helpful' AND (OLD.feedback IS NULL OR OLD.feedback != 'not_helpful') THEN
          UPDATE public.chatbot_faqs
          SET not_helpful_count = not_helpful_count + 1, updated_at = NOW()
          WHERE id = (NEW.metadata->>'faq_id')::uuid;
      END IF;
      RETURN NEW;
  END;
  $function$
;

CREATE OR REPLACE FUNCTION public.update_interaction_summary_after_click()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
  BEGIN
      INSERT INTO student_interaction_summary (student_id, total_clicks, last_interaction_at)
      VALUES (NEW.student_id, 1, NEW.clicked_at)
      ON CONFLICT (student_id)
      DO UPDATE SET
          total_clicks = student_interaction_summary.total_clicks + 1,
          total_favorites = CASE WHEN NEW.action_type = 'favorite' THEN student_interaction_summary.total_favorites + 1     
  ELSE student_interaction_summary.total_favorites END,
          ctr_percentage = ROUND((student_interaction_summary.total_clicks + 1.0) /
  NULLIF(student_interaction_summary.total_impressions, 0) * 100, 2),
          last_interaction_at = NEW.clicked_at,
          updated_at = NOW();

      RETURN NEW;
  END;
  $function$
;

CREATE OR REPLACE FUNCTION public.update_interaction_summary_after_impression()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
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
  $function$
;

CREATE OR REPLACE FUNCTION public.update_lesson_assignments_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
  BEGIN
      NEW.updated_at = NOW();
      RETURN NEW;
  END;
  $function$
;

CREATE OR REPLACE FUNCTION public.update_lesson_completions_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
  BEGIN
      NEW.updated_at = NOW();
      RETURN NEW;
  END;
  $function$
;

CREATE OR REPLACE FUNCTION public.update_lesson_quizzes_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
  BEGIN
      NEW.updated_at = NOW();
      RETURN NEW;
  END;
  $function$
;

CREATE OR REPLACE FUNCTION public.update_lesson_texts_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
  BEGIN
      NEW.updated_at = NOW();
      RETURN NEW;
  END;
  $function$
;

CREATE OR REPLACE FUNCTION public.update_lesson_videos_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
  BEGIN
      NEW.updated_at = NOW();
      RETURN NEW;
  END;
  $function$
;

CREATE OR REPLACE FUNCTION public.update_meetings_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
  BEGIN
      NEW.updated_at = NOW();
      RETURN NEW;
  END;
  $function$
;

CREATE OR REPLACE FUNCTION public.update_module_duration()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
  BEGIN
      -- Update the module's total duration
      UPDATE course_modules
      SET duration_minutes = (
          SELECT COALESCE(SUM(duration_minutes), 0)
          FROM course_lessons
          WHERE module_id = COALESCE(NEW.module_id, OLD.module_id)
      )
      WHERE id = COALESCE(NEW.module_id, OLD.module_id);

      RETURN COALESCE(NEW, OLD);
  END;
  $function$
;

CREATE OR REPLACE FUNCTION public.update_module_lesson_count()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
  BEGIN
      -- Update the module's lesson_count
      UPDATE course_modules
      SET lesson_count = (
          SELECT COUNT(*)
          FROM course_lessons
          WHERE module_id = COALESCE(NEW.module_id, OLD.module_id)
      )
      WHERE id = COALESCE(NEW.module_id, OLD.module_id);

      RETURN COALESCE(NEW, OLD);
  END;
  $function$
;

CREATE OR REPLACE FUNCTION public.update_page_contents_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
  BEGIN
      NEW.updated_at = NOW();
      RETURN NEW;
  END;
  $function$
;

CREATE OR REPLACE FUNCTION public.update_programs_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
  BEGIN
      NEW.updated_at = NOW();
      RETURN NEW;
  END;
  $function$
;

CREATE OR REPLACE FUNCTION public.update_quiz_attempts_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
  BEGIN
      NEW.updated_at = NOW();
      RETURN NEW;
  END;
  $function$
;

CREATE OR REPLACE FUNCTION public.update_quiz_question_options_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
  BEGIN
      NEW.updated_at = NOW();
      RETURN NEW;
  END;
  $function$
;

CREATE OR REPLACE FUNCTION public.update_quiz_questions_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
  BEGIN
      NEW.updated_at = NOW();
      RETURN NEW;
  END;
  $function$
;

CREATE OR REPLACE FUNCTION public.update_quiz_total_points()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
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
  $function$
;

CREATE OR REPLACE FUNCTION public.update_scheduled_reports_timestamp()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
  BEGIN
      NEW.updated_at = NOW();
      RETURN NEW;
  END;
  $function$
;

CREATE OR REPLACE FUNCTION public.update_updated_at_column()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
  BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
  END;
  $function$
;

CREATE INDEX idx_recommendation_stats_student ON public.recommendation_stats USING btree (student_id);

grant delete on table "public"."achievements" to "anon";

grant insert on table "public"."achievements" to "anon";

grant references on table "public"."achievements" to "anon";

grant select on table "public"."achievements" to "anon";

grant trigger on table "public"."achievements" to "anon";

grant truncate on table "public"."achievements" to "anon";

grant update on table "public"."achievements" to "anon";

grant delete on table "public"."achievements" to "authenticated";

grant insert on table "public"."achievements" to "authenticated";

grant references on table "public"."achievements" to "authenticated";

grant select on table "public"."achievements" to "authenticated";

grant trigger on table "public"."achievements" to "authenticated";

grant truncate on table "public"."achievements" to "authenticated";

grant update on table "public"."achievements" to "authenticated";

grant delete on table "public"."achievements" to "service_role";

grant insert on table "public"."achievements" to "service_role";

grant references on table "public"."achievements" to "service_role";

grant select on table "public"."achievements" to "service_role";

grant trigger on table "public"."achievements" to "service_role";

grant truncate on table "public"."achievements" to "service_role";

grant update on table "public"."achievements" to "service_role";

grant delete on table "public"."activity_log" to "anon";

grant insert on table "public"."activity_log" to "anon";

grant references on table "public"."activity_log" to "anon";

grant select on table "public"."activity_log" to "anon";

grant trigger on table "public"."activity_log" to "anon";

grant truncate on table "public"."activity_log" to "anon";

grant update on table "public"."activity_log" to "anon";

grant delete on table "public"."activity_log" to "authenticated";

grant insert on table "public"."activity_log" to "authenticated";

grant references on table "public"."activity_log" to "authenticated";

grant select on table "public"."activity_log" to "authenticated";

grant trigger on table "public"."activity_log" to "authenticated";

grant truncate on table "public"."activity_log" to "authenticated";

grant update on table "public"."activity_log" to "authenticated";

grant delete on table "public"."activity_log" to "service_role";

grant insert on table "public"."activity_log" to "service_role";

grant references on table "public"."activity_log" to "service_role";

grant select on table "public"."activity_log" to "service_role";

grant trigger on table "public"."activity_log" to "service_role";

grant truncate on table "public"."activity_log" to "service_role";

grant update on table "public"."activity_log" to "service_role";

grant delete on table "public"."admin_users" to "anon";

grant insert on table "public"."admin_users" to "anon";

grant references on table "public"."admin_users" to "anon";

grant select on table "public"."admin_users" to "anon";

grant trigger on table "public"."admin_users" to "anon";

grant truncate on table "public"."admin_users" to "anon";

grant update on table "public"."admin_users" to "anon";

grant delete on table "public"."admin_users" to "authenticated";

grant insert on table "public"."admin_users" to "authenticated";

grant references on table "public"."admin_users" to "authenticated";

grant select on table "public"."admin_users" to "authenticated";

grant trigger on table "public"."admin_users" to "authenticated";

grant truncate on table "public"."admin_users" to "authenticated";

grant update on table "public"."admin_users" to "authenticated";

grant delete on table "public"."admin_users" to "service_role";

grant insert on table "public"."admin_users" to "service_role";

grant references on table "public"."admin_users" to "service_role";

grant select on table "public"."admin_users" to "service_role";

grant trigger on table "public"."admin_users" to "service_role";

grant truncate on table "public"."admin_users" to "service_role";

grant update on table "public"."admin_users" to "service_role";

grant delete on table "public"."app_config" to "anon";

grant insert on table "public"."app_config" to "anon";

grant references on table "public"."app_config" to "anon";

grant select on table "public"."app_config" to "anon";

grant trigger on table "public"."app_config" to "anon";

grant truncate on table "public"."app_config" to "anon";

grant update on table "public"."app_config" to "anon";

grant delete on table "public"."app_config" to "authenticated";

grant insert on table "public"."app_config" to "authenticated";

grant references on table "public"."app_config" to "authenticated";

grant select on table "public"."app_config" to "authenticated";

grant trigger on table "public"."app_config" to "authenticated";

grant truncate on table "public"."app_config" to "authenticated";

grant update on table "public"."app_config" to "authenticated";

grant delete on table "public"."app_config" to "service_role";

grant insert on table "public"."app_config" to "service_role";

grant references on table "public"."app_config" to "service_role";

grant select on table "public"."app_config" to "service_role";

grant trigger on table "public"."app_config" to "service_role";

grant truncate on table "public"."app_config" to "service_role";

grant update on table "public"."app_config" to "service_role";

grant delete on table "public"."applications" to "anon";

grant insert on table "public"."applications" to "anon";

grant references on table "public"."applications" to "anon";

grant select on table "public"."applications" to "anon";

grant trigger on table "public"."applications" to "anon";

grant truncate on table "public"."applications" to "anon";

grant update on table "public"."applications" to "anon";

grant delete on table "public"."applications" to "authenticated";

grant insert on table "public"."applications" to "authenticated";

grant references on table "public"."applications" to "authenticated";

grant select on table "public"."applications" to "authenticated";

grant trigger on table "public"."applications" to "authenticated";

grant truncate on table "public"."applications" to "authenticated";

grant update on table "public"."applications" to "authenticated";

grant delete on table "public"."applications" to "service_role";

grant insert on table "public"."applications" to "service_role";

grant references on table "public"."applications" to "service_role";

grant select on table "public"."applications" to "service_role";

grant trigger on table "public"."applications" to "service_role";

grant truncate on table "public"."applications" to "service_role";

grant update on table "public"."applications" to "service_role";

grant delete on table "public"."assignment_submissions" to "anon";

grant insert on table "public"."assignment_submissions" to "anon";

grant references on table "public"."assignment_submissions" to "anon";

grant select on table "public"."assignment_submissions" to "anon";

grant trigger on table "public"."assignment_submissions" to "anon";

grant truncate on table "public"."assignment_submissions" to "anon";

grant update on table "public"."assignment_submissions" to "anon";

grant delete on table "public"."assignment_submissions" to "authenticated";

grant insert on table "public"."assignment_submissions" to "authenticated";

grant references on table "public"."assignment_submissions" to "authenticated";

grant select on table "public"."assignment_submissions" to "authenticated";

grant trigger on table "public"."assignment_submissions" to "authenticated";

grant truncate on table "public"."assignment_submissions" to "authenticated";

grant update on table "public"."assignment_submissions" to "authenticated";

grant delete on table "public"."assignment_submissions" to "service_role";

grant insert on table "public"."assignment_submissions" to "service_role";

grant references on table "public"."assignment_submissions" to "service_role";

grant select on table "public"."assignment_submissions" to "service_role";

grant trigger on table "public"."assignment_submissions" to "service_role";

grant truncate on table "public"."assignment_submissions" to "service_role";

grant update on table "public"."assignment_submissions" to "service_role";

grant delete on table "public"."chatbot_conversations" to "anon";

grant insert on table "public"."chatbot_conversations" to "anon";

grant references on table "public"."chatbot_conversations" to "anon";

grant select on table "public"."chatbot_conversations" to "anon";

grant trigger on table "public"."chatbot_conversations" to "anon";

grant truncate on table "public"."chatbot_conversations" to "anon";

grant update on table "public"."chatbot_conversations" to "anon";

grant delete on table "public"."chatbot_conversations" to "authenticated";

grant insert on table "public"."chatbot_conversations" to "authenticated";

grant references on table "public"."chatbot_conversations" to "authenticated";

grant select on table "public"."chatbot_conversations" to "authenticated";

grant trigger on table "public"."chatbot_conversations" to "authenticated";

grant truncate on table "public"."chatbot_conversations" to "authenticated";

grant update on table "public"."chatbot_conversations" to "authenticated";

grant delete on table "public"."chatbot_conversations" to "service_role";

grant insert on table "public"."chatbot_conversations" to "service_role";

grant references on table "public"."chatbot_conversations" to "service_role";

grant select on table "public"."chatbot_conversations" to "service_role";

grant trigger on table "public"."chatbot_conversations" to "service_role";

grant truncate on table "public"."chatbot_conversations" to "service_role";

grant update on table "public"."chatbot_conversations" to "service_role";

grant delete on table "public"."chatbot_faqs" to "anon";

grant insert on table "public"."chatbot_faqs" to "anon";

grant references on table "public"."chatbot_faqs" to "anon";

grant select on table "public"."chatbot_faqs" to "anon";

grant trigger on table "public"."chatbot_faqs" to "anon";

grant truncate on table "public"."chatbot_faqs" to "anon";

grant update on table "public"."chatbot_faqs" to "anon";

grant delete on table "public"."chatbot_faqs" to "authenticated";

grant insert on table "public"."chatbot_faqs" to "authenticated";

grant references on table "public"."chatbot_faqs" to "authenticated";

grant select on table "public"."chatbot_faqs" to "authenticated";

grant trigger on table "public"."chatbot_faqs" to "authenticated";

grant truncate on table "public"."chatbot_faqs" to "authenticated";

grant update on table "public"."chatbot_faqs" to "authenticated";

grant delete on table "public"."chatbot_faqs" to "service_role";

grant insert on table "public"."chatbot_faqs" to "service_role";

grant references on table "public"."chatbot_faqs" to "service_role";

grant select on table "public"."chatbot_faqs" to "service_role";

grant trigger on table "public"."chatbot_faqs" to "service_role";

grant truncate on table "public"."chatbot_faqs" to "service_role";

grant update on table "public"."chatbot_faqs" to "service_role";

grant delete on table "public"."chatbot_feedback_analytics" to "anon";

grant insert on table "public"."chatbot_feedback_analytics" to "anon";

grant references on table "public"."chatbot_feedback_analytics" to "anon";

grant select on table "public"."chatbot_feedback_analytics" to "anon";

grant trigger on table "public"."chatbot_feedback_analytics" to "anon";

grant truncate on table "public"."chatbot_feedback_analytics" to "anon";

grant update on table "public"."chatbot_feedback_analytics" to "anon";

grant delete on table "public"."chatbot_feedback_analytics" to "authenticated";

grant insert on table "public"."chatbot_feedback_analytics" to "authenticated";

grant references on table "public"."chatbot_feedback_analytics" to "authenticated";

grant select on table "public"."chatbot_feedback_analytics" to "authenticated";

grant trigger on table "public"."chatbot_feedback_analytics" to "authenticated";

grant truncate on table "public"."chatbot_feedback_analytics" to "authenticated";

grant update on table "public"."chatbot_feedback_analytics" to "authenticated";

grant delete on table "public"."chatbot_feedback_analytics" to "service_role";

grant insert on table "public"."chatbot_feedback_analytics" to "service_role";

grant references on table "public"."chatbot_feedback_analytics" to "service_role";

grant select on table "public"."chatbot_feedback_analytics" to "service_role";

grant trigger on table "public"."chatbot_feedback_analytics" to "service_role";

grant truncate on table "public"."chatbot_feedback_analytics" to "service_role";

grant update on table "public"."chatbot_feedback_analytics" to "service_role";

grant delete on table "public"."chatbot_messages" to "anon";

grant insert on table "public"."chatbot_messages" to "anon";

grant references on table "public"."chatbot_messages" to "anon";

grant select on table "public"."chatbot_messages" to "anon";

grant trigger on table "public"."chatbot_messages" to "anon";

grant truncate on table "public"."chatbot_messages" to "anon";

grant update on table "public"."chatbot_messages" to "anon";

grant delete on table "public"."chatbot_messages" to "authenticated";

grant insert on table "public"."chatbot_messages" to "authenticated";

grant references on table "public"."chatbot_messages" to "authenticated";

grant select on table "public"."chatbot_messages" to "authenticated";

grant trigger on table "public"."chatbot_messages" to "authenticated";

grant truncate on table "public"."chatbot_messages" to "authenticated";

grant update on table "public"."chatbot_messages" to "authenticated";

grant delete on table "public"."chatbot_messages" to "service_role";

grant insert on table "public"."chatbot_messages" to "service_role";

grant references on table "public"."chatbot_messages" to "service_role";

grant select on table "public"."chatbot_messages" to "service_role";

grant trigger on table "public"."chatbot_messages" to "service_role";

grant truncate on table "public"."chatbot_messages" to "service_role";

grant update on table "public"."chatbot_messages" to "service_role";

grant delete on table "public"."chatbot_support_queue" to "anon";

grant insert on table "public"."chatbot_support_queue" to "anon";

grant references on table "public"."chatbot_support_queue" to "anon";

grant select on table "public"."chatbot_support_queue" to "anon";

grant trigger on table "public"."chatbot_support_queue" to "anon";

grant truncate on table "public"."chatbot_support_queue" to "anon";

grant update on table "public"."chatbot_support_queue" to "anon";

grant delete on table "public"."chatbot_support_queue" to "authenticated";

grant insert on table "public"."chatbot_support_queue" to "authenticated";

grant references on table "public"."chatbot_support_queue" to "authenticated";

grant select on table "public"."chatbot_support_queue" to "authenticated";

grant trigger on table "public"."chatbot_support_queue" to "authenticated";

grant truncate on table "public"."chatbot_support_queue" to "authenticated";

grant update on table "public"."chatbot_support_queue" to "authenticated";

grant delete on table "public"."chatbot_support_queue" to "service_role";

grant insert on table "public"."chatbot_support_queue" to "service_role";

grant references on table "public"."chatbot_support_queue" to "service_role";

grant select on table "public"."chatbot_support_queue" to "service_role";

grant trigger on table "public"."chatbot_support_queue" to "service_role";

grant truncate on table "public"."chatbot_support_queue" to "service_role";

grant update on table "public"."chatbot_support_queue" to "service_role";

grant delete on table "public"."children" to "anon";

grant insert on table "public"."children" to "anon";

grant references on table "public"."children" to "anon";

grant select on table "public"."children" to "anon";

grant trigger on table "public"."children" to "anon";

grant truncate on table "public"."children" to "anon";

grant update on table "public"."children" to "anon";

grant delete on table "public"."children" to "authenticated";

grant insert on table "public"."children" to "authenticated";

grant references on table "public"."children" to "authenticated";

grant select on table "public"."children" to "authenticated";

grant trigger on table "public"."children" to "authenticated";

grant truncate on table "public"."children" to "authenticated";

grant update on table "public"."children" to "authenticated";

grant delete on table "public"."children" to "service_role";

grant insert on table "public"."children" to "service_role";

grant references on table "public"."children" to "service_role";

grant select on table "public"."children" to "service_role";

grant trigger on table "public"."children" to "service_role";

grant truncate on table "public"."children" to "service_role";

grant update on table "public"."children" to "service_role";

grant delete on table "public"."communication_campaigns" to "anon";

grant insert on table "public"."communication_campaigns" to "anon";

grant references on table "public"."communication_campaigns" to "anon";

grant select on table "public"."communication_campaigns" to "anon";

grant trigger on table "public"."communication_campaigns" to "anon";

grant truncate on table "public"."communication_campaigns" to "anon";

grant update on table "public"."communication_campaigns" to "anon";

grant delete on table "public"."communication_campaigns" to "authenticated";

grant insert on table "public"."communication_campaigns" to "authenticated";

grant references on table "public"."communication_campaigns" to "authenticated";

grant select on table "public"."communication_campaigns" to "authenticated";

grant trigger on table "public"."communication_campaigns" to "authenticated";

grant truncate on table "public"."communication_campaigns" to "authenticated";

grant update on table "public"."communication_campaigns" to "authenticated";

grant delete on table "public"."communication_campaigns" to "service_role";

grant insert on table "public"."communication_campaigns" to "service_role";

grant references on table "public"."communication_campaigns" to "service_role";

grant select on table "public"."communication_campaigns" to "service_role";

grant trigger on table "public"."communication_campaigns" to "service_role";

grant truncate on table "public"."communication_campaigns" to "service_role";

grant update on table "public"."communication_campaigns" to "service_role";

grant delete on table "public"."content_assignments" to "anon";

grant insert on table "public"."content_assignments" to "anon";

grant references on table "public"."content_assignments" to "anon";

grant select on table "public"."content_assignments" to "anon";

grant trigger on table "public"."content_assignments" to "anon";

grant truncate on table "public"."content_assignments" to "anon";

grant update on table "public"."content_assignments" to "anon";

grant delete on table "public"."content_assignments" to "authenticated";

grant insert on table "public"."content_assignments" to "authenticated";

grant references on table "public"."content_assignments" to "authenticated";

grant select on table "public"."content_assignments" to "authenticated";

grant trigger on table "public"."content_assignments" to "authenticated";

grant truncate on table "public"."content_assignments" to "authenticated";

grant update on table "public"."content_assignments" to "authenticated";

grant delete on table "public"."content_assignments" to "service_role";

grant insert on table "public"."content_assignments" to "service_role";

grant references on table "public"."content_assignments" to "service_role";

grant select on table "public"."content_assignments" to "service_role";

grant trigger on table "public"."content_assignments" to "service_role";

grant truncate on table "public"."content_assignments" to "service_role";

grant update on table "public"."content_assignments" to "service_role";

grant delete on table "public"."conversations" to "anon";

grant insert on table "public"."conversations" to "anon";

grant references on table "public"."conversations" to "anon";

grant select on table "public"."conversations" to "anon";

grant trigger on table "public"."conversations" to "anon";

grant truncate on table "public"."conversations" to "anon";

grant update on table "public"."conversations" to "anon";

grant delete on table "public"."conversations" to "authenticated";

grant insert on table "public"."conversations" to "authenticated";

grant references on table "public"."conversations" to "authenticated";

grant select on table "public"."conversations" to "authenticated";

grant trigger on table "public"."conversations" to "authenticated";

grant truncate on table "public"."conversations" to "authenticated";

grant update on table "public"."conversations" to "authenticated";

grant delete on table "public"."conversations" to "service_role";

grant insert on table "public"."conversations" to "service_role";

grant references on table "public"."conversations" to "service_role";

grant select on table "public"."conversations" to "service_role";

grant trigger on table "public"."conversations" to "service_role";

grant truncate on table "public"."conversations" to "service_role";

grant update on table "public"."conversations" to "service_role";

grant delete on table "public"."cookie_consents" to "anon";

grant insert on table "public"."cookie_consents" to "anon";

grant references on table "public"."cookie_consents" to "anon";

grant select on table "public"."cookie_consents" to "anon";

grant trigger on table "public"."cookie_consents" to "anon";

grant truncate on table "public"."cookie_consents" to "anon";

grant update on table "public"."cookie_consents" to "anon";

grant delete on table "public"."cookie_consents" to "authenticated";

grant insert on table "public"."cookie_consents" to "authenticated";

grant references on table "public"."cookie_consents" to "authenticated";

grant select on table "public"."cookie_consents" to "authenticated";

grant trigger on table "public"."cookie_consents" to "authenticated";

grant truncate on table "public"."cookie_consents" to "authenticated";

grant update on table "public"."cookie_consents" to "authenticated";

grant delete on table "public"."cookie_consents" to "service_role";

grant insert on table "public"."cookie_consents" to "service_role";

grant references on table "public"."cookie_consents" to "service_role";

grant select on table "public"."cookie_consents" to "service_role";

grant trigger on table "public"."cookie_consents" to "service_role";

grant truncate on table "public"."cookie_consents" to "service_role";

grant update on table "public"."cookie_consents" to "service_role";

grant delete on table "public"."counseling_sessions" to "anon";

grant insert on table "public"."counseling_sessions" to "anon";

grant references on table "public"."counseling_sessions" to "anon";

grant select on table "public"."counseling_sessions" to "anon";

grant trigger on table "public"."counseling_sessions" to "anon";

grant truncate on table "public"."counseling_sessions" to "anon";

grant update on table "public"."counseling_sessions" to "anon";

grant delete on table "public"."counseling_sessions" to "authenticated";

grant insert on table "public"."counseling_sessions" to "authenticated";

grant references on table "public"."counseling_sessions" to "authenticated";

grant select on table "public"."counseling_sessions" to "authenticated";

grant trigger on table "public"."counseling_sessions" to "authenticated";

grant truncate on table "public"."counseling_sessions" to "authenticated";

grant update on table "public"."counseling_sessions" to "authenticated";

grant delete on table "public"."counseling_sessions" to "service_role";

grant insert on table "public"."counseling_sessions" to "service_role";

grant references on table "public"."counseling_sessions" to "service_role";

grant select on table "public"."counseling_sessions" to "service_role";

grant trigger on table "public"."counseling_sessions" to "service_role";

grant truncate on table "public"."counseling_sessions" to "service_role";

grant update on table "public"."counseling_sessions" to "service_role";

grant delete on table "public"."course_lessons" to "anon";

grant insert on table "public"."course_lessons" to "anon";

grant references on table "public"."course_lessons" to "anon";

grant select on table "public"."course_lessons" to "anon";

grant trigger on table "public"."course_lessons" to "anon";

grant truncate on table "public"."course_lessons" to "anon";

grant update on table "public"."course_lessons" to "anon";

grant delete on table "public"."course_lessons" to "authenticated";

grant insert on table "public"."course_lessons" to "authenticated";

grant references on table "public"."course_lessons" to "authenticated";

grant select on table "public"."course_lessons" to "authenticated";

grant trigger on table "public"."course_lessons" to "authenticated";

grant truncate on table "public"."course_lessons" to "authenticated";

grant update on table "public"."course_lessons" to "authenticated";

grant delete on table "public"."course_lessons" to "service_role";

grant insert on table "public"."course_lessons" to "service_role";

grant references on table "public"."course_lessons" to "service_role";

grant select on table "public"."course_lessons" to "service_role";

grant trigger on table "public"."course_lessons" to "service_role";

grant truncate on table "public"."course_lessons" to "service_role";

grant update on table "public"."course_lessons" to "service_role";

grant delete on table "public"."course_modules" to "anon";

grant insert on table "public"."course_modules" to "anon";

grant references on table "public"."course_modules" to "anon";

grant select on table "public"."course_modules" to "anon";

grant trigger on table "public"."course_modules" to "anon";

grant truncate on table "public"."course_modules" to "anon";

grant update on table "public"."course_modules" to "anon";

grant delete on table "public"."course_modules" to "authenticated";

grant insert on table "public"."course_modules" to "authenticated";

grant references on table "public"."course_modules" to "authenticated";

grant select on table "public"."course_modules" to "authenticated";

grant trigger on table "public"."course_modules" to "authenticated";

grant truncate on table "public"."course_modules" to "authenticated";

grant update on table "public"."course_modules" to "authenticated";

grant delete on table "public"."course_modules" to "service_role";

grant insert on table "public"."course_modules" to "service_role";

grant references on table "public"."course_modules" to "service_role";

grant select on table "public"."course_modules" to "service_role";

grant trigger on table "public"."course_modules" to "service_role";

grant truncate on table "public"."course_modules" to "service_role";

grant update on table "public"."course_modules" to "service_role";

grant delete on table "public"."courses" to "anon";

grant insert on table "public"."courses" to "anon";

grant references on table "public"."courses" to "anon";

grant select on table "public"."courses" to "anon";

grant trigger on table "public"."courses" to "anon";

grant truncate on table "public"."courses" to "anon";

grant update on table "public"."courses" to "anon";

grant delete on table "public"."courses" to "authenticated";

grant insert on table "public"."courses" to "authenticated";

grant references on table "public"."courses" to "authenticated";

grant select on table "public"."courses" to "authenticated";

grant trigger on table "public"."courses" to "authenticated";

grant truncate on table "public"."courses" to "authenticated";

grant update on table "public"."courses" to "authenticated";

grant delete on table "public"."courses" to "service_role";

grant insert on table "public"."courses" to "service_role";

grant references on table "public"."courses" to "service_role";

grant select on table "public"."courses" to "service_role";

grant trigger on table "public"."courses" to "service_role";

grant truncate on table "public"."courses" to "service_role";

grant update on table "public"."courses" to "service_role";

grant delete on table "public"."documents" to "anon";

grant insert on table "public"."documents" to "anon";

grant references on table "public"."documents" to "anon";

grant select on table "public"."documents" to "anon";

grant trigger on table "public"."documents" to "anon";

grant truncate on table "public"."documents" to "anon";

grant update on table "public"."documents" to "anon";

grant delete on table "public"."documents" to "authenticated";

grant insert on table "public"."documents" to "authenticated";

grant references on table "public"."documents" to "authenticated";

grant select on table "public"."documents" to "authenticated";

grant trigger on table "public"."documents" to "authenticated";

grant truncate on table "public"."documents" to "authenticated";

grant update on table "public"."documents" to "authenticated";

grant delete on table "public"."documents" to "service_role";

grant insert on table "public"."documents" to "service_role";

grant references on table "public"."documents" to "service_role";

grant select on table "public"."documents" to "service_role";

grant trigger on table "public"."documents" to "service_role";

grant truncate on table "public"."documents" to "service_role";

grant update on table "public"."documents" to "service_role";

grant delete on table "public"."enrichment_cache" to "anon";

grant insert on table "public"."enrichment_cache" to "anon";

grant references on table "public"."enrichment_cache" to "anon";

grant select on table "public"."enrichment_cache" to "anon";

grant trigger on table "public"."enrichment_cache" to "anon";

grant truncate on table "public"."enrichment_cache" to "anon";

grant update on table "public"."enrichment_cache" to "anon";

grant delete on table "public"."enrichment_cache" to "authenticated";

grant insert on table "public"."enrichment_cache" to "authenticated";

grant references on table "public"."enrichment_cache" to "authenticated";

grant select on table "public"."enrichment_cache" to "authenticated";

grant trigger on table "public"."enrichment_cache" to "authenticated";

grant truncate on table "public"."enrichment_cache" to "authenticated";

grant update on table "public"."enrichment_cache" to "authenticated";

grant delete on table "public"."enrichment_cache" to "service_role";

grant insert on table "public"."enrichment_cache" to "service_role";

grant references on table "public"."enrichment_cache" to "service_role";

grant select on table "public"."enrichment_cache" to "service_role";

grant trigger on table "public"."enrichment_cache" to "service_role";

grant truncate on table "public"."enrichment_cache" to "service_role";

grant update on table "public"."enrichment_cache" to "service_role";

grant delete on table "public"."enrichment_jobs" to "anon";

grant insert on table "public"."enrichment_jobs" to "anon";

grant references on table "public"."enrichment_jobs" to "anon";

grant select on table "public"."enrichment_jobs" to "anon";

grant trigger on table "public"."enrichment_jobs" to "anon";

grant truncate on table "public"."enrichment_jobs" to "anon";

grant update on table "public"."enrichment_jobs" to "anon";

grant delete on table "public"."enrichment_jobs" to "authenticated";

grant insert on table "public"."enrichment_jobs" to "authenticated";

grant references on table "public"."enrichment_jobs" to "authenticated";

grant select on table "public"."enrichment_jobs" to "authenticated";

grant trigger on table "public"."enrichment_jobs" to "authenticated";

grant truncate on table "public"."enrichment_jobs" to "authenticated";

grant update on table "public"."enrichment_jobs" to "authenticated";

grant delete on table "public"."enrichment_jobs" to "service_role";

grant insert on table "public"."enrichment_jobs" to "service_role";

grant references on table "public"."enrichment_jobs" to "service_role";

grant select on table "public"."enrichment_jobs" to "service_role";

grant trigger on table "public"."enrichment_jobs" to "service_role";

grant truncate on table "public"."enrichment_jobs" to "service_role";

grant update on table "public"."enrichment_jobs" to "service_role";

grant delete on table "public"."enrollment_permissions" to "anon";

grant insert on table "public"."enrollment_permissions" to "anon";

grant references on table "public"."enrollment_permissions" to "anon";

grant select on table "public"."enrollment_permissions" to "anon";

grant trigger on table "public"."enrollment_permissions" to "anon";

grant truncate on table "public"."enrollment_permissions" to "anon";

grant update on table "public"."enrollment_permissions" to "anon";

grant delete on table "public"."enrollment_permissions" to "authenticated";

grant insert on table "public"."enrollment_permissions" to "authenticated";

grant references on table "public"."enrollment_permissions" to "authenticated";

grant select on table "public"."enrollment_permissions" to "authenticated";

grant trigger on table "public"."enrollment_permissions" to "authenticated";

grant truncate on table "public"."enrollment_permissions" to "authenticated";

grant update on table "public"."enrollment_permissions" to "authenticated";

grant delete on table "public"."enrollment_permissions" to "service_role";

grant insert on table "public"."enrollment_permissions" to "service_role";

grant references on table "public"."enrollment_permissions" to "service_role";

grant select on table "public"."enrollment_permissions" to "service_role";

grant trigger on table "public"."enrollment_permissions" to "service_role";

grant truncate on table "public"."enrollment_permissions" to "service_role";

grant update on table "public"."enrollment_permissions" to "service_role";

grant delete on table "public"."enrollments" to "anon";

grant insert on table "public"."enrollments" to "anon";

grant references on table "public"."enrollments" to "anon";

grant select on table "public"."enrollments" to "anon";

grant trigger on table "public"."enrollments" to "anon";

grant truncate on table "public"."enrollments" to "anon";

grant update on table "public"."enrollments" to "anon";

grant delete on table "public"."enrollments" to "authenticated";

grant insert on table "public"."enrollments" to "authenticated";

grant references on table "public"."enrollments" to "authenticated";

grant select on table "public"."enrollments" to "authenticated";

grant trigger on table "public"."enrollments" to "authenticated";

grant truncate on table "public"."enrollments" to "authenticated";

grant update on table "public"."enrollments" to "authenticated";

grant delete on table "public"."enrollments" to "service_role";

grant insert on table "public"."enrollments" to "service_role";

grant references on table "public"."enrollments" to "service_role";

grant select on table "public"."enrollments" to "service_role";

grant trigger on table "public"."enrollments" to "service_role";

grant truncate on table "public"."enrollments" to "service_role";

grant update on table "public"."enrollments" to "service_role";

grant delete on table "public"."gpa_history" to "anon";

grant insert on table "public"."gpa_history" to "anon";

grant references on table "public"."gpa_history" to "anon";

grant select on table "public"."gpa_history" to "anon";

grant trigger on table "public"."gpa_history" to "anon";

grant truncate on table "public"."gpa_history" to "anon";

grant update on table "public"."gpa_history" to "anon";

grant delete on table "public"."gpa_history" to "authenticated";

grant insert on table "public"."gpa_history" to "authenticated";

grant references on table "public"."gpa_history" to "authenticated";

grant select on table "public"."gpa_history" to "authenticated";

grant trigger on table "public"."gpa_history" to "authenticated";

grant truncate on table "public"."gpa_history" to "authenticated";

grant update on table "public"."gpa_history" to "authenticated";

grant delete on table "public"."gpa_history" to "service_role";

grant insert on table "public"."gpa_history" to "service_role";

grant references on table "public"."gpa_history" to "service_role";

grant select on table "public"."gpa_history" to "service_role";

grant trigger on table "public"."gpa_history" to "service_role";

grant truncate on table "public"."gpa_history" to "service_role";

grant update on table "public"."gpa_history" to "service_role";

grant delete on table "public"."grade_alerts" to "anon";

grant insert on table "public"."grade_alerts" to "anon";

grant references on table "public"."grade_alerts" to "anon";

grant select on table "public"."grade_alerts" to "anon";

grant trigger on table "public"."grade_alerts" to "anon";

grant truncate on table "public"."grade_alerts" to "anon";

grant update on table "public"."grade_alerts" to "anon";

grant delete on table "public"."grade_alerts" to "authenticated";

grant insert on table "public"."grade_alerts" to "authenticated";

grant references on table "public"."grade_alerts" to "authenticated";

grant select on table "public"."grade_alerts" to "authenticated";

grant trigger on table "public"."grade_alerts" to "authenticated";

grant truncate on table "public"."grade_alerts" to "authenticated";

grant update on table "public"."grade_alerts" to "authenticated";

grant delete on table "public"."grade_alerts" to "service_role";

grant insert on table "public"."grade_alerts" to "service_role";

grant references on table "public"."grade_alerts" to "service_role";

grant select on table "public"."grade_alerts" to "service_role";

grant trigger on table "public"."grade_alerts" to "service_role";

grant truncate on table "public"."grade_alerts" to "service_role";

grant update on table "public"."grade_alerts" to "service_role";

grant delete on table "public"."grades" to "anon";

grant insert on table "public"."grades" to "anon";

grant references on table "public"."grades" to "anon";

grant select on table "public"."grades" to "anon";

grant trigger on table "public"."grades" to "anon";

grant truncate on table "public"."grades" to "anon";

grant update on table "public"."grades" to "anon";

grant delete on table "public"."grades" to "authenticated";

grant insert on table "public"."grades" to "authenticated";

grant references on table "public"."grades" to "authenticated";

grant select on table "public"."grades" to "authenticated";

grant trigger on table "public"."grades" to "authenticated";

grant truncate on table "public"."grades" to "authenticated";

grant update on table "public"."grades" to "authenticated";

grant delete on table "public"."grades" to "service_role";

grant insert on table "public"."grades" to "service_role";

grant references on table "public"."grades" to "service_role";

grant select on table "public"."grades" to "service_role";

grant trigger on table "public"."grades" to "service_role";

grant truncate on table "public"."grades" to "service_role";

grant update on table "public"."grades" to "service_role";

grant delete on table "public"."institution_programs" to "anon";

grant insert on table "public"."institution_programs" to "anon";

grant references on table "public"."institution_programs" to "anon";

grant select on table "public"."institution_programs" to "anon";

grant trigger on table "public"."institution_programs" to "anon";

grant truncate on table "public"."institution_programs" to "anon";

grant update on table "public"."institution_programs" to "anon";

grant delete on table "public"."institution_programs" to "authenticated";

grant insert on table "public"."institution_programs" to "authenticated";

grant references on table "public"."institution_programs" to "authenticated";

grant select on table "public"."institution_programs" to "authenticated";

grant trigger on table "public"."institution_programs" to "authenticated";

grant truncate on table "public"."institution_programs" to "authenticated";

grant update on table "public"."institution_programs" to "authenticated";

grant delete on table "public"."institution_programs" to "service_role";

grant insert on table "public"."institution_programs" to "service_role";

grant references on table "public"."institution_programs" to "service_role";

grant select on table "public"."institution_programs" to "service_role";

grant trigger on table "public"."institution_programs" to "service_role";

grant truncate on table "public"."institution_programs" to "service_role";

grant update on table "public"."institution_programs" to "service_role";

grant delete on table "public"."lesson_assignments" to "anon";

grant insert on table "public"."lesson_assignments" to "anon";

grant references on table "public"."lesson_assignments" to "anon";

grant select on table "public"."lesson_assignments" to "anon";

grant trigger on table "public"."lesson_assignments" to "anon";

grant truncate on table "public"."lesson_assignments" to "anon";

grant update on table "public"."lesson_assignments" to "anon";

grant delete on table "public"."lesson_assignments" to "authenticated";

grant insert on table "public"."lesson_assignments" to "authenticated";

grant references on table "public"."lesson_assignments" to "authenticated";

grant select on table "public"."lesson_assignments" to "authenticated";

grant trigger on table "public"."lesson_assignments" to "authenticated";

grant truncate on table "public"."lesson_assignments" to "authenticated";

grant update on table "public"."lesson_assignments" to "authenticated";

grant delete on table "public"."lesson_assignments" to "service_role";

grant insert on table "public"."lesson_assignments" to "service_role";

grant references on table "public"."lesson_assignments" to "service_role";

grant select on table "public"."lesson_assignments" to "service_role";

grant trigger on table "public"."lesson_assignments" to "service_role";

grant truncate on table "public"."lesson_assignments" to "service_role";

grant update on table "public"."lesson_assignments" to "service_role";

grant delete on table "public"."lesson_completions" to "anon";

grant insert on table "public"."lesson_completions" to "anon";

grant references on table "public"."lesson_completions" to "anon";

grant select on table "public"."lesson_completions" to "anon";

grant trigger on table "public"."lesson_completions" to "anon";

grant truncate on table "public"."lesson_completions" to "anon";

grant update on table "public"."lesson_completions" to "anon";

grant delete on table "public"."lesson_completions" to "authenticated";

grant insert on table "public"."lesson_completions" to "authenticated";

grant references on table "public"."lesson_completions" to "authenticated";

grant select on table "public"."lesson_completions" to "authenticated";

grant trigger on table "public"."lesson_completions" to "authenticated";

grant truncate on table "public"."lesson_completions" to "authenticated";

grant update on table "public"."lesson_completions" to "authenticated";

grant delete on table "public"."lesson_completions" to "service_role";

grant insert on table "public"."lesson_completions" to "service_role";

grant references on table "public"."lesson_completions" to "service_role";

grant select on table "public"."lesson_completions" to "service_role";

grant trigger on table "public"."lesson_completions" to "service_role";

grant truncate on table "public"."lesson_completions" to "service_role";

grant update on table "public"."lesson_completions" to "service_role";

grant delete on table "public"."lesson_quizzes" to "anon";

grant insert on table "public"."lesson_quizzes" to "anon";

grant references on table "public"."lesson_quizzes" to "anon";

grant select on table "public"."lesson_quizzes" to "anon";

grant trigger on table "public"."lesson_quizzes" to "anon";

grant truncate on table "public"."lesson_quizzes" to "anon";

grant update on table "public"."lesson_quizzes" to "anon";

grant delete on table "public"."lesson_quizzes" to "authenticated";

grant insert on table "public"."lesson_quizzes" to "authenticated";

grant references on table "public"."lesson_quizzes" to "authenticated";

grant select on table "public"."lesson_quizzes" to "authenticated";

grant trigger on table "public"."lesson_quizzes" to "authenticated";

grant truncate on table "public"."lesson_quizzes" to "authenticated";

grant update on table "public"."lesson_quizzes" to "authenticated";

grant delete on table "public"."lesson_quizzes" to "service_role";

grant insert on table "public"."lesson_quizzes" to "service_role";

grant references on table "public"."lesson_quizzes" to "service_role";

grant select on table "public"."lesson_quizzes" to "service_role";

grant trigger on table "public"."lesson_quizzes" to "service_role";

grant truncate on table "public"."lesson_quizzes" to "service_role";

grant update on table "public"."lesson_quizzes" to "service_role";

grant delete on table "public"."lesson_texts" to "anon";

grant insert on table "public"."lesson_texts" to "anon";

grant references on table "public"."lesson_texts" to "anon";

grant select on table "public"."lesson_texts" to "anon";

grant trigger on table "public"."lesson_texts" to "anon";

grant truncate on table "public"."lesson_texts" to "anon";

grant update on table "public"."lesson_texts" to "anon";

grant delete on table "public"."lesson_texts" to "authenticated";

grant insert on table "public"."lesson_texts" to "authenticated";

grant references on table "public"."lesson_texts" to "authenticated";

grant select on table "public"."lesson_texts" to "authenticated";

grant trigger on table "public"."lesson_texts" to "authenticated";

grant truncate on table "public"."lesson_texts" to "authenticated";

grant update on table "public"."lesson_texts" to "authenticated";

grant delete on table "public"."lesson_texts" to "service_role";

grant insert on table "public"."lesson_texts" to "service_role";

grant references on table "public"."lesson_texts" to "service_role";

grant select on table "public"."lesson_texts" to "service_role";

grant trigger on table "public"."lesson_texts" to "service_role";

grant truncate on table "public"."lesson_texts" to "service_role";

grant update on table "public"."lesson_texts" to "service_role";

grant delete on table "public"."lesson_videos" to "anon";

grant insert on table "public"."lesson_videos" to "anon";

grant references on table "public"."lesson_videos" to "anon";

grant select on table "public"."lesson_videos" to "anon";

grant trigger on table "public"."lesson_videos" to "anon";

grant truncate on table "public"."lesson_videos" to "anon";

grant update on table "public"."lesson_videos" to "anon";

grant delete on table "public"."lesson_videos" to "authenticated";

grant insert on table "public"."lesson_videos" to "authenticated";

grant references on table "public"."lesson_videos" to "authenticated";

grant select on table "public"."lesson_videos" to "authenticated";

grant trigger on table "public"."lesson_videos" to "authenticated";

grant truncate on table "public"."lesson_videos" to "authenticated";

grant update on table "public"."lesson_videos" to "authenticated";

grant delete on table "public"."lesson_videos" to "service_role";

grant insert on table "public"."lesson_videos" to "service_role";

grant references on table "public"."lesson_videos" to "service_role";

grant select on table "public"."lesson_videos" to "service_role";

grant trigger on table "public"."lesson_videos" to "service_role";

grant truncate on table "public"."lesson_videos" to "service_role";

grant update on table "public"."lesson_videos" to "service_role";

grant delete on table "public"."letter_of_recommendations" to "anon";

grant insert on table "public"."letter_of_recommendations" to "anon";

grant references on table "public"."letter_of_recommendations" to "anon";

grant select on table "public"."letter_of_recommendations" to "anon";

grant trigger on table "public"."letter_of_recommendations" to "anon";

grant truncate on table "public"."letter_of_recommendations" to "anon";

grant update on table "public"."letter_of_recommendations" to "anon";

grant delete on table "public"."letter_of_recommendations" to "authenticated";

grant insert on table "public"."letter_of_recommendations" to "authenticated";

grant references on table "public"."letter_of_recommendations" to "authenticated";

grant select on table "public"."letter_of_recommendations" to "authenticated";

grant trigger on table "public"."letter_of_recommendations" to "authenticated";

grant truncate on table "public"."letter_of_recommendations" to "authenticated";

grant update on table "public"."letter_of_recommendations" to "authenticated";

grant delete on table "public"."letter_of_recommendations" to "service_role";

grant insert on table "public"."letter_of_recommendations" to "service_role";

grant references on table "public"."letter_of_recommendations" to "service_role";

grant select on table "public"."letter_of_recommendations" to "service_role";

grant trigger on table "public"."letter_of_recommendations" to "service_role";

grant truncate on table "public"."letter_of_recommendations" to "service_role";

grant update on table "public"."letter_of_recommendations" to "service_role";

grant delete on table "public"."meetings" to "anon";

grant insert on table "public"."meetings" to "anon";

grant references on table "public"."meetings" to "anon";

grant select on table "public"."meetings" to "anon";

grant trigger on table "public"."meetings" to "anon";

grant truncate on table "public"."meetings" to "anon";

grant update on table "public"."meetings" to "anon";

grant delete on table "public"."meetings" to "authenticated";

grant insert on table "public"."meetings" to "authenticated";

grant references on table "public"."meetings" to "authenticated";

grant select on table "public"."meetings" to "authenticated";

grant trigger on table "public"."meetings" to "authenticated";

grant truncate on table "public"."meetings" to "authenticated";

grant update on table "public"."meetings" to "authenticated";

grant delete on table "public"."meetings" to "service_role";

grant insert on table "public"."meetings" to "service_role";

grant references on table "public"."meetings" to "service_role";

grant select on table "public"."meetings" to "service_role";

grant trigger on table "public"."meetings" to "service_role";

grant truncate on table "public"."meetings" to "service_role";

grant update on table "public"."meetings" to "service_role";

grant delete on table "public"."messages" to "anon";

grant insert on table "public"."messages" to "anon";

grant references on table "public"."messages" to "anon";

grant select on table "public"."messages" to "anon";

grant trigger on table "public"."messages" to "anon";

grant truncate on table "public"."messages" to "anon";

grant update on table "public"."messages" to "anon";

grant delete on table "public"."messages" to "authenticated";

grant insert on table "public"."messages" to "authenticated";

grant references on table "public"."messages" to "authenticated";

grant select on table "public"."messages" to "authenticated";

grant trigger on table "public"."messages" to "authenticated";

grant truncate on table "public"."messages" to "authenticated";

grant update on table "public"."messages" to "authenticated";

grant delete on table "public"."messages" to "service_role";

grant insert on table "public"."messages" to "service_role";

grant references on table "public"."messages" to "service_role";

grant select on table "public"."messages" to "service_role";

grant trigger on table "public"."messages" to "service_role";

grant truncate on table "public"."messages" to "service_role";

grant update on table "public"."messages" to "service_role";

grant delete on table "public"."notification_preferences" to "anon";

grant insert on table "public"."notification_preferences" to "anon";

grant references on table "public"."notification_preferences" to "anon";

grant select on table "public"."notification_preferences" to "anon";

grant trigger on table "public"."notification_preferences" to "anon";

grant truncate on table "public"."notification_preferences" to "anon";

grant update on table "public"."notification_preferences" to "anon";

grant delete on table "public"."notification_preferences" to "authenticated";

grant insert on table "public"."notification_preferences" to "authenticated";

grant references on table "public"."notification_preferences" to "authenticated";

grant select on table "public"."notification_preferences" to "authenticated";

grant trigger on table "public"."notification_preferences" to "authenticated";

grant truncate on table "public"."notification_preferences" to "authenticated";

grant update on table "public"."notification_preferences" to "authenticated";

grant delete on table "public"."notification_preferences" to "service_role";

grant insert on table "public"."notification_preferences" to "service_role";

grant references on table "public"."notification_preferences" to "service_role";

grant select on table "public"."notification_preferences" to "service_role";

grant trigger on table "public"."notification_preferences" to "service_role";

grant truncate on table "public"."notification_preferences" to "service_role";

grant update on table "public"."notification_preferences" to "service_role";

grant delete on table "public"."notifications" to "anon";

grant insert on table "public"."notifications" to "anon";

grant references on table "public"."notifications" to "anon";

grant select on table "public"."notifications" to "anon";

grant trigger on table "public"."notifications" to "anon";

grant truncate on table "public"."notifications" to "anon";

grant update on table "public"."notifications" to "anon";

grant delete on table "public"."notifications" to "authenticated";

grant insert on table "public"."notifications" to "authenticated";

grant references on table "public"."notifications" to "authenticated";

grant select on table "public"."notifications" to "authenticated";

grant trigger on table "public"."notifications" to "authenticated";

grant truncate on table "public"."notifications" to "authenticated";

grant update on table "public"."notifications" to "authenticated";

grant delete on table "public"."notifications" to "service_role";

grant insert on table "public"."notifications" to "service_role";

grant references on table "public"."notifications" to "service_role";

grant select on table "public"."notifications" to "service_role";

grant trigger on table "public"."notifications" to "service_role";

grant truncate on table "public"."notifications" to "service_role";

grant update on table "public"."notifications" to "service_role";

grant delete on table "public"."page_cache" to "anon";

grant insert on table "public"."page_cache" to "anon";

grant references on table "public"."page_cache" to "anon";

grant select on table "public"."page_cache" to "anon";

grant trigger on table "public"."page_cache" to "anon";

grant truncate on table "public"."page_cache" to "anon";

grant update on table "public"."page_cache" to "anon";

grant delete on table "public"."page_cache" to "authenticated";

grant insert on table "public"."page_cache" to "authenticated";

grant references on table "public"."page_cache" to "authenticated";

grant select on table "public"."page_cache" to "authenticated";

grant trigger on table "public"."page_cache" to "authenticated";

grant truncate on table "public"."page_cache" to "authenticated";

grant update on table "public"."page_cache" to "authenticated";

grant delete on table "public"."page_cache" to "service_role";

grant insert on table "public"."page_cache" to "service_role";

grant references on table "public"."page_cache" to "service_role";

grant select on table "public"."page_cache" to "service_role";

grant trigger on table "public"."page_cache" to "service_role";

grant truncate on table "public"."page_cache" to "service_role";

grant update on table "public"."page_cache" to "service_role";

grant delete on table "public"."page_contents" to "anon";

grant insert on table "public"."page_contents" to "anon";

grant references on table "public"."page_contents" to "anon";

grant select on table "public"."page_contents" to "anon";

grant trigger on table "public"."page_contents" to "anon";

grant truncate on table "public"."page_contents" to "anon";

grant update on table "public"."page_contents" to "anon";

grant delete on table "public"."page_contents" to "authenticated";

grant insert on table "public"."page_contents" to "authenticated";

grant references on table "public"."page_contents" to "authenticated";

grant select on table "public"."page_contents" to "authenticated";

grant trigger on table "public"."page_contents" to "authenticated";

grant truncate on table "public"."page_contents" to "authenticated";

grant update on table "public"."page_contents" to "authenticated";

grant delete on table "public"."page_contents" to "service_role";

grant insert on table "public"."page_contents" to "service_role";

grant references on table "public"."page_contents" to "service_role";

grant select on table "public"."page_contents" to "service_role";

grant trigger on table "public"."page_contents" to "service_role";

grant truncate on table "public"."page_contents" to "service_role";

grant update on table "public"."page_contents" to "service_role";

grant delete on table "public"."parent_alerts" to "anon";

grant insert on table "public"."parent_alerts" to "anon";

grant references on table "public"."parent_alerts" to "anon";

grant select on table "public"."parent_alerts" to "anon";

grant trigger on table "public"."parent_alerts" to "anon";

grant truncate on table "public"."parent_alerts" to "anon";

grant update on table "public"."parent_alerts" to "anon";

grant delete on table "public"."parent_alerts" to "authenticated";

grant insert on table "public"."parent_alerts" to "authenticated";

grant references on table "public"."parent_alerts" to "authenticated";

grant select on table "public"."parent_alerts" to "authenticated";

grant trigger on table "public"."parent_alerts" to "authenticated";

grant truncate on table "public"."parent_alerts" to "authenticated";

grant update on table "public"."parent_alerts" to "authenticated";

grant delete on table "public"."parent_alerts" to "service_role";

grant insert on table "public"."parent_alerts" to "service_role";

grant references on table "public"."parent_alerts" to "service_role";

grant select on table "public"."parent_alerts" to "service_role";

grant trigger on table "public"."parent_alerts" to "service_role";

grant truncate on table "public"."parent_alerts" to "service_role";

grant update on table "public"."parent_alerts" to "service_role";

grant delete on table "public"."parent_children" to "anon";

grant insert on table "public"."parent_children" to "anon";

grant references on table "public"."parent_children" to "anon";

grant select on table "public"."parent_children" to "anon";

grant trigger on table "public"."parent_children" to "anon";

grant truncate on table "public"."parent_children" to "anon";

grant update on table "public"."parent_children" to "anon";

grant delete on table "public"."parent_children" to "authenticated";

grant insert on table "public"."parent_children" to "authenticated";

grant references on table "public"."parent_children" to "authenticated";

grant select on table "public"."parent_children" to "authenticated";

grant trigger on table "public"."parent_children" to "authenticated";

grant truncate on table "public"."parent_children" to "authenticated";

grant update on table "public"."parent_children" to "authenticated";

grant delete on table "public"."parent_children" to "service_role";

grant insert on table "public"."parent_children" to "service_role";

grant references on table "public"."parent_children" to "service_role";

grant select on table "public"."parent_children" to "service_role";

grant trigger on table "public"."parent_children" to "service_role";

grant truncate on table "public"."parent_children" to "service_role";

grant update on table "public"."parent_children" to "service_role";

grant delete on table "public"."parent_student_links" to "anon";

grant insert on table "public"."parent_student_links" to "anon";

grant references on table "public"."parent_student_links" to "anon";

grant select on table "public"."parent_student_links" to "anon";

grant trigger on table "public"."parent_student_links" to "anon";

grant truncate on table "public"."parent_student_links" to "anon";

grant update on table "public"."parent_student_links" to "anon";

grant delete on table "public"."parent_student_links" to "authenticated";

grant insert on table "public"."parent_student_links" to "authenticated";

grant references on table "public"."parent_student_links" to "authenticated";

grant select on table "public"."parent_student_links" to "authenticated";

grant trigger on table "public"."parent_student_links" to "authenticated";

grant truncate on table "public"."parent_student_links" to "authenticated";

grant update on table "public"."parent_student_links" to "authenticated";

grant delete on table "public"."parent_student_links" to "service_role";

grant insert on table "public"."parent_student_links" to "service_role";

grant references on table "public"."parent_student_links" to "service_role";

grant select on table "public"."parent_student_links" to "service_role";

grant trigger on table "public"."parent_student_links" to "service_role";

grant truncate on table "public"."parent_student_links" to "service_role";

grant update on table "public"."parent_student_links" to "service_role";

grant delete on table "public"."payments" to "anon";

grant insert on table "public"."payments" to "anon";

grant references on table "public"."payments" to "anon";

grant select on table "public"."payments" to "anon";

grant trigger on table "public"."payments" to "anon";

grant truncate on table "public"."payments" to "anon";

grant update on table "public"."payments" to "anon";

grant delete on table "public"."payments" to "authenticated";

grant insert on table "public"."payments" to "authenticated";

grant references on table "public"."payments" to "authenticated";

grant select on table "public"."payments" to "authenticated";

grant trigger on table "public"."payments" to "authenticated";

grant truncate on table "public"."payments" to "authenticated";

grant update on table "public"."payments" to "authenticated";

grant delete on table "public"."payments" to "service_role";

grant insert on table "public"."payments" to "service_role";

grant references on table "public"."payments" to "service_role";

grant select on table "public"."payments" to "service_role";

grant trigger on table "public"."payments" to "service_role";

grant truncate on table "public"."payments" to "service_role";

grant update on table "public"."payments" to "service_role";

grant delete on table "public"."programs" to "anon";

grant insert on table "public"."programs" to "anon";

grant references on table "public"."programs" to "anon";

grant select on table "public"."programs" to "anon";

grant trigger on table "public"."programs" to "anon";

grant truncate on table "public"."programs" to "anon";

grant update on table "public"."programs" to "anon";

grant delete on table "public"."programs" to "authenticated";

grant insert on table "public"."programs" to "authenticated";

grant references on table "public"."programs" to "authenticated";

grant select on table "public"."programs" to "authenticated";

grant trigger on table "public"."programs" to "authenticated";

grant truncate on table "public"."programs" to "authenticated";

grant update on table "public"."programs" to "authenticated";

grant delete on table "public"."programs" to "service_role";

grant insert on table "public"."programs" to "service_role";

grant references on table "public"."programs" to "service_role";

grant select on table "public"."programs" to "service_role";

grant trigger on table "public"."programs" to "service_role";

grant truncate on table "public"."programs" to "service_role";

grant update on table "public"."programs" to "service_role";

grant delete on table "public"."quiz_attempts" to "anon";

grant insert on table "public"."quiz_attempts" to "anon";

grant references on table "public"."quiz_attempts" to "anon";

grant select on table "public"."quiz_attempts" to "anon";

grant trigger on table "public"."quiz_attempts" to "anon";

grant truncate on table "public"."quiz_attempts" to "anon";

grant update on table "public"."quiz_attempts" to "anon";

grant delete on table "public"."quiz_attempts" to "authenticated";

grant insert on table "public"."quiz_attempts" to "authenticated";

grant references on table "public"."quiz_attempts" to "authenticated";

grant select on table "public"."quiz_attempts" to "authenticated";

grant trigger on table "public"."quiz_attempts" to "authenticated";

grant truncate on table "public"."quiz_attempts" to "authenticated";

grant update on table "public"."quiz_attempts" to "authenticated";

grant delete on table "public"."quiz_attempts" to "service_role";

grant insert on table "public"."quiz_attempts" to "service_role";

grant references on table "public"."quiz_attempts" to "service_role";

grant select on table "public"."quiz_attempts" to "service_role";

grant trigger on table "public"."quiz_attempts" to "service_role";

grant truncate on table "public"."quiz_attempts" to "service_role";

grant update on table "public"."quiz_attempts" to "service_role";

grant delete on table "public"."quiz_question_options" to "anon";

grant insert on table "public"."quiz_question_options" to "anon";

grant references on table "public"."quiz_question_options" to "anon";

grant select on table "public"."quiz_question_options" to "anon";

grant trigger on table "public"."quiz_question_options" to "anon";

grant truncate on table "public"."quiz_question_options" to "anon";

grant update on table "public"."quiz_question_options" to "anon";

grant delete on table "public"."quiz_question_options" to "authenticated";

grant insert on table "public"."quiz_question_options" to "authenticated";

grant references on table "public"."quiz_question_options" to "authenticated";

grant select on table "public"."quiz_question_options" to "authenticated";

grant trigger on table "public"."quiz_question_options" to "authenticated";

grant truncate on table "public"."quiz_question_options" to "authenticated";

grant update on table "public"."quiz_question_options" to "authenticated";

grant delete on table "public"."quiz_question_options" to "service_role";

grant insert on table "public"."quiz_question_options" to "service_role";

grant references on table "public"."quiz_question_options" to "service_role";

grant select on table "public"."quiz_question_options" to "service_role";

grant trigger on table "public"."quiz_question_options" to "service_role";

grant truncate on table "public"."quiz_question_options" to "service_role";

grant update on table "public"."quiz_question_options" to "service_role";

grant delete on table "public"."quiz_questions" to "anon";

grant insert on table "public"."quiz_questions" to "anon";

grant references on table "public"."quiz_questions" to "anon";

grant select on table "public"."quiz_questions" to "anon";

grant trigger on table "public"."quiz_questions" to "anon";

grant truncate on table "public"."quiz_questions" to "anon";

grant update on table "public"."quiz_questions" to "anon";

grant delete on table "public"."quiz_questions" to "authenticated";

grant insert on table "public"."quiz_questions" to "authenticated";

grant references on table "public"."quiz_questions" to "authenticated";

grant select on table "public"."quiz_questions" to "authenticated";

grant trigger on table "public"."quiz_questions" to "authenticated";

grant truncate on table "public"."quiz_questions" to "authenticated";

grant update on table "public"."quiz_questions" to "authenticated";

grant delete on table "public"."quiz_questions" to "service_role";

grant insert on table "public"."quiz_questions" to "service_role";

grant references on table "public"."quiz_questions" to "service_role";

grant select on table "public"."quiz_questions" to "service_role";

grant trigger on table "public"."quiz_questions" to "service_role";

grant truncate on table "public"."quiz_questions" to "service_role";

grant update on table "public"."quiz_questions" to "service_role";

grant delete on table "public"."recommendation_clicks" to "anon";

grant insert on table "public"."recommendation_clicks" to "anon";

grant references on table "public"."recommendation_clicks" to "anon";

grant select on table "public"."recommendation_clicks" to "anon";

grant trigger on table "public"."recommendation_clicks" to "anon";

grant truncate on table "public"."recommendation_clicks" to "anon";

grant update on table "public"."recommendation_clicks" to "anon";

grant delete on table "public"."recommendation_clicks" to "authenticated";

grant insert on table "public"."recommendation_clicks" to "authenticated";

grant references on table "public"."recommendation_clicks" to "authenticated";

grant select on table "public"."recommendation_clicks" to "authenticated";

grant trigger on table "public"."recommendation_clicks" to "authenticated";

grant truncate on table "public"."recommendation_clicks" to "authenticated";

grant update on table "public"."recommendation_clicks" to "authenticated";

grant delete on table "public"."recommendation_clicks" to "service_role";

grant insert on table "public"."recommendation_clicks" to "service_role";

grant references on table "public"."recommendation_clicks" to "service_role";

grant select on table "public"."recommendation_clicks" to "service_role";

grant trigger on table "public"."recommendation_clicks" to "service_role";

grant truncate on table "public"."recommendation_clicks" to "service_role";

grant update on table "public"."recommendation_clicks" to "service_role";

grant delete on table "public"."recommendation_feedback" to "anon";

grant insert on table "public"."recommendation_feedback" to "anon";

grant references on table "public"."recommendation_feedback" to "anon";

grant select on table "public"."recommendation_feedback" to "anon";

grant trigger on table "public"."recommendation_feedback" to "anon";

grant truncate on table "public"."recommendation_feedback" to "anon";

grant update on table "public"."recommendation_feedback" to "anon";

grant delete on table "public"."recommendation_feedback" to "authenticated";

grant insert on table "public"."recommendation_feedback" to "authenticated";

grant references on table "public"."recommendation_feedback" to "authenticated";

grant select on table "public"."recommendation_feedback" to "authenticated";

grant trigger on table "public"."recommendation_feedback" to "authenticated";

grant truncate on table "public"."recommendation_feedback" to "authenticated";

grant update on table "public"."recommendation_feedback" to "authenticated";

grant delete on table "public"."recommendation_feedback" to "service_role";

grant insert on table "public"."recommendation_feedback" to "service_role";

grant references on table "public"."recommendation_feedback" to "service_role";

grant select on table "public"."recommendation_feedback" to "service_role";

grant trigger on table "public"."recommendation_feedback" to "service_role";

grant truncate on table "public"."recommendation_feedback" to "service_role";

grant update on table "public"."recommendation_feedback" to "service_role";

grant delete on table "public"."recommendation_impressions" to "anon";

grant insert on table "public"."recommendation_impressions" to "anon";

grant references on table "public"."recommendation_impressions" to "anon";

grant select on table "public"."recommendation_impressions" to "anon";

grant trigger on table "public"."recommendation_impressions" to "anon";

grant truncate on table "public"."recommendation_impressions" to "anon";

grant update on table "public"."recommendation_impressions" to "anon";

grant delete on table "public"."recommendation_impressions" to "authenticated";

grant insert on table "public"."recommendation_impressions" to "authenticated";

grant references on table "public"."recommendation_impressions" to "authenticated";

grant select on table "public"."recommendation_impressions" to "authenticated";

grant trigger on table "public"."recommendation_impressions" to "authenticated";

grant truncate on table "public"."recommendation_impressions" to "authenticated";

grant update on table "public"."recommendation_impressions" to "authenticated";

grant delete on table "public"."recommendation_impressions" to "service_role";

grant insert on table "public"."recommendation_impressions" to "service_role";

grant references on table "public"."recommendation_impressions" to "service_role";

grant select on table "public"."recommendation_impressions" to "service_role";

grant trigger on table "public"."recommendation_impressions" to "service_role";

grant truncate on table "public"."recommendation_impressions" to "service_role";

grant update on table "public"."recommendation_impressions" to "service_role";

grant delete on table "public"."recommendation_letters" to "anon";

grant insert on table "public"."recommendation_letters" to "anon";

grant references on table "public"."recommendation_letters" to "anon";

grant select on table "public"."recommendation_letters" to "anon";

grant trigger on table "public"."recommendation_letters" to "anon";

grant truncate on table "public"."recommendation_letters" to "anon";

grant update on table "public"."recommendation_letters" to "anon";

grant delete on table "public"."recommendation_letters" to "authenticated";

grant insert on table "public"."recommendation_letters" to "authenticated";

grant references on table "public"."recommendation_letters" to "authenticated";

grant select on table "public"."recommendation_letters" to "authenticated";

grant trigger on table "public"."recommendation_letters" to "authenticated";

grant truncate on table "public"."recommendation_letters" to "authenticated";

grant update on table "public"."recommendation_letters" to "authenticated";

grant delete on table "public"."recommendation_letters" to "service_role";

grant insert on table "public"."recommendation_letters" to "service_role";

grant references on table "public"."recommendation_letters" to "service_role";

grant select on table "public"."recommendation_letters" to "service_role";

grant trigger on table "public"."recommendation_letters" to "service_role";

grant truncate on table "public"."recommendation_letters" to "service_role";

grant update on table "public"."recommendation_letters" to "service_role";

grant delete on table "public"."recommendation_reminders" to "anon";

grant insert on table "public"."recommendation_reminders" to "anon";

grant references on table "public"."recommendation_reminders" to "anon";

grant select on table "public"."recommendation_reminders" to "anon";

grant trigger on table "public"."recommendation_reminders" to "anon";

grant truncate on table "public"."recommendation_reminders" to "anon";

grant update on table "public"."recommendation_reminders" to "anon";

grant delete on table "public"."recommendation_reminders" to "authenticated";

grant insert on table "public"."recommendation_reminders" to "authenticated";

grant references on table "public"."recommendation_reminders" to "authenticated";

grant select on table "public"."recommendation_reminders" to "authenticated";

grant trigger on table "public"."recommendation_reminders" to "authenticated";

grant truncate on table "public"."recommendation_reminders" to "authenticated";

grant update on table "public"."recommendation_reminders" to "authenticated";

grant delete on table "public"."recommendation_reminders" to "service_role";

grant insert on table "public"."recommendation_reminders" to "service_role";

grant references on table "public"."recommendation_reminders" to "service_role";

grant select on table "public"."recommendation_reminders" to "service_role";

grant trigger on table "public"."recommendation_reminders" to "service_role";

grant truncate on table "public"."recommendation_reminders" to "service_role";

grant update on table "public"."recommendation_reminders" to "service_role";

grant delete on table "public"."recommendation_requests" to "anon";

grant insert on table "public"."recommendation_requests" to "anon";

grant references on table "public"."recommendation_requests" to "anon";

grant select on table "public"."recommendation_requests" to "anon";

grant trigger on table "public"."recommendation_requests" to "anon";

grant truncate on table "public"."recommendation_requests" to "anon";

grant update on table "public"."recommendation_requests" to "anon";

grant delete on table "public"."recommendation_requests" to "authenticated";

grant insert on table "public"."recommendation_requests" to "authenticated";

grant references on table "public"."recommendation_requests" to "authenticated";

grant select on table "public"."recommendation_requests" to "authenticated";

grant trigger on table "public"."recommendation_requests" to "authenticated";

grant truncate on table "public"."recommendation_requests" to "authenticated";

grant update on table "public"."recommendation_requests" to "authenticated";

grant delete on table "public"."recommendation_requests" to "service_role";

grant insert on table "public"."recommendation_requests" to "service_role";

grant references on table "public"."recommendation_requests" to "service_role";

grant select on table "public"."recommendation_requests" to "service_role";

grant trigger on table "public"."recommendation_requests" to "service_role";

grant truncate on table "public"."recommendation_requests" to "service_role";

grant update on table "public"."recommendation_requests" to "service_role";

grant delete on table "public"."recommendation_templates" to "anon";

grant insert on table "public"."recommendation_templates" to "anon";

grant references on table "public"."recommendation_templates" to "anon";

grant select on table "public"."recommendation_templates" to "anon";

grant trigger on table "public"."recommendation_templates" to "anon";

grant truncate on table "public"."recommendation_templates" to "anon";

grant update on table "public"."recommendation_templates" to "anon";

grant delete on table "public"."recommendation_templates" to "authenticated";

grant insert on table "public"."recommendation_templates" to "authenticated";

grant references on table "public"."recommendation_templates" to "authenticated";

grant select on table "public"."recommendation_templates" to "authenticated";

grant trigger on table "public"."recommendation_templates" to "authenticated";

grant truncate on table "public"."recommendation_templates" to "authenticated";

grant update on table "public"."recommendation_templates" to "authenticated";

grant delete on table "public"."recommendation_templates" to "service_role";

grant insert on table "public"."recommendation_templates" to "service_role";

grant references on table "public"."recommendation_templates" to "service_role";

grant select on table "public"."recommendation_templates" to "service_role";

grant trigger on table "public"."recommendation_templates" to "service_role";

grant truncate on table "public"."recommendation_templates" to "service_role";

grant update on table "public"."recommendation_templates" to "service_role";

grant delete on table "public"."recommendations" to "anon";

grant insert on table "public"."recommendations" to "anon";

grant references on table "public"."recommendations" to "anon";

grant select on table "public"."recommendations" to "anon";

grant trigger on table "public"."recommendations" to "anon";

grant truncate on table "public"."recommendations" to "anon";

grant update on table "public"."recommendations" to "anon";

grant delete on table "public"."recommendations" to "authenticated";

grant insert on table "public"."recommendations" to "authenticated";

grant references on table "public"."recommendations" to "authenticated";

grant select on table "public"."recommendations" to "authenticated";

grant trigger on table "public"."recommendations" to "authenticated";

grant truncate on table "public"."recommendations" to "authenticated";

grant update on table "public"."recommendations" to "authenticated";

grant delete on table "public"."recommendations" to "service_role";

grant insert on table "public"."recommendations" to "service_role";

grant references on table "public"."recommendations" to "service_role";

grant select on table "public"."recommendations" to "service_role";

grant trigger on table "public"."recommendations" to "service_role";

grant truncate on table "public"."recommendations" to "service_role";

grant update on table "public"."recommendations" to "service_role";

grant delete on table "public"."scheduled_report_executions" to "anon";

grant insert on table "public"."scheduled_report_executions" to "anon";

grant references on table "public"."scheduled_report_executions" to "anon";

grant select on table "public"."scheduled_report_executions" to "anon";

grant trigger on table "public"."scheduled_report_executions" to "anon";

grant truncate on table "public"."scheduled_report_executions" to "anon";

grant update on table "public"."scheduled_report_executions" to "anon";

grant delete on table "public"."scheduled_report_executions" to "authenticated";

grant insert on table "public"."scheduled_report_executions" to "authenticated";

grant references on table "public"."scheduled_report_executions" to "authenticated";

grant select on table "public"."scheduled_report_executions" to "authenticated";

grant trigger on table "public"."scheduled_report_executions" to "authenticated";

grant truncate on table "public"."scheduled_report_executions" to "authenticated";

grant update on table "public"."scheduled_report_executions" to "authenticated";

grant delete on table "public"."scheduled_report_executions" to "service_role";

grant insert on table "public"."scheduled_report_executions" to "service_role";

grant references on table "public"."scheduled_report_executions" to "service_role";

grant select on table "public"."scheduled_report_executions" to "service_role";

grant trigger on table "public"."scheduled_report_executions" to "service_role";

grant truncate on table "public"."scheduled_report_executions" to "service_role";

grant update on table "public"."scheduled_report_executions" to "service_role";

grant delete on table "public"."scheduled_reports" to "anon";

grant insert on table "public"."scheduled_reports" to "anon";

grant references on table "public"."scheduled_reports" to "anon";

grant select on table "public"."scheduled_reports" to "anon";

grant trigger on table "public"."scheduled_reports" to "anon";

grant truncate on table "public"."scheduled_reports" to "anon";

grant update on table "public"."scheduled_reports" to "anon";

grant delete on table "public"."scheduled_reports" to "authenticated";

grant insert on table "public"."scheduled_reports" to "authenticated";

grant references on table "public"."scheduled_reports" to "authenticated";

grant select on table "public"."scheduled_reports" to "authenticated";

grant trigger on table "public"."scheduled_reports" to "authenticated";

grant truncate on table "public"."scheduled_reports" to "authenticated";

grant update on table "public"."scheduled_reports" to "authenticated";

grant delete on table "public"."scheduled_reports" to "service_role";

grant insert on table "public"."scheduled_reports" to "service_role";

grant references on table "public"."scheduled_reports" to "service_role";

grant select on table "public"."scheduled_reports" to "service_role";

grant trigger on table "public"."scheduled_reports" to "service_role";

grant truncate on table "public"."scheduled_reports" to "service_role";

grant update on table "public"."scheduled_reports" to "service_role";

grant delete on table "public"."staff_availability" to "anon";

grant insert on table "public"."staff_availability" to "anon";

grant references on table "public"."staff_availability" to "anon";

grant select on table "public"."staff_availability" to "anon";

grant trigger on table "public"."staff_availability" to "anon";

grant truncate on table "public"."staff_availability" to "anon";

grant update on table "public"."staff_availability" to "anon";

grant delete on table "public"."staff_availability" to "authenticated";

grant insert on table "public"."staff_availability" to "authenticated";

grant references on table "public"."staff_availability" to "authenticated";

grant select on table "public"."staff_availability" to "authenticated";

grant trigger on table "public"."staff_availability" to "authenticated";

grant truncate on table "public"."staff_availability" to "authenticated";

grant update on table "public"."staff_availability" to "authenticated";

grant delete on table "public"."staff_availability" to "service_role";

grant insert on table "public"."staff_availability" to "service_role";

grant references on table "public"."staff_availability" to "service_role";

grant select on table "public"."staff_availability" to "service_role";

grant trigger on table "public"."staff_availability" to "service_role";

grant truncate on table "public"."staff_availability" to "service_role";

grant update on table "public"."staff_availability" to "service_role";

grant delete on table "public"."student_activities" to "anon";

grant insert on table "public"."student_activities" to "anon";

grant references on table "public"."student_activities" to "anon";

grant select on table "public"."student_activities" to "anon";

grant trigger on table "public"."student_activities" to "anon";

grant truncate on table "public"."student_activities" to "anon";

grant update on table "public"."student_activities" to "anon";

grant delete on table "public"."student_activities" to "authenticated";

grant insert on table "public"."student_activities" to "authenticated";

grant references on table "public"."student_activities" to "authenticated";

grant select on table "public"."student_activities" to "authenticated";

grant trigger on table "public"."student_activities" to "authenticated";

grant truncate on table "public"."student_activities" to "authenticated";

grant update on table "public"."student_activities" to "authenticated";

grant delete on table "public"."student_activities" to "service_role";

grant insert on table "public"."student_activities" to "service_role";

grant references on table "public"."student_activities" to "service_role";

grant select on table "public"."student_activities" to "service_role";

grant trigger on table "public"."student_activities" to "service_role";

grant truncate on table "public"."student_activities" to "service_role";

grant update on table "public"."student_activities" to "service_role";

grant delete on table "public"."student_counselor_assignments" to "anon";

grant insert on table "public"."student_counselor_assignments" to "anon";

grant references on table "public"."student_counselor_assignments" to "anon";

grant select on table "public"."student_counselor_assignments" to "anon";

grant trigger on table "public"."student_counselor_assignments" to "anon";

grant truncate on table "public"."student_counselor_assignments" to "anon";

grant update on table "public"."student_counselor_assignments" to "anon";

grant delete on table "public"."student_counselor_assignments" to "authenticated";

grant insert on table "public"."student_counselor_assignments" to "authenticated";

grant references on table "public"."student_counselor_assignments" to "authenticated";

grant select on table "public"."student_counselor_assignments" to "authenticated";

grant trigger on table "public"."student_counselor_assignments" to "authenticated";

grant truncate on table "public"."student_counselor_assignments" to "authenticated";

grant update on table "public"."student_counselor_assignments" to "authenticated";

grant delete on table "public"."student_counselor_assignments" to "service_role";

grant insert on table "public"."student_counselor_assignments" to "service_role";

grant references on table "public"."student_counselor_assignments" to "service_role";

grant select on table "public"."student_counselor_assignments" to "service_role";

grant trigger on table "public"."student_counselor_assignments" to "service_role";

grant truncate on table "public"."student_counselor_assignments" to "service_role";

grant update on table "public"."student_counselor_assignments" to "service_role";

grant delete on table "public"."student_interaction_summary" to "anon";

grant insert on table "public"."student_interaction_summary" to "anon";

grant references on table "public"."student_interaction_summary" to "anon";

grant select on table "public"."student_interaction_summary" to "anon";

grant trigger on table "public"."student_interaction_summary" to "anon";

grant truncate on table "public"."student_interaction_summary" to "anon";

grant update on table "public"."student_interaction_summary" to "anon";

grant delete on table "public"."student_interaction_summary" to "authenticated";

grant insert on table "public"."student_interaction_summary" to "authenticated";

grant references on table "public"."student_interaction_summary" to "authenticated";

grant select on table "public"."student_interaction_summary" to "authenticated";

grant trigger on table "public"."student_interaction_summary" to "authenticated";

grant truncate on table "public"."student_interaction_summary" to "authenticated";

grant update on table "public"."student_interaction_summary" to "authenticated";

grant delete on table "public"."student_interaction_summary" to "service_role";

grant insert on table "public"."student_interaction_summary" to "service_role";

grant references on table "public"."student_interaction_summary" to "service_role";

grant select on table "public"."student_interaction_summary" to "service_role";

grant trigger on table "public"."student_interaction_summary" to "service_role";

grant truncate on table "public"."student_interaction_summary" to "service_role";

grant update on table "public"."student_interaction_summary" to "service_role";

grant delete on table "public"."student_invite_codes" to "anon";

grant insert on table "public"."student_invite_codes" to "anon";

grant references on table "public"."student_invite_codes" to "anon";

grant select on table "public"."student_invite_codes" to "anon";

grant trigger on table "public"."student_invite_codes" to "anon";

grant truncate on table "public"."student_invite_codes" to "anon";

grant update on table "public"."student_invite_codes" to "anon";

grant delete on table "public"."student_invite_codes" to "authenticated";

grant insert on table "public"."student_invite_codes" to "authenticated";

grant references on table "public"."student_invite_codes" to "authenticated";

grant select on table "public"."student_invite_codes" to "authenticated";

grant trigger on table "public"."student_invite_codes" to "authenticated";

grant truncate on table "public"."student_invite_codes" to "authenticated";

grant update on table "public"."student_invite_codes" to "authenticated";

grant delete on table "public"."student_invite_codes" to "service_role";

grant insert on table "public"."student_invite_codes" to "service_role";

grant references on table "public"."student_invite_codes" to "service_role";

grant select on table "public"."student_invite_codes" to "service_role";

grant trigger on table "public"."student_invite_codes" to "service_role";

grant truncate on table "public"."student_invite_codes" to "service_role";

grant update on table "public"."student_invite_codes" to "service_role";

grant delete on table "public"."student_profiles" to "anon";

grant insert on table "public"."student_profiles" to "anon";

grant references on table "public"."student_profiles" to "anon";

grant select on table "public"."student_profiles" to "anon";

grant trigger on table "public"."student_profiles" to "anon";

grant truncate on table "public"."student_profiles" to "anon";

grant update on table "public"."student_profiles" to "anon";

grant delete on table "public"."student_profiles" to "authenticated";

grant insert on table "public"."student_profiles" to "authenticated";

grant references on table "public"."student_profiles" to "authenticated";

grant select on table "public"."student_profiles" to "authenticated";

grant trigger on table "public"."student_profiles" to "authenticated";

grant truncate on table "public"."student_profiles" to "authenticated";

grant update on table "public"."student_profiles" to "authenticated";

grant delete on table "public"."student_profiles" to "service_role";

grant insert on table "public"."student_profiles" to "service_role";

grant references on table "public"."student_profiles" to "service_role";

grant select on table "public"."student_profiles" to "service_role";

grant trigger on table "public"."student_profiles" to "service_role";

grant truncate on table "public"."student_profiles" to "service_role";

grant update on table "public"."student_profiles" to "service_role";

grant delete on table "public"."student_records" to "anon";

grant insert on table "public"."student_records" to "anon";

grant references on table "public"."student_records" to "anon";

grant select on table "public"."student_records" to "anon";

grant trigger on table "public"."student_records" to "anon";

grant truncate on table "public"."student_records" to "anon";

grant update on table "public"."student_records" to "anon";

grant delete on table "public"."student_records" to "authenticated";

grant insert on table "public"."student_records" to "authenticated";

grant references on table "public"."student_records" to "authenticated";

grant select on table "public"."student_records" to "authenticated";

grant trigger on table "public"."student_records" to "authenticated";

grant truncate on table "public"."student_records" to "authenticated";

grant update on table "public"."student_records" to "authenticated";

grant delete on table "public"."student_records" to "service_role";

grant insert on table "public"."student_records" to "service_role";

grant references on table "public"."student_records" to "service_role";

grant select on table "public"."student_records" to "service_role";

grant trigger on table "public"."student_records" to "service_role";

grant truncate on table "public"."student_records" to "service_role";

grant update on table "public"."student_records" to "service_role";

grant delete on table "public"."support_tickets" to "anon";

grant insert on table "public"."support_tickets" to "anon";

grant references on table "public"."support_tickets" to "anon";

grant select on table "public"."support_tickets" to "anon";

grant trigger on table "public"."support_tickets" to "anon";

grant truncate on table "public"."support_tickets" to "anon";

grant update on table "public"."support_tickets" to "anon";

grant delete on table "public"."support_tickets" to "authenticated";

grant insert on table "public"."support_tickets" to "authenticated";

grant references on table "public"."support_tickets" to "authenticated";

grant select on table "public"."support_tickets" to "authenticated";

grant trigger on table "public"."support_tickets" to "authenticated";

grant truncate on table "public"."support_tickets" to "authenticated";

grant update on table "public"."support_tickets" to "authenticated";

grant delete on table "public"."support_tickets" to "service_role";

grant insert on table "public"."support_tickets" to "service_role";

grant references on table "public"."support_tickets" to "service_role";

grant select on table "public"."support_tickets" to "service_role";

grant trigger on table "public"."support_tickets" to "service_role";

grant truncate on table "public"."support_tickets" to "service_role";

grant update on table "public"."support_tickets" to "service_role";

grant delete on table "public"."system_logs" to "anon";

grant insert on table "public"."system_logs" to "anon";

grant references on table "public"."system_logs" to "anon";

grant select on table "public"."system_logs" to "anon";

grant trigger on table "public"."system_logs" to "anon";

grant truncate on table "public"."system_logs" to "anon";

grant update on table "public"."system_logs" to "anon";

grant delete on table "public"."system_logs" to "authenticated";

grant insert on table "public"."system_logs" to "authenticated";

grant references on table "public"."system_logs" to "authenticated";

grant select on table "public"."system_logs" to "authenticated";

grant trigger on table "public"."system_logs" to "authenticated";

grant truncate on table "public"."system_logs" to "authenticated";

grant update on table "public"."system_logs" to "authenticated";

grant delete on table "public"."system_logs" to "service_role";

grant insert on table "public"."system_logs" to "service_role";

grant references on table "public"."system_logs" to "service_role";

grant select on table "public"."system_logs" to "service_role";

grant trigger on table "public"."system_logs" to "service_role";

grant truncate on table "public"."system_logs" to "service_role";

grant update on table "public"."system_logs" to "service_role";

grant delete on table "public"."transactions" to "anon";

grant insert on table "public"."transactions" to "anon";

grant references on table "public"."transactions" to "anon";

grant select on table "public"."transactions" to "anon";

grant trigger on table "public"."transactions" to "anon";

grant truncate on table "public"."transactions" to "anon";

grant update on table "public"."transactions" to "anon";

grant delete on table "public"."transactions" to "authenticated";

grant insert on table "public"."transactions" to "authenticated";

grant references on table "public"."transactions" to "authenticated";

grant select on table "public"."transactions" to "authenticated";

grant trigger on table "public"."transactions" to "authenticated";

grant truncate on table "public"."transactions" to "authenticated";

grant update on table "public"."transactions" to "authenticated";

grant delete on table "public"."transactions" to "service_role";

grant insert on table "public"."transactions" to "service_role";

grant references on table "public"."transactions" to "service_role";

grant select on table "public"."transactions" to "service_role";

grant trigger on table "public"."transactions" to "service_role";

grant truncate on table "public"."transactions" to "service_role";

grant update on table "public"."transactions" to "service_role";

grant delete on table "public"."typing_indicators" to "anon";

grant insert on table "public"."typing_indicators" to "anon";

grant references on table "public"."typing_indicators" to "anon";

grant select on table "public"."typing_indicators" to "anon";

grant trigger on table "public"."typing_indicators" to "anon";

grant truncate on table "public"."typing_indicators" to "anon";

grant update on table "public"."typing_indicators" to "anon";

grant delete on table "public"."typing_indicators" to "authenticated";

grant insert on table "public"."typing_indicators" to "authenticated";

grant references on table "public"."typing_indicators" to "authenticated";

grant select on table "public"."typing_indicators" to "authenticated";

grant trigger on table "public"."typing_indicators" to "authenticated";

grant truncate on table "public"."typing_indicators" to "authenticated";

grant update on table "public"."typing_indicators" to "authenticated";

grant delete on table "public"."typing_indicators" to "service_role";

grant insert on table "public"."typing_indicators" to "service_role";

grant references on table "public"."typing_indicators" to "service_role";

grant select on table "public"."typing_indicators" to "service_role";

grant trigger on table "public"."typing_indicators" to "service_role";

grant truncate on table "public"."typing_indicators" to "service_role";

grant update on table "public"."typing_indicators" to "service_role";

grant delete on table "public"."universities" to "anon";

grant insert on table "public"."universities" to "anon";

grant references on table "public"."universities" to "anon";

grant select on table "public"."universities" to "anon";

grant trigger on table "public"."universities" to "anon";

grant truncate on table "public"."universities" to "anon";

grant update on table "public"."universities" to "anon";

grant delete on table "public"."universities" to "authenticated";

grant insert on table "public"."universities" to "authenticated";

grant references on table "public"."universities" to "authenticated";

grant select on table "public"."universities" to "authenticated";

grant trigger on table "public"."universities" to "authenticated";

grant truncate on table "public"."universities" to "authenticated";

grant update on table "public"."universities" to "authenticated";

grant delete on table "public"."universities" to "service_role";

grant insert on table "public"."universities" to "service_role";

grant references on table "public"."universities" to "service_role";

grant select on table "public"."universities" to "service_role";

grant trigger on table "public"."universities" to "service_role";

grant truncate on table "public"."universities" to "service_role";

grant update on table "public"."universities" to "service_role";

grant delete on table "public"."users" to "anon";

grant insert on table "public"."users" to "anon";

grant references on table "public"."users" to "anon";

grant select on table "public"."users" to "anon";

grant trigger on table "public"."users" to "anon";

grant truncate on table "public"."users" to "anon";

grant update on table "public"."users" to "anon";

grant delete on table "public"."users" to "authenticated";

grant insert on table "public"."users" to "authenticated";

grant references on table "public"."users" to "authenticated";

grant select on table "public"."users" to "authenticated";

grant trigger on table "public"."users" to "authenticated";

grant truncate on table "public"."users" to "authenticated";

grant update on table "public"."users" to "authenticated";

grant delete on table "public"."users" to "service_role";

grant insert on table "public"."users" to "service_role";

grant references on table "public"."users" to "service_role";

grant select on table "public"."users" to "service_role";

grant trigger on table "public"."users" to "service_role";

grant truncate on table "public"."users" to "service_role";

grant update on table "public"."users" to "service_role";


  create policy "Service role can manage achievements"
  on "public"."achievements"
  as permissive
  for all
  to service_role
using (true)
with check (true);



  create policy "Students can view own achievements"
  on "public"."achievements"
  as permissive
  for select
  to authenticated
using ((student_id = auth.uid()));



  create policy "System can insert achievements"
  on "public"."achievements"
  as permissive
  for insert
  to authenticated
with check (true);



  create policy "Admins full access to activity log"
  on "public"."activity_log"
  as permissive
  for all
  to public
using ((EXISTS ( SELECT 1
   FROM public.users
  WHERE ((users.id = auth.uid()) AND (users.active_role = ANY (ARRAY['superadmin'::text, 'analyticsadmin'::text, 'admin'::text]))))));



  create policy "Allow admin reads from activity_log"
  on "public"."activity_log"
  as permissive
  for select
  to authenticated
using (true);



  create policy "Allow all inserts to activity_log"
  on "public"."activity_log"
  as permissive
  for insert
  to public
with check (true);



  create policy "Service role can insert activity"
  on "public"."activity_log"
  as permissive
  for insert
  to public
with check (true);



  create policy "Users can view own activity"
  on "public"."activity_log"
  as permissive
  for select
  to public
using ((user_id = auth.uid()));



  create policy "Admins can update all applications"
  on "public"."applications"
  as permissive
  for update
  to authenticated
using ((EXISTS ( SELECT 1
   FROM public.users
  WHERE (((users.id)::text = (auth.uid())::text) AND ((users.active_role = 'admin_super'::text) OR (users.active_role = 'admin_content'::text) OR ('admin_super'::text = ANY (users.available_roles)))))))
with check ((EXISTS ( SELECT 1
   FROM public.users
  WHERE (((users.id)::text = (auth.uid())::text) AND ((users.active_role = 'admin_super'::text) OR (users.active_role = 'admin_content'::text) OR ('admin_super'::text = ANY (users.available_roles)))))));



  create policy "Admins can view all applications"
  on "public"."applications"
  as permissive
  for select
  to authenticated
using ((EXISTS ( SELECT 1
   FROM public.users
  WHERE (((users.id)::text = (auth.uid())::text) AND ((users.active_role = 'admin_super'::text) OR (users.active_role = 'admin_content'::text) OR ('admin_super'::text = ANY (users.available_roles)))))));



  create policy "Institutions can update their applications"
  on "public"."applications"
  as permissive
  for update
  to authenticated
using (((auth.uid())::text = (institution_id)::text))
with check (((auth.uid())::text = (institution_id)::text));



  create policy "Institutions can view their applications"
  on "public"."applications"
  as permissive
  for select
  to authenticated
using (((auth.uid())::text = (institution_id)::text));



  create policy "Students can create applications"
  on "public"."applications"
  as permissive
  for insert
  to public
with check ((student_id = auth.uid()));



  create policy "Students can create their own applications"
  on "public"."applications"
  as permissive
  for insert
  to authenticated
with check (((auth.uid())::text = (student_id)::text));



  create policy "Students can delete their draft applications"
  on "public"."applications"
  as permissive
  for delete
  to authenticated
using ((((auth.uid())::text = (student_id)::text) AND (is_submitted = false)));



  create policy "Students can update their draft applications"
  on "public"."applications"
  as permissive
  for update
  to authenticated
using ((((auth.uid())::text = (student_id)::text) AND (is_submitted = false)))
with check (((auth.uid())::text = (student_id)::text));



  create policy "Students can view own applications"
  on "public"."applications"
  as permissive
  for select
  to public
using ((student_id = auth.uid()));



  create policy "Students can view their own applications"
  on "public"."applications"
  as permissive
  for select
  to authenticated
using (((auth.uid())::text = (student_id)::text));



  create policy "assignment_submissions_institution_manage"
  on "public"."assignment_submissions"
  as permissive
  for all
  to public
using ((EXISTS ( SELECT 1
   FROM (((public.lesson_assignments la
     JOIN public.course_lessons cl ON ((la.lesson_id = cl.id)))
     JOIN public.course_modules cm ON ((cl.module_id = cm.id)))
     JOIN public.courses c ON ((cm.course_id = c.id)))
  WHERE ((la.id = assignment_submissions.assignment_id) AND (c.institution_id = auth.uid())))));



  create policy "assignment_submissions_student_own"
  on "public"."assignment_submissions"
  as permissive
  for all
  to public
using ((user_id = auth.uid()));



  create policy "Admins can manage all conversations"
  on "public"."chatbot_conversations"
  as permissive
  for all
  to public
using ((EXISTS ( SELECT 1
   FROM public.users
  WHERE ((users.id = auth.uid()) AND (users.active_role = ANY (ARRAY['superadmin'::text, 'supportadmin'::text, 'admin'::text]))))));



  create policy "Users can create own conversations"
  on "public"."chatbot_conversations"
  as permissive
  for insert
  to public
with check (((user_id = auth.uid()) OR (user_id IS NULL)));



  create policy "Users can manage own conversations"
  on "public"."chatbot_conversations"
  as permissive
  for all
  to public
using ((user_id = auth.uid()));



  create policy "Users can update own conversations"
  on "public"."chatbot_conversations"
  as permissive
  for update
  to public
using ((user_id = auth.uid()));



  create policy "Users can view own conversations"
  on "public"."chatbot_conversations"
  as permissive
  for select
  to public
using ((user_id = auth.uid()));



  create policy "Admins can manage FAQs"
  on "public"."chatbot_faqs"
  as permissive
  for all
  to public
using ((EXISTS ( SELECT 1
   FROM public.users
  WHERE ((users.id = auth.uid()) AND (users.active_role = ANY (ARRAY['superadmin'::text, 'contentadmin'::text, 'admin'::text]))))));



  create policy "Everyone can read active FAQs"
  on "public"."chatbot_faqs"
  as permissive
  for select
  to public
using ((is_active = true));



  create policy "Admins can view analytics"
  on "public"."chatbot_feedback_analytics"
  as permissive
  for select
  to public
using ((EXISTS ( SELECT 1
   FROM public.users
  WHERE ((users.id = auth.uid()) AND (users.active_role = ANY (ARRAY['superadmin'::text, 'analyticsadmin'::text, 'admin'::text]))))));



  create policy "Admins can manage all messages"
  on "public"."chatbot_messages"
  as permissive
  for all
  to public
using ((EXISTS ( SELECT 1
   FROM public.users
  WHERE ((users.id = auth.uid()) AND (users.active_role = ANY (ARRAY['superadmin'::text, 'supportadmin'::text, 'admin'::text]))))));



  create policy "Users can create messages in own conversations"
  on "public"."chatbot_messages"
  as permissive
  for insert
  to public
with check ((EXISTS ( SELECT 1
   FROM public.chatbot_conversations
  WHERE ((chatbot_conversations.id = chatbot_messages.conversation_id) AND ((chatbot_conversations.user_id = auth.uid()) OR (chatbot_conversations.user_id IS NULL))))));



  create policy "Users can update feedback on messages"
  on "public"."chatbot_messages"
  as permissive
  for update
  to public
using ((EXISTS ( SELECT 1
   FROM public.chatbot_conversations
  WHERE ((chatbot_conversations.id = chatbot_messages.conversation_id) AND (chatbot_conversations.user_id = auth.uid())))));



  create policy "Users can view messages in own conversations"
  on "public"."chatbot_messages"
  as permissive
  for select
  to public
using ((EXISTS ( SELECT 1
   FROM public.chatbot_conversations
  WHERE ((chatbot_conversations.id = chatbot_messages.conversation_id) AND (chatbot_conversations.user_id = auth.uid())))));



  create policy "Service role full access"
  on "public"."chatbot_support_queue"
  as permissive
  for all
  to public
using (true)
with check (true);



  create policy "Users can escalate own conversations"
  on "public"."chatbot_support_queue"
  as permissive
  for insert
  to public
with check ((EXISTS ( SELECT 1
   FROM public.chatbot_conversations
  WHERE ((chatbot_conversations.id = chatbot_support_queue.conversation_id) AND (chatbot_conversations.user_id = auth.uid())))));



  create policy "Parents can manage own children"
  on "public"."children"
  as permissive
  for all
  to public
using ((parent_id = auth.uid()));



  create policy "Parents can view own children"
  on "public"."children"
  as permissive
  for select
  to public
using ((parent_id = auth.uid()));



  create policy "Admins full access to campaigns"
  on "public"."communication_campaigns"
  as permissive
  for all
  to public
using ((EXISTS ( SELECT 1
   FROM public.users
  WHERE ((users.id = auth.uid()) AND (users.active_role = ANY (ARRAY['superadmin'::text, 'contentadmin'::text, 'admin'::text]))))));



  create policy "Admins can manage all assignments"
  on "public"."content_assignments"
  as permissive
  for all
  to public
using ((EXISTS ( SELECT 1
   FROM public.users
  WHERE ((users.id = auth.uid()) AND (users.active_role = ANY (ARRAY['superadmin'::text, 'admin'::text, 'contentadmin'::text]))))));



  create policy "Users can update their assignment progress"
  on "public"."content_assignments"
  as permissive
  for update
  to public
using ((target_id = auth.uid()))
with check ((target_id = auth.uid()));



  create policy "Users can view their assignments"
  on "public"."content_assignments"
  as permissive
  for select
  to public
using (((target_id = auth.uid()) OR ((target_type)::text = 'all_students'::text)));



  create policy "Service role conversations"
  on "public"."conversations"
  as permissive
  for all
  to service_role
using (true)
with check (true);



  create policy "Users can create conversations they participate in"
  on "public"."conversations"
  as permissive
  for insert
  to authenticated
with check ((auth.uid() = ANY (participant_ids)));



  create policy "Users can update their own conversations"
  on "public"."conversations"
  as permissive
  for update
  to authenticated
using ((auth.uid() = ANY (participant_ids)));



  create policy "Users can view their own conversations"
  on "public"."conversations"
  as permissive
  for select
  to authenticated
using ((auth.uid() = ANY (participant_ids)));



  create policy "Users create conversations"
  on "public"."conversations"
  as permissive
  for insert
  to public
with check ((auth.uid() = ANY (participant_ids)));



  create policy "Users view own conversations"
  on "public"."conversations"
  as permissive
  for select
  to public
using ((auth.uid() = ANY (participant_ids)));



  create policy "Admin can view all consents"
  on "public"."cookie_consents"
  as permissive
  for select
  to public
using ((EXISTS ( SELECT 1
   FROM public.admin_users
  WHERE (admin_users.id = auth.uid()))));



  create policy "Anyone can insert consent"
  on "public"."cookie_consents"
  as permissive
  for insert
  to authenticated
with check (true);



  create policy "Users can update consent"
  on "public"."cookie_consents"
  as permissive
  for update
  to authenticated
using (true)
with check (true);



  create policy "Users can view own consent"
  on "public"."cookie_consents"
  as permissive
  for select
  to public
using ((user_id = auth.uid()));



  create policy "course_lessons_institution_manage"
  on "public"."course_lessons"
  as permissive
  for all
  to public
using ((EXISTS ( SELECT 1
   FROM (public.course_modules cm
     JOIN public.courses c ON ((cm.course_id = c.id)))
  WHERE ((cm.id = course_lessons.module_id) AND (c.institution_id = auth.uid())))));



  create policy "course_lessons_student_view"
  on "public"."course_lessons"
  as permissive
  for select
  to public
using (((is_published = true) AND (EXISTS ( SELECT 1
   FROM ((public.course_modules cm
     JOIN public.courses c ON ((cm.course_id = c.id)))
     JOIN public.enrollments e ON ((e.course_id = c.id)))
  WHERE ((cm.id = course_lessons.module_id) AND (e.student_id = auth.uid()) AND ((e.status)::text = 'active'::text))))));



  create policy "course_modules_institution_manage"
  on "public"."course_modules"
  as permissive
  for all
  to public
using ((EXISTS ( SELECT 1
   FROM public.courses
  WHERE ((courses.id = course_modules.course_id) AND (courses.institution_id = auth.uid())))));



  create policy "course_modules_student_view"
  on "public"."course_modules"
  as permissive
  for select
  to public
using (((is_published = true) AND (EXISTS ( SELECT 1
   FROM public.enrollments
  WHERE ((enrollments.course_id = course_modules.course_id) AND (enrollments.student_id = auth.uid()) AND ((enrollments.status)::text = 'active'::text))))));



  create policy "Allow all operations on courses"
  on "public"."courses"
  as permissive
  for all
  to public
using (true)
with check (true);



  create policy "Users can upload documents"
  on "public"."documents"
  as permissive
  for insert
  to public
with check ((uploaded_by = auth.uid()));



  create policy "Users can view own documents"
  on "public"."documents"
  as permissive
  for select
  to public
using ((uploaded_by = auth.uid()));



  create policy "Allow all operations on enrollment_permissions"
  on "public"."enrollment_permissions"
  as permissive
  for all
  to public
using (true)
with check (true);



  create policy "Allow all operations on enrollments"
  on "public"."enrollments"
  as permissive
  for all
  to public
using (true)
with check (true);



  create policy "Parents can view children GPA history"
  on "public"."gpa_history"
  as permissive
  for select
  to public
using ((EXISTS ( SELECT 1
   FROM public.parent_children
  WHERE ((parent_children.parent_id = auth.uid()) AND (parent_children.child_id = gpa_history.student_id) AND (parent_children.can_view_grades = true)))));



  create policy "Students can view own GPA history"
  on "public"."gpa_history"
  as permissive
  for select
  to public
using ((auth.uid() = student_id));



  create policy "Parents can view own alerts"
  on "public"."grade_alerts"
  as permissive
  for select
  to public
using ((auth.uid() = parent_id));



  create policy "Service role can insert alerts"
  on "public"."grade_alerts"
  as permissive
  for insert
  to public
with check (true);



  create policy "Parents can view children grades"
  on "public"."grades"
  as permissive
  for select
  to public
using ((EXISTS ( SELECT 1
   FROM public.parent_children
  WHERE ((parent_children.parent_id = auth.uid()) AND (parent_children.child_id = grades.student_id) AND (parent_children.can_view_grades = true)))));



  create policy "Students can view own grades"
  on "public"."grades"
  as permissive
  for select
  to public
using ((auth.uid() = student_id));



  create policy "Anyone can view active programs"
  on "public"."institution_programs"
  as permissive
  for select
  to public
using ((is_active = true));



  create policy "Institutions can manage own programs"
  on "public"."institution_programs"
  as permissive
  for all
  to public
using ((institution_id = auth.uid()));



  create policy "lesson_assignments_institution_manage"
  on "public"."lesson_assignments"
  as permissive
  for all
  to public
using ((EXISTS ( SELECT 1
   FROM ((public.course_lessons cl
     JOIN public.course_modules cm ON ((cl.module_id = cm.id)))
     JOIN public.courses c ON ((cm.course_id = c.id)))
  WHERE ((cl.id = lesson_assignments.lesson_id) AND (c.institution_id = auth.uid())))));



  create policy "lesson_assignments_student_view"
  on "public"."lesson_assignments"
  as permissive
  for select
  to public
using ((EXISTS ( SELECT 1
   FROM (((public.course_lessons cl
     JOIN public.course_modules cm ON ((cl.module_id = cm.id)))
     JOIN public.courses c ON ((cm.course_id = c.id)))
     JOIN public.enrollments e ON ((e.course_id = c.id)))
  WHERE ((cl.id = lesson_assignments.lesson_id) AND (cl.is_published = true) AND (e.student_id = auth.uid()) AND ((e.status)::text = 'active'::text)))));



  create policy "lesson_completions_institution_view"
  on "public"."lesson_completions"
  as permissive
  for select
  to public
using ((EXISTS ( SELECT 1
   FROM ((public.course_lessons cl
     JOIN public.course_modules cm ON ((cl.module_id = cm.id)))
     JOIN public.courses c ON ((cm.course_id = c.id)))
  WHERE ((cl.id = lesson_completions.lesson_id) AND (c.institution_id = auth.uid())))));



  create policy "lesson_completions_student_own"
  on "public"."lesson_completions"
  as permissive
  for all
  to public
using ((user_id = auth.uid()));



  create policy "lesson_quizzes_institution_manage"
  on "public"."lesson_quizzes"
  as permissive
  for all
  to public
using ((EXISTS ( SELECT 1
   FROM ((public.course_lessons cl
     JOIN public.course_modules cm ON ((cl.module_id = cm.id)))
     JOIN public.courses c ON ((cm.course_id = c.id)))
  WHERE ((cl.id = lesson_quizzes.lesson_id) AND (c.institution_id = auth.uid())))));



  create policy "lesson_quizzes_student_view"
  on "public"."lesson_quizzes"
  as permissive
  for select
  to public
using ((EXISTS ( SELECT 1
   FROM (((public.course_lessons cl
     JOIN public.course_modules cm ON ((cl.module_id = cm.id)))
     JOIN public.courses c ON ((cm.course_id = c.id)))
     JOIN public.enrollments e ON ((e.course_id = c.id)))
  WHERE ((cl.id = lesson_quizzes.lesson_id) AND (cl.is_published = true) AND (e.student_id = auth.uid()) AND ((e.status)::text = 'active'::text)))));



  create policy "lesson_texts_institution_manage"
  on "public"."lesson_texts"
  as permissive
  for all
  to public
using ((EXISTS ( SELECT 1
   FROM ((public.course_lessons cl
     JOIN public.course_modules cm ON ((cl.module_id = cm.id)))
     JOIN public.courses c ON ((cm.course_id = c.id)))
  WHERE ((cl.id = lesson_texts.lesson_id) AND (c.institution_id = auth.uid())))));



  create policy "lesson_texts_student_view"
  on "public"."lesson_texts"
  as permissive
  for select
  to public
using ((EXISTS ( SELECT 1
   FROM (((public.course_lessons cl
     JOIN public.course_modules cm ON ((cl.module_id = cm.id)))
     JOIN public.courses c ON ((cm.course_id = c.id)))
     JOIN public.enrollments e ON ((e.course_id = c.id)))
  WHERE ((cl.id = lesson_texts.lesson_id) AND (cl.is_published = true) AND (e.student_id = auth.uid()) AND ((e.status)::text = 'active'::text)))));



  create policy "lesson_videos_institution_manage"
  on "public"."lesson_videos"
  as permissive
  for all
  to public
using ((EXISTS ( SELECT 1
   FROM ((public.course_lessons cl
     JOIN public.course_modules cm ON ((cl.module_id = cm.id)))
     JOIN public.courses c ON ((cm.course_id = c.id)))
  WHERE ((cl.id = lesson_videos.lesson_id) AND (c.institution_id = auth.uid())))));



  create policy "lesson_videos_student_view"
  on "public"."lesson_videos"
  as permissive
  for select
  to public
using ((EXISTS ( SELECT 1
   FROM (((public.course_lessons cl
     JOIN public.course_modules cm ON ((cl.module_id = cm.id)))
     JOIN public.courses c ON ((cm.course_id = c.id)))
     JOIN public.enrollments e ON ((e.course_id = c.id)))
  WHERE ((cl.id = lesson_videos.lesson_id) AND (cl.is_published = true) AND (e.student_id = auth.uid()) AND ((e.status)::text = 'active'::text)))));



  create policy "Recommenders can insert letters"
  on "public"."letter_of_recommendations"
  as permissive
  for insert
  to public
with check ((EXISTS ( SELECT 1
   FROM public.recommendation_requests
  WHERE ((recommendation_requests.id = letter_of_recommendations.request_id) AND (recommendation_requests.recommender_id = auth.uid())))));



  create policy "Recommenders can update their letters"
  on "public"."letter_of_recommendations"
  as permissive
  for update
  to public
using ((EXISTS ( SELECT 1
   FROM public.recommendation_requests
  WHERE ((recommendation_requests.id = letter_of_recommendations.request_id) AND (recommendation_requests.recommender_id = auth.uid())))));



  create policy "Recommenders can view their letters"
  on "public"."letter_of_recommendations"
  as permissive
  for select
  to public
using ((EXISTS ( SELECT 1
   FROM public.recommendation_requests
  WHERE ((recommendation_requests.id = letter_of_recommendations.request_id) AND (recommendation_requests.recommender_id = auth.uid())))));



  create policy "Students can view visible letters"
  on "public"."letter_of_recommendations"
  as permissive
  for select
  to public
using (((is_visible_to_student = true) AND (EXISTS ( SELECT 1
   FROM public.recommendation_requests
  WHERE ((recommendation_requests.id = letter_of_recommendations.request_id) AND (recommendation_requests.student_id = auth.uid()))))));



  create policy "meetings_admin_delete"
  on "public"."meetings"
  as permissive
  for delete
  to public
using ((auth.uid() IN ( SELECT users.id
   FROM public.users
  WHERE (users.active_role = 'admin'::text))));



  create policy "meetings_parent_insert"
  on "public"."meetings"
  as permissive
  for insert
  to public
with check (((auth.uid() = parent_id) AND (auth.uid() IN ( SELECT users.id
   FROM public.users
  WHERE (users.active_role = 'parent'::text)))));



  create policy "meetings_parent_select"
  on "public"."meetings"
  as permissive
  for select
  to public
using (((auth.uid() = parent_id) OR (auth.uid() IN ( SELECT users.id
   FROM public.users
  WHERE (users.active_role = 'admin'::text)))));



  create policy "meetings_parent_update"
  on "public"."meetings"
  as permissive
  for update
  to public
using ((auth.uid() = parent_id))
with check (((auth.uid() = parent_id) AND (status = ANY (ARRAY['pending'::text, 'approved'::text, 'cancelled'::text]))));



  create policy "meetings_staff_select"
  on "public"."meetings"
  as permissive
  for select
  to public
using (((auth.uid() = staff_id) OR (auth.uid() IN ( SELECT users.id
   FROM public.users
  WHERE (users.active_role = 'admin'::text)))));



  create policy "meetings_staff_update"
  on "public"."meetings"
  as permissive
  for update
  to public
using ((auth.uid() = staff_id))
with check (((auth.uid() = staff_id) AND (status = ANY (ARRAY['pending'::text, 'approved'::text, 'declined'::text, 'cancelled'::text, 'completed'::text]))));



  create policy "Anon can insert preferences with explicit user_id"
  on "public"."notification_preferences"
  as permissive
  for insert
  to anon
with check (true);



  create policy "Users can delete own preferences"
  on "public"."notification_preferences"
  as permissive
  for delete
  to public
using ((auth.uid() = user_id));



  create policy "Users can update own preferences"
  on "public"."notification_preferences"
  as permissive
  for update
  to public
using ((auth.uid() = user_id));



  create policy "Users can view own preferences"
  on "public"."notification_preferences"
  as permissive
  for select
  to public
using ((auth.uid() = user_id));



  create policy "Service role can insert notifications"
  on "public"."notifications"
  as permissive
  for insert
  to public
with check (true);



  create policy "Users can delete own notifications"
  on "public"."notifications"
  as permissive
  for delete
  to public
using ((auth.uid() = user_id));



  create policy "Users can update own notifications"
  on "public"."notifications"
  as permissive
  for update
  to public
using ((auth.uid() = user_id));



  create policy "Users can view own notifications"
  on "public"."notifications"
  as permissive
  for select
  to public
using ((auth.uid() = user_id));



  create policy "Admins can manage pages"
  on "public"."page_contents"
  as permissive
  for all
  to public
using ((auth.role() = 'authenticated'::text));



  create policy "Public can read published pages"
  on "public"."page_contents"
  as permissive
  for select
  to public
using (((status)::text = 'published'::text));



  create policy "Parents can view their children relationships"
  on "public"."parent_children"
  as permissive
  for select
  to public
using ((auth.uid() = parent_id));



  create policy "Students can view their parent relationships"
  on "public"."parent_children"
  as permissive
  for select
  to public
using ((auth.uid() = child_id));



  create policy "Parents can create links"
  on "public"."parent_student_links"
  as permissive
  for insert
  to public
with check ((auth.uid() = parent_id));



  create policy "Parents can view their links"
  on "public"."parent_student_links"
  as permissive
  for select
  to public
using ((auth.uid() = parent_id));



  create policy "Service role full access"
  on "public"."parent_student_links"
  as permissive
  for all
  to public
using (true);



  create policy "Students can view their links"
  on "public"."parent_student_links"
  as permissive
  for select
  to public
using ((auth.uid() = student_id));



  create policy "Users can delete their links"
  on "public"."parent_student_links"
  as permissive
  for delete
  to public
using (((auth.uid() = parent_id) OR (auth.uid() = student_id)));



  create policy "Users can update their links"
  on "public"."parent_student_links"
  as permissive
  for update
  to public
using (((auth.uid() = parent_id) OR (auth.uid() = student_id)));



  create policy "Users can view own payments"
  on "public"."payments"
  as permissive
  for select
  to public
using ((user_id = auth.uid()));



  create policy "Anyone can view active programs"
  on "public"."programs"
  as permissive
  for select
  to authenticated, anon
using ((is_active = true));



  create policy "Institutions can create their programs"
  on "public"."programs"
  as permissive
  for insert
  to authenticated
with check (((auth.uid())::text = (institution_id)::text));



  create policy "Institutions can delete their programs"
  on "public"."programs"
  as permissive
  for delete
  to authenticated
using (((auth.uid())::text = (institution_id)::text));



  create policy "Institutions can update their programs"
  on "public"."programs"
  as permissive
  for update
  to authenticated
using (((auth.uid())::text = (institution_id)::text))
with check (((auth.uid())::text = (institution_id)::text));



  create policy "quiz_attempts_institution_view"
  on "public"."quiz_attempts"
  as permissive
  for select
  to public
using ((EXISTS ( SELECT 1
   FROM (((public.lesson_quizzes lq
     JOIN public.course_lessons cl ON ((lq.lesson_id = cl.id)))
     JOIN public.course_modules cm ON ((cl.module_id = cm.id)))
     JOIN public.courses c ON ((cm.course_id = c.id)))
  WHERE ((lq.id = quiz_attempts.quiz_id) AND (c.institution_id = auth.uid())))));



  create policy "quiz_attempts_student_own"
  on "public"."quiz_attempts"
  as permissive
  for all
  to public
using ((user_id = auth.uid()));



  create policy "quiz_question_options_institution_manage"
  on "public"."quiz_question_options"
  as permissive
  for all
  to public
using ((EXISTS ( SELECT 1
   FROM ((((public.quiz_questions qq
     JOIN public.lesson_quizzes lq ON ((qq.quiz_id = lq.id)))
     JOIN public.course_lessons cl ON ((lq.lesson_id = cl.id)))
     JOIN public.course_modules cm ON ((cl.module_id = cm.id)))
     JOIN public.courses c ON ((cm.course_id = c.id)))
  WHERE ((qq.id = quiz_question_options.question_id) AND (c.institution_id = auth.uid())))));



  create policy "quiz_question_options_student_view"
  on "public"."quiz_question_options"
  as permissive
  for select
  to public
using ((EXISTS ( SELECT 1
   FROM (((((public.quiz_questions qq
     JOIN public.lesson_quizzes lq ON ((qq.quiz_id = lq.id)))
     JOIN public.course_lessons cl ON ((lq.lesson_id = cl.id)))
     JOIN public.course_modules cm ON ((cl.module_id = cm.id)))
     JOIN public.courses c ON ((cm.course_id = c.id)))
     JOIN public.enrollments e ON ((e.course_id = c.id)))
  WHERE ((qq.id = quiz_question_options.question_id) AND (cl.is_published = true) AND (e.student_id = auth.uid()) AND ((e.status)::text = 'active'::text)))));



  create policy "quiz_questions_institution_manage"
  on "public"."quiz_questions"
  as permissive
  for all
  to public
using ((EXISTS ( SELECT 1
   FROM (((public.lesson_quizzes lq
     JOIN public.course_lessons cl ON ((lq.lesson_id = cl.id)))
     JOIN public.course_modules cm ON ((cl.module_id = cm.id)))
     JOIN public.courses c ON ((cm.course_id = c.id)))
  WHERE ((lq.id = quiz_questions.quiz_id) AND (c.institution_id = auth.uid())))));



  create policy "quiz_questions_student_view"
  on "public"."quiz_questions"
  as permissive
  for select
  to public
using ((EXISTS ( SELECT 1
   FROM ((((public.lesson_quizzes lq
     JOIN public.course_lessons cl ON ((lq.lesson_id = cl.id)))
     JOIN public.course_modules cm ON ((cl.module_id = cm.id)))
     JOIN public.courses c ON ((cm.course_id = c.id)))
     JOIN public.enrollments e ON ((e.course_id = c.id)))
  WHERE ((lq.id = quiz_questions.quiz_id) AND (cl.is_published = true) AND (e.student_id = auth.uid()) AND ((e.status)::text = 'active'::text)))));



  create policy "Service role can insert clicks"
  on "public"."recommendation_clicks"
  as permissive
  for insert
  to public
with check (true);



  create policy "Students can insert own clicks"
  on "public"."recommendation_clicks"
  as permissive
  for insert
  to public
with check ((auth.uid() = student_id));



  create policy "Students can view own clicks"
  on "public"."recommendation_clicks"
  as permissive
  for select
  to public
using ((auth.uid() = student_id));



  create policy "Students can insert feedback"
  on "public"."recommendation_feedback"
  as permissive
  for insert
  to public
with check ((auth.uid() = student_id));



  create policy "Students can update own feedback"
  on "public"."recommendation_feedback"
  as permissive
  for update
  to public
using ((auth.uid() = student_id));



  create policy "Students can view own feedback"
  on "public"."recommendation_feedback"
  as permissive
  for select
  to public
using ((auth.uid() = student_id));



  create policy "Authenticated can insert impressions"
  on "public"."recommendation_impressions"
  as permissive
  for insert
  to authenticated
with check (true);



  create policy "Students can view own impressions"
  on "public"."recommendation_impressions"
  as permissive
  for select
  to public
using ((auth.uid() = student_id));



  create policy "Service role can manage reminders"
  on "public"."recommendation_reminders"
  as permissive
  for all
  to public
with check (true);



  create policy "Recommenders can update assigned requests"
  on "public"."recommendation_requests"
  as permissive
  for update
  to public
using ((auth.uid() = recommender_id));



  create policy "Recommenders can view their assigned requests"
  on "public"."recommendation_requests"
  as permissive
  for select
  to public
using ((auth.uid() = recommender_id));



  create policy "Students can create requests"
  on "public"."recommendation_requests"
  as permissive
  for insert
  to public
with check ((auth.uid() = student_id));



  create policy "Students can update own requests"
  on "public"."recommendation_requests"
  as permissive
  for update
  to public
using ((auth.uid() = student_id));



  create policy "Students can view own requests"
  on "public"."recommendation_requests"
  as permissive
  for select
  to public
using ((auth.uid() = student_id));



  create policy "Everyone can view public templates"
  on "public"."recommendation_templates"
  as permissive
  for select
  to public
using (((is_public = true) OR (created_by = auth.uid())));



  create policy "Users can create templates"
  on "public"."recommendation_templates"
  as permissive
  for insert
  to public
with check ((auth.uid() = created_by));



  create policy "Users can update own templates"
  on "public"."recommendation_templates"
  as permissive
  for update
  to public
using ((auth.uid() = created_by));



  create policy "Users can manage own recommendations"
  on "public"."recommendations"
  as permissive
  for all
  to public
using ((student_id IN ( SELECT student_profiles.id
   FROM public.student_profiles
  WHERE ((student_profiles.user_id)::text = (auth.uid())::text))));



  create policy "Users can view own recommendations"
  on "public"."recommendations"
  as permissive
  for select
  to public
using ((student_id IN ( SELECT student_profiles.id
   FROM public.student_profiles
  WHERE ((student_profiles.user_id)::text = (auth.uid())::text))));



  create policy "authenticated_users_view_executions"
  on "public"."scheduled_report_executions"
  as permissive
  for select
  to authenticated
using ((scheduled_report_id IN ( SELECT scheduled_reports.id
   FROM public.scheduled_reports
  WHERE (scheduled_reports.created_by = auth.uid()))));



  create policy "authenticated_users_scheduled_reports"
  on "public"."scheduled_reports"
  as permissive
  for all
  to authenticated
using ((created_by = auth.uid()));



  create policy "staff_availability_admin_manage"
  on "public"."staff_availability"
  as permissive
  for all
  to public
using ((auth.uid() IN ( SELECT users.id
   FROM public.users
  WHERE (users.active_role = 'admin'::text))));



  create policy "staff_availability_select"
  on "public"."staff_availability"
  as permissive
  for select
  to public
using (((is_active = true) OR (auth.uid() = staff_id)));



  create policy "staff_availability_staff_manage"
  on "public"."staff_availability"
  as permissive
  for all
  to public
using ((auth.uid() = staff_id))
with check ((auth.uid() = staff_id));



  create policy "Service role can insert activities"
  on "public"."student_activities"
  as permissive
  for insert
  to public
with check (true);



  create policy "Students can view own activities"
  on "public"."student_activities"
  as permissive
  for select
  to public
using ((auth.uid() = student_id));



  create policy "Service role can delete summaries"
  on "public"."student_interaction_summary"
  as permissive
  for delete
  to public
using (true);



  create policy "Service role can insert summaries"
  on "public"."student_interaction_summary"
  as permissive
  for insert
  to public
with check (true);



  create policy "Service role can update summaries"
  on "public"."student_interaction_summary"
  as permissive
  for update
  to public
using (true)
with check (true);



  create policy "Students can view own summary"
  on "public"."student_interaction_summary"
  as permissive
  for select
  to public
using ((auth.uid() = student_id));



  create policy "Authenticated users can view invite codes"
  on "public"."student_invite_codes"
  as permissive
  for select
  to public
using ((auth.role() = 'authenticated'::text));



  create policy "Service role full access to invite codes"
  on "public"."student_invite_codes"
  as permissive
  for all
  to public
using ((auth.role() = 'service_role'::text));



  create policy "Students can create own invite codes"
  on "public"."student_invite_codes"
  as permissive
  for insert
  to public
with check ((auth.uid() = student_id));



  create policy "Students can delete own invite codes"
  on "public"."student_invite_codes"
  as permissive
  for delete
  to public
using ((auth.uid() = student_id));



  create policy "Students can update own invite codes"
  on "public"."student_invite_codes"
  as permissive
  for update
  to public
using ((auth.uid() = student_id));



  create policy "Users can insert own profile"
  on "public"."student_profiles"
  as permissive
  for insert
  to public
with check (((auth.uid())::text = (user_id)::text));



  create policy "Users can update own profile"
  on "public"."student_profiles"
  as permissive
  for update
  to public
using (((auth.uid())::text = (user_id)::text));



  create policy "Users can view own profile"
  on "public"."student_profiles"
  as permissive
  for select
  to public
using (((auth.uid())::text = (user_id)::text));



  create policy "Counselors can view own student records"
  on "public"."student_records"
  as permissive
  for select
  to public
using ((counselor_id = auth.uid()));



  create policy "Students can view own records"
  on "public"."student_records"
  as permissive
  for select
  to public
using ((student_id = auth.uid()));



  create policy "Admins full access to tickets"
  on "public"."support_tickets"
  as permissive
  for all
  to public
using ((EXISTS ( SELECT 1
   FROM public.users
  WHERE ((users.id = auth.uid()) AND (users.active_role = ANY (ARRAY['superadmin'::text, 'supportadmin'::text, 'admin'::text]))))));



  create policy "Users can create tickets"
  on "public"."support_tickets"
  as permissive
  for insert
  to public
with check (((user_id = auth.uid()) OR (user_id IS NULL)));



  create policy "Users can view own tickets"
  on "public"."support_tickets"
  as permissive
  for select
  to public
using ((user_id = auth.uid()));



  create policy "Admins full access to transactions"
  on "public"."transactions"
  as permissive
  for all
  to public
using ((EXISTS ( SELECT 1
   FROM public.users
  WHERE ((users.id = auth.uid()) AND (users.active_role = ANY (ARRAY['superadmin'::text, 'financeadmin'::text, 'admin'::text]))))));



  create policy "Users can view own transactions"
  on "public"."transactions"
  as permissive
  for select
  to public
using ((user_id = auth.uid()));



  create policy "Users can manage their own typing indicators"
  on "public"."typing_indicators"
  as permissive
  for all
  to authenticated
using ((user_id = auth.uid()));



  create policy "Users can view typing indicators in their conversations"
  on "public"."typing_indicators"
  as permissive
  for select
  to authenticated
using ((EXISTS ( SELECT 1
   FROM public.conversations c
  WHERE ((c.id = typing_indicators.conversation_id) AND (auth.uid() = ANY (c.participant_ids))))));



  create policy "Users manage typing"
  on "public"."typing_indicators"
  as permissive
  for all
  to public
using ((auth.uid() = user_id))
with check ((auth.uid() = user_id));



  create policy "Users view typing"
  on "public"."typing_indicators"
  as permissive
  for select
  to public
using (true);



  create policy "Allow public read access to users"
  on "public"."users"
  as permissive
  for select
  to anon, authenticated
using (true);



  create policy "Allow read access for all authenticated users"
  on "public"."users"
  as permissive
  for select
  to authenticated
using (true);



  create policy "Parents can view linked students"
  on "public"."users"
  as permissive
  for select
  to public
using ((id IN ( SELECT parent_student_links.student_id
   FROM public.parent_student_links
  WHERE ((parent_student_links.parent_id = auth.uid()) AND ((parent_student_links.status)::text = 'active'::text)))));



  create policy "Users can update own profile"
  on "public"."users"
  as permissive
  for update
  to public
using ((auth.uid() = id));



  create policy "Users can update own record"
  on "public"."users"
  as permissive
  for update
  to authenticated
using ((auth.uid() = id));



  create policy "Users can view own profile"
  on "public"."users"
  as permissive
  for select
  to public
using ((auth.uid() = id));


CREATE TRIGGER update_applications_updated_at BEFORE UPDATE ON public.applications FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER trigger_update_assignment_submissions_updated_at BEFORE UPDATE ON public.assignment_submissions FOR EACH ROW EXECUTE FUNCTION public.update_assignment_submissions_updated_at();

CREATE TRIGGER trigger_update_conversation_stats AFTER INSERT ON public.chatbot_messages FOR EACH ROW EXECUTE FUNCTION public.update_conversation_stats();

CREATE TRIGGER trigger_update_faq_stats AFTER UPDATE OF feedback ON public.chatbot_messages FOR EACH ROW WHEN ((new.metadata ? 'faq_id'::text)) EXECUTE FUNCTION public.update_faq_stats();

CREATE TRIGGER update_children_updated_at BEFORE UPDATE ON public.children FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER set_conversations_updated_at BEFORE UPDATE ON public.conversations FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_counseling_sessions_updated_at BEFORE UPDATE ON public.counseling_sessions FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER trigger_update_course_lessons_updated_at BEFORE UPDATE ON public.course_lessons FOR EACH ROW EXECUTE FUNCTION public.update_course_lessons_updated_at();

CREATE TRIGGER trigger_update_module_duration_delete AFTER DELETE ON public.course_lessons FOR EACH ROW EXECUTE FUNCTION public.update_module_duration();

CREATE TRIGGER trigger_update_module_duration_insert AFTER INSERT ON public.course_lessons FOR EACH ROW EXECUTE FUNCTION public.update_module_duration();

CREATE TRIGGER trigger_update_module_duration_update AFTER UPDATE OF duration_minutes ON public.course_lessons FOR EACH ROW EXECUTE FUNCTION public.update_module_duration();

CREATE TRIGGER trigger_update_module_lesson_count_delete AFTER DELETE ON public.course_lessons FOR EACH ROW EXECUTE FUNCTION public.update_module_lesson_count();

CREATE TRIGGER trigger_update_module_lesson_count_insert AFTER INSERT ON public.course_lessons FOR EACH ROW EXECUTE FUNCTION public.update_module_lesson_count();

CREATE TRIGGER trigger_update_course_module_count_delete AFTER DELETE ON public.course_modules FOR EACH ROW EXECUTE FUNCTION public.update_course_module_count();

CREATE TRIGGER trigger_update_course_module_count_insert AFTER INSERT ON public.course_modules FOR EACH ROW EXECUTE FUNCTION public.update_course_module_count();

CREATE TRIGGER trigger_update_course_modules_updated_at BEFORE UPDATE ON public.course_modules FOR EACH ROW EXECUTE FUNCTION public.update_course_modules_updated_at();

CREATE TRIGGER trigger_update_courses_updated_at BEFORE UPDATE ON public.courses FOR EACH ROW EXECUTE FUNCTION public.update_courses_updated_at();

CREATE TRIGGER enrichment_jobs_updated_at BEFORE UPDATE ON public.enrichment_jobs FOR EACH ROW EXECUTE FUNCTION public.update_enrichment_jobs_updated_at();

CREATE TRIGGER trigger_update_enrollment_permissions_updated_at BEFORE UPDATE ON public.enrollment_permissions FOR EACH ROW EXECUTE FUNCTION public.update_enrollment_permissions_updated_at();

CREATE TRIGGER trigger_update_course_enrolled_count AFTER INSERT OR DELETE OR UPDATE ON public.enrollments FOR EACH ROW EXECUTE FUNCTION public.update_course_enrolled_count();

CREATE TRIGGER trigger_update_enrollments_updated_at BEFORE UPDATE ON public.enrollments FOR EACH ROW EXECUTE FUNCTION public.update_enrollments_updated_at();

CREATE TRIGGER update_institution_programs_updated_at BEFORE UPDATE ON public.institution_programs FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER trigger_update_lesson_assignments_updated_at BEFORE UPDATE ON public.lesson_assignments FOR EACH ROW EXECUTE FUNCTION public.update_lesson_assignments_updated_at();

CREATE TRIGGER trigger_update_enrollment_progress AFTER INSERT ON public.lesson_completions FOR EACH ROW EXECUTE FUNCTION public.update_enrollment_progress();

CREATE TRIGGER trigger_update_lesson_completions_updated_at BEFORE UPDATE ON public.lesson_completions FOR EACH ROW EXECUTE FUNCTION public.update_lesson_completions_updated_at();

CREATE TRIGGER trigger_update_lesson_quizzes_updated_at BEFORE UPDATE ON public.lesson_quizzes FOR EACH ROW EXECUTE FUNCTION public.update_lesson_quizzes_updated_at();

CREATE TRIGGER trigger_update_lesson_texts_updated_at BEFORE UPDATE ON public.lesson_texts FOR EACH ROW EXECUTE FUNCTION public.update_lesson_texts_updated_at();

CREATE TRIGGER trigger_update_lesson_videos_updated_at BEFORE UPDATE ON public.lesson_videos FOR EACH ROW EXECUTE FUNCTION public.update_lesson_videos_updated_at();

CREATE TRIGGER trigger_meetings_updated_at BEFORE UPDATE ON public.meetings FOR EACH ROW EXECUTE FUNCTION public.update_meetings_updated_at();

CREATE TRIGGER update_notification_preferences_timestamp BEFORE UPDATE ON public.notification_preferences FOR EACH ROW EXECUTE FUNCTION public.trigger_update_timestamp();

CREATE TRIGGER trigger_update_page_contents_updated_at BEFORE UPDATE ON public.page_contents FOR EACH ROW EXECUTE FUNCTION public.update_page_contents_updated_at();

CREATE TRIGGER trigger_programs_updated_at BEFORE UPDATE ON public.programs FOR EACH ROW EXECUTE FUNCTION public.update_programs_updated_at();

CREATE TRIGGER trigger_calculate_quiz_time_taken BEFORE UPDATE OF status, submitted_at ON public.quiz_attempts FOR EACH ROW EXECUTE FUNCTION public.calculate_quiz_time_taken();

CREATE TRIGGER trigger_update_quiz_attempts_updated_at BEFORE UPDATE ON public.quiz_attempts FOR EACH ROW EXECUTE FUNCTION public.update_quiz_attempts_updated_at();

CREATE TRIGGER trigger_update_quiz_question_options_updated_at BEFORE UPDATE ON public.quiz_question_options FOR EACH ROW EXECUTE FUNCTION public.update_quiz_question_options_updated_at();

CREATE TRIGGER trigger_update_quiz_questions_updated_at BEFORE UPDATE ON public.quiz_questions FOR EACH ROW EXECUTE FUNCTION public.update_quiz_questions_updated_at();

CREATE TRIGGER trigger_update_quiz_total_points_delete AFTER DELETE ON public.quiz_questions FOR EACH ROW EXECUTE FUNCTION public.update_quiz_total_points();

CREATE TRIGGER trigger_update_quiz_total_points_insert AFTER INSERT ON public.quiz_questions FOR EACH ROW EXECUTE FUNCTION public.update_quiz_total_points();

CREATE TRIGGER trigger_update_quiz_total_points_update AFTER UPDATE OF points ON public.quiz_questions FOR EACH ROW EXECUTE FUNCTION public.update_quiz_total_points();

CREATE TRIGGER trigger_update_summary_after_click AFTER INSERT ON public.recommendation_clicks FOR EACH ROW EXECUTE FUNCTION public.update_interaction_summary_after_click();

CREATE TRIGGER trigger_update_summary_after_impression AFTER INSERT ON public.recommendation_impressions FOR EACH ROW EXECUTE FUNCTION public.update_interaction_summary_after_impression();

CREATE TRIGGER update_recommendations_updated_at BEFORE UPDATE ON public.recommendations FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_scheduled_reports_timestamp BEFORE UPDATE ON public.scheduled_reports FOR EACH ROW EXECUTE FUNCTION public.update_scheduled_reports_timestamp();

CREATE TRIGGER trigger_staff_availability_updated_at BEFORE UPDATE ON public.staff_availability FOR EACH ROW EXECUTE FUNCTION public.update_meetings_updated_at();

CREATE TRIGGER update_student_profiles_updated_at BEFORE UPDATE ON public.student_profiles FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_student_records_updated_at BEFORE UPDATE ON public.student_records FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_universities_updated_at BEFORE UPDATE ON public.universities FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


