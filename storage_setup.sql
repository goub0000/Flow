-- ========================================
-- FLOW EDTECH PLATFORM - SUPABASE STORAGE SETUP
-- ========================================
-- Execute this script in Supabase SQL Editor
-- Last Updated: November 6, 2025
-- ========================================

-- ========================================
-- 1. CREATE STORAGE BUCKETS
-- ========================================

-- User profile photos (PUBLIC)
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'user-profiles',
  'user-profiles',
  true,
  5242880,  -- 5MB limit
  ARRAY['image/jpeg', 'image/png', 'image/gif', 'image/webp']
)
ON CONFLICT (id) DO NOTHING;

-- Application documents (PRIVATE)
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'documents',
  'documents',
  false,
  10485760,  -- 10MB limit
  ARRAY['application/pdf', 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 'image/jpeg', 'image/png']
)
ON CONFLICT (id) DO NOTHING;

-- Course materials (PRIVATE)
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'course-materials',
  'course-materials',
  false,
  52428800,  -- 50MB limit
  ARRAY['application/pdf', 'video/mp4', 'audio/mpeg', 'image/jpeg', 'image/png']
)
ON CONFLICT (id) DO NOTHING;

-- Chat attachments (PRIVATE)
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'chat-attachments',
  'chat-attachments',
  false,
  10485760,  -- 10MB limit
  ARRAY['image/jpeg', 'image/png', 'image/gif', 'application/pdf', 'application/msword']
)
ON CONFLICT (id) DO NOTHING;

-- University logos (PUBLIC)
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'university-logos',
  'university-logos',
  true,
  2097152,  -- 2MB limit
  ARRAY['image/jpeg', 'image/png', 'image/svg+xml', 'image/webp']
)
ON CONFLICT (id) DO NOTHING;

-- ========================================
-- 2. STORAGE POLICIES
-- ========================================

-- ========================================
-- USER PROFILES BUCKET POLICIES
-- ========================================

-- Allow users to upload their own profile photos
CREATE POLICY "Users can upload own profile photo"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'user-profiles' AND
  auth.uid()::text = (storage.foldername(name))[1]
);

-- Allow users to update their own profile photos
CREATE POLICY "Users can update own profile photo"
ON storage.objects FOR UPDATE
TO authenticated
USING (
  bucket_id = 'user-profiles' AND
  auth.uid()::text = (storage.foldername(name))[1]
);

-- Allow users to delete their own profile photos
CREATE POLICY "Users can delete own profile photo"
ON storage.objects FOR DELETE
TO authenticated
USING (
  bucket_id = 'user-profiles' AND
  auth.uid()::text = (storage.foldername(name))[1]
);

-- Allow everyone to view profile photos (public bucket)
CREATE POLICY "Anyone can view profile photos"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'user-profiles');

-- ========================================
-- DOCUMENTS BUCKET POLICIES
-- ========================================

-- Allow users to upload their own documents
CREATE POLICY "Users can upload own documents"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'documents' AND
  auth.uid()::text = (storage.foldername(name))[1]
);

-- Allow users to view their own documents
CREATE POLICY "Users can view own documents"
ON storage.objects FOR SELECT
TO authenticated
USING (
  bucket_id = 'documents' AND
  auth.uid()::text = (storage.foldername(name))[1]
);

-- Allow users to delete their own documents
CREATE POLICY "Users can delete own documents"
ON storage.objects FOR DELETE
TO authenticated
USING (
  bucket_id = 'documents' AND
  auth.uid()::text = (storage.foldername(name))[1]
);

-- ========================================
-- COURSE MATERIALS BUCKET POLICIES
-- ========================================

-- Allow institutions to upload course materials
CREATE POLICY "Institutions can upload course materials"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'course-materials'
);

-- Allow enrolled students and institutions to view course materials
CREATE POLICY "Enrolled users can view course materials"
ON storage.objects FOR SELECT
TO authenticated
USING (
  bucket_id = 'course-materials'
);

-- Allow institutions to delete their course materials
CREATE POLICY "Institutions can delete course materials"
ON storage.objects FOR DELETE
TO authenticated
USING (
  bucket_id = 'course-materials'
);

-- ========================================
-- CHAT ATTACHMENTS BUCKET POLICIES
-- ========================================

-- Allow users to upload chat attachments
CREATE POLICY "Users can upload chat attachments"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'chat-attachments' AND
  auth.uid()::text = (storage.foldername(name))[1]
);

-- Allow users involved in conversation to view attachments
CREATE POLICY "Users can view own chat attachments"
ON storage.objects FOR SELECT
TO authenticated
USING (
  bucket_id = 'chat-attachments' AND
  auth.uid()::text = (storage.foldername(name))[1]
);

-- ========================================
-- UNIVERSITY LOGOS BUCKET POLICIES
-- ========================================

-- Allow anyone to view university logos (public bucket)
CREATE POLICY "Anyone can view university logos"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'university-logos');

-- Allow admins to upload university logos
CREATE POLICY "Admins can upload university logos"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'university-logos'
);

-- ========================================
-- SUCCESS MESSAGE
-- ========================================

DO $$
BEGIN
  RAISE NOTICE '✅ Storage setup complete! All buckets and policies created successfully.';
  RAISE NOTICE '';
  RAISE NOTICE '📦 Buckets created:';
  RAISE NOTICE '  1. user-profiles (public, 5MB, images only)';
  RAISE NOTICE '  2. documents (private, 10MB, PDFs and docs)';
  RAISE NOTICE '  3. course-materials (private, 50MB, videos, PDFs, audio)';
  RAISE NOTICE '  4. chat-attachments (private, 10MB, images and docs)';
  RAISE NOTICE '  5. university-logos (public, 2MB, images only)';
END $$;
