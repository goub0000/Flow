-- Add preferences column
ALTER TABLE public.users ADD COLUMN preferences JSONB DEFAULT '{}'::jsonb;
