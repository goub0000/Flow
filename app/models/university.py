"""
Database models for Find Your Path service
"""
from sqlalchemy import Column, Integer, String, Float, Text, ForeignKey, JSON, DateTime
from sqlalchemy.orm import relationship
from datetime import datetime
from app.database.config import Base

class University(Base):
    """University model - stores comprehensive university information"""
    __tablename__ = "universities"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(255), nullable=False, index=True)
    country = Column(String(100), nullable=False, index=True)
    state = Column(String(100))
    city = Column(String(100))
    website = Column(String(255))
    logo_url = Column(String(500))
    description = Column(Text)
    university_type = Column(String(50))  # Public, Private, etc.
    location_type = Column(String(50))    # Urban, Suburban, Rural

    # Student body
    total_students = Column(Integer)

    # Rankings
    global_rank = Column(Integer)
    national_rank = Column(Integer)

    # Admissions
    acceptance_rate = Column(Float)
    gpa_average = Column(Float)
    sat_math_25th = Column(Integer)
    sat_math_75th = Column(Integer)
    sat_ebrw_25th = Column(Integer)
    sat_ebrw_75th = Column(Integer)
    act_composite_25th = Column(Integer)
    act_composite_75th = Column(Integer)

    # Financial
    tuition_out_state = Column(Float)
    total_cost = Column(Float)

    # Outcomes
    graduation_rate_4year = Column(Float)
    median_earnings_10year = Column(Float)

    # Relationships
    programs = relationship("Program", back_populates="university", cascade="all, delete-orphan")
    recommendations = relationship("Recommendation", back_populates="university")

    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)


class Program(Base):
    """Academic program model"""
    __tablename__ = "programs"

    id = Column(Integer, primary_key=True, index=True)
    university_id = Column(Integer, ForeignKey("universities.id"), nullable=False)
    name = Column(String(255), nullable=False)
    degree_type = Column(String(50), nullable=False)  # Bachelor's, Master's, PhD
    field = Column(String(100))  # STEM, Business, Arts, etc.
    description = Column(Text)
    median_salary = Column(Float)

    # Relationships
    university = relationship("University", back_populates="programs")

    created_at = Column(DateTime, default=datetime.utcnow)


class StudentProfile(Base):
    """Student profile for recommendations"""
    __tablename__ = "student_profiles"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(String(100), unique=True, nullable=False, index=True)

    # Global Academic Information
    grading_system = Column(String(50))  # american, ib, aLevel, french, etc.
    grade_value = Column(String(20))  # e.g., '3.8', '38', 'A*', '16'
    nationality = Column(String(10))  # Country code
    current_country = Column(String(10))  # Country code where currently studying
    current_region = Column(String(100))  # State/Province/Region
    standardized_test_type = Column(String(50))  # SAT, ACT, IB, A-Levels, etc.
    test_scores = Column(JSON)  # Flexible scores: {'total': 1400, 'math': 700, 'verbal': 700}

    # Legacy Academic Info (maintained for backward compatibility)
    gpa = Column(Float)
    sat_total = Column(Integer)
    sat_math = Column(Integer)
    sat_ebrw = Column(Integer)
    act_composite = Column(Integer)
    class_rank = Column(Integer)
    class_size = Column(Integer)

    # Interests
    intended_major = Column(String(100))
    field_of_study = Column(String(100))
    career_goals = Column(Text)
    alternative_majors = Column(JSON)  # List of alternative majors
    career_focused = Column(Integer, default=1)  # 0 = No, 1 = Yes
    research_opportunities = Column(Integer, default=0)

    # Preferences
    preferred_states = Column(JSON)  # List of state codes (legacy)
    preferred_regions = Column(JSON)  # List of region names (global)
    preferred_countries = Column(JSON)  # List of country codes
    location_type_preference = Column(String(50))  # Urban, Suburban, Rural

    # Financial
    budget_range = Column(String(50))  # e.g., 'Under $10,000', '$10,000 - $20,000'
    max_budget_per_year = Column(Float)
    need_financial_aid = Column(Integer, default=0)  # 0 = No, 1 = Yes
    eligible_for_in_state = Column(String(50))  # State code for in-state tuition eligibility

    # University characteristics
    preferred_university_type = Column(String(50))  # Public, Private
    university_size_preference = Column(String(100))  # Small, Medium, Large, etc.
    university_type_preference = Column(String(100))  # Public, Private, Research, etc.
    preferred_size = Column(String(50))  # Legacy field
    interested_in_sports = Column(Integer, default=0)  # 0 = No, 1 = Yes
    sports_important = Column(Integer, default=0)  # Legacy field
    features_desired = Column(JSON)  # List of desired campus features
    deal_breakers = Column(JSON)  # List of deal breakers

    # Relationships
    recommendations = relationship("Recommendation", back_populates="student")

    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)


class Recommendation(Base):
    """Recommendation linking students to universities"""
    __tablename__ = "recommendations"

    id = Column(Integer, primary_key=True, index=True)
    student_id = Column(Integer, ForeignKey("student_profiles.id"), nullable=False)
    university_id = Column(Integer, ForeignKey("universities.id"), nullable=False)

    # Recommendation details
    match_score = Column(Float, nullable=False)  # 0-100
    category = Column(String(20), nullable=False)  # Safety, Match, Reach

    # Score breakdown
    academic_score = Column(Float)
    financial_score = Column(Float)
    program_score = Column(Float)
    location_score = Column(Float)
    characteristics_score = Column(Float)

    # Insights
    strengths = Column(JSON)  # List of strength points
    concerns = Column(JSON)   # List of concern points

    # User interaction
    favorited = Column(Integer, default=0)  # 0 = No, 1 = Yes
    notes = Column(Text)

    # Relationships
    student = relationship("StudentProfile", back_populates="recommendations")
    university = relationship("University", back_populates="recommendations")

    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
