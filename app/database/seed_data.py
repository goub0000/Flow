"""
LEGACY FILE - NO LONGER USED

This file contained seed data loading functions for the local SQLite database.
The system has been migrated to 100% cloud-based architecture using Supabase.

All university data is now stored in and loaded from Supabase PostgreSQL database.
Data import is handled by dedicated scripts that load directly to Supabase:
- import_college_scorecard_to_supabase.py
- import_universities_list_api.py
- import_the_rankings.py

Current data: 17,137+ universities in Supabase cloud database.
"""
