"""
Seed data for universities and programs
"""
from sqlalchemy.orm import Session
from app.database.config import SessionLocal, engine
from app.models.university import University, Program
import logging

logger = logging.getLogger(__name__)


def load_seed_data():
    """Load sample universities and programs into database"""
    db = SessionLocal()

    try:
        # Check if data already exists
        existing_count = db.query(University).count()
        if existing_count > 0:
            logger.info(f"Seed data already exists ({existing_count} universities)")
            return

        logger.info("Loading seed data...")

        # Sample Universities
        universities_data = [
            {
                "name": "Massachusetts Institute of Technology",
                "country": "USA",
                "state": "MA",
                "city": "Cambridge",
                "website": "https://www.mit.edu",
                "description": "MIT is a private research university focused on science and technology, known for its innovation and entrepreneurship.",
                "university_type": "Private",
                "location_type": "Urban",
                "total_students": 11520,
                "global_rank": 1,
                "national_rank": 2,
                "acceptance_rate": 0.04,
                "gpa_average": 4.17,
                "sat_math_25th": 780,
                "sat_math_75th": 800,
                "sat_ebrw_25th": 730,
                "sat_ebrw_75th": 780,
                "act_composite_25th": 35,
                "act_composite_75th": 36,
                "tuition_out_state": 57986,
                "total_cost": 77020,
                "graduation_rate_4year": 0.96,
                "median_earnings_10year": 104700,
                "programs": [
                    {"name": "Computer Science", "degree_type": "Bachelor's", "field": "STEM", "median_salary": 120000},
                    {"name": "Mechanical Engineering", "degree_type": "Bachelor's", "field": "STEM", "median_salary": 95000},
                    {"name": "Electrical Engineering", "degree_type": "Bachelor's", "field": "STEM", "median_salary": 110000},
                ]
            },
            {
                "name": "Stanford University",
                "country": "USA",
                "state": "CA",
                "city": "Stanford",
                "website": "https://www.stanford.edu",
                "description": "Stanford is a private research university known for its entrepreneurial character and proximity to Silicon Valley.",
                "university_type": "Private",
                "location_type": "Suburban",
                "total_students": 17249,
                "global_rank": 2,
                "national_rank": 3,
                "acceptance_rate": 0.04,
                "gpa_average": 4.18,
                "sat_math_25th": 760,
                "sat_math_75th": 800,
                "sat_ebrw_25th": 720,
                "sat_ebrw_75th": 770,
                "act_composite_25th": 34,
                "act_composite_75th": 35,
                "tuition_out_state": 58416,
                "total_cost": 78218,
                "graduation_rate_4year": 0.94,
                "median_earnings_10year": 94000,
                "programs": [
                    {"name": "Computer Science", "degree_type": "Bachelor's", "field": "STEM", "median_salary": 125000},
                    {"name": "Business Administration", "degree_type": "Bachelor's", "field": "Business", "median_salary": 98000},
                    {"name": "Engineering", "degree_type": "Bachelor's", "field": "STEM", "median_salary": 105000},
                ]
            },
            {
                "name": "Harvard University",
                "country": "USA",
                "state": "MA",
                "city": "Cambridge",
                "website": "https://www.harvard.edu",
                "description": "Harvard is the oldest institution of higher learning in the United States, known for its prestigious programs across all disciplines.",
                "university_type": "Private",
                "location_type": "Urban",
                "total_students": 23731,
                "global_rank": 3,
                "national_rank": 1,
                "acceptance_rate": 0.04,
                "gpa_average": 4.18,
                "sat_math_25th": 750,
                "sat_math_75th": 800,
                "sat_ebrw_25th": 730,
                "sat_ebrw_75th": 780,
                "act_composite_25th": 34,
                "act_composite_75th": 36,
                "tuition_out_state": 57261,
                "total_cost": 79450,
                "graduation_rate_4year": 0.98,
                "median_earnings_10year": 95000,
                "programs": [
                    {"name": "Economics", "degree_type": "Bachelor's", "field": "Social Sciences", "median_salary": 92000},
                    {"name": "Computer Science", "degree_type": "Bachelor's", "field": "STEM", "median_salary": 115000},
                    {"name": "Government", "degree_type": "Bachelor's", "field": "Social Sciences", "median_salary": 78000},
                ]
            },
            {
                "name": "University of California, Berkeley",
                "country": "USA",
                "state": "CA",
                "city": "Berkeley",
                "website": "https://www.berkeley.edu",
                "description": "UC Berkeley is a public research university known for its academic excellence and activism.",
                "university_type": "Public",
                "location_type": "Urban",
                "total_students": 45057,
                "global_rank": 4,
                "national_rank": 1,
                "acceptance_rate": 0.11,
                "gpa_average": 3.90,
                "sat_math_25th": 700,
                "sat_math_75th": 790,
                "sat_ebrw_25th": 670,
                "sat_ebrw_75th": 750,
                "act_composite_25th": 31,
                "act_composite_75th": 35,
                "tuition_out_state": 44008,
                "total_cost": 68534,
                "graduation_rate_4year": 0.76,
                "median_earnings_10year": 76700,
                "programs": [
                    {"name": "Computer Science", "degree_type": "Bachelor's", "field": "STEM", "median_salary": 118000},
                    {"name": "Engineering", "degree_type": "Bachelor's", "field": "STEM", "median_salary": 100000},
                    {"name": "Business Administration", "degree_type": "Bachelor's", "field": "Business", "median_salary": 88000},
                ]
            },
            {
                "name": "Carnegie Mellon University",
                "country": "USA",
                "state": "PA",
                "city": "Pittsburgh",
                "website": "https://www.cmu.edu",
                "description": "CMU is a global research university known for its world-class computer science and engineering programs.",
                "university_type": "Private",
                "location_type": "Urban",
                "total_students": 15818,
                "global_rank": 28,
                "national_rank": 25,
                "acceptance_rate": 0.11,
                "gpa_average": 3.90,
                "sat_math_25th": 760,
                "sat_math_75th": 800,
                "sat_ebrw_25th": 710,
                "sat_ebrw_75th": 770,
                "act_composite_25th": 34,
                "act_composite_75th": 35,
                "tuition_out_state": 61344,
                "total_cost": 79196,
                "graduation_rate_4year": 0.80,
                "median_earnings_10year": 88300,
                "programs": [
                    {"name": "Computer Science", "degree_type": "Bachelor's", "field": "STEM", "median_salary": 130000},
                    {"name": "Robotics", "degree_type": "Bachelor's", "field": "STEM", "median_salary": 105000},
                    {"name": "Information Systems", "degree_type": "Bachelor's", "field": "STEM", "median_salary": 98000},
                ]
            },
            {
                "name": "University of Michigan",
                "country": "USA",
                "state": "MI",
                "city": "Ann Arbor",
                "website": "https://www.umich.edu",
                "description": "UMich is a leading public research university with strong programs across all disciplines.",
                "university_type": "Public",
                "location_type": "Suburban",
                "total_students": 47907,
                "global_rank": 17,
                "national_rank": 3,
                "acceptance_rate": 0.18,
                "gpa_average": 3.88,
                "sat_math_25th": 700,
                "sat_math_75th": 790,
                "sat_ebrw_25th": 680,
                "sat_ebrw_75th": 750,
                "act_composite_25th": 32,
                "act_composite_75th": 35,
                "tuition_out_state": 53232,
                "total_cost": 72208,
                "graduation_rate_4year": 0.77,
                "median_earnings_10year": 72100,
                "programs": [
                    {"name": "Engineering", "degree_type": "Bachelor's", "field": "STEM", "median_salary": 95000},
                    {"name": "Business", "degree_type": "Bachelor's", "field": "Business", "median_salary": 87000},
                    {"name": "Computer Science", "degree_type": "Bachelor's", "field": "STEM", "median_salary": 105000},
                ]
            },
            {
                "name": "Georgia Institute of Technology",
                "country": "USA",
                "state": "GA",
                "city": "Atlanta",
                "website": "https://www.gatech.edu",
                "description": "Georgia Tech is a top-tier public research university specializing in engineering and technology.",
                "university_type": "Public",
                "location_type": "Urban",
                "total_students": 40418,
                "global_rank": 38,
                "national_rank": 7,
                "acceptance_rate": 0.16,
                "gpa_average": 4.07,
                "sat_math_25th": 740,
                "sat_math_75th": 800,
                "sat_ebrw_25th": 680,
                "sat_ebrw_75th": 750,
                "act_composite_25th": 32,
                "act_composite_75th": 35,
                "tuition_out_state": 33020,
                "total_cost": 51794,
                "graduation_rate_4year": 0.59,
                "median_earnings_10year": 83400,
                "programs": [
                    {"name": "Computer Science", "degree_type": "Bachelor's", "field": "STEM", "median_salary": 112000},
                    {"name": "Mechanical Engineering", "degree_type": "Bachelor's", "field": "STEM", "median_salary": 92000},
                    {"name": "Industrial Engineering", "degree_type": "Bachelor's", "field": "STEM", "median_salary": 88000},
                ]
            },
            {
                "name": "University of Illinois at Urbana-Champaign",
                "country": "USA",
                "state": "IL",
                "city": "Urbana",
                "website": "https://www.illinois.edu",
                "description": "UIUC is a public research university with renowned engineering and computer science programs.",
                "university_type": "Public",
                "location_type": "Suburban",
                "total_students": 56607,
                "global_rank": 48,
                "national_rank": 15,
                "acceptance_rate": 0.45,
                "gpa_average": 3.83,
                "sat_math_25th": 720,
                "sat_math_75th": 800,
                "sat_ebrw_25th": 650,
                "sat_ebrw_75th": 730,
                "act_composite_25th": 30,
                "act_composite_75th": 34,
                "tuition_out_state": 35110,
                "total_cost": 52882,
                "graduation_rate_4year": 0.71,
                "median_earnings_10year": 69200,
                "programs": [
                    {"name": "Computer Science", "degree_type": "Bachelor's", "field": "STEM", "median_salary": 108000},
                    {"name": "Engineering", "degree_type": "Bachelor's", "field": "STEM", "median_salary": 92000},
                    {"name": "Business", "degree_type": "Bachelor's", "field": "Business", "median_salary": 75000},
                ]
            },
            {
                "name": "University of Texas at Austin",
                "country": "USA",
                "state": "TX",
                "city": "Austin",
                "website": "https://www.utexas.edu",
                "description": "UT Austin is a major public research university with strong programs in technology, business, and liberal arts.",
                "university_type": "Public",
                "location_type": "Urban",
                "total_students": 52384,
                "global_rank": 38,
                "national_rank": 8,
                "acceptance_rate": 0.29,
                "gpa_average": 3.83,
                "sat_math_25th": 670,
                "sat_math_75th": 780,
                "sat_ebrw_25th": 640,
                "sat_ebrw_75th": 730,
                "act_composite_25th": 29,
                "act_composite_75th": 34,
                "tuition_out_state": 40996,
                "total_cost": 58918,
                "graduation_rate_4year": 0.66,
                "median_earnings_10year": 65100,
                "programs": [
                    {"name": "Computer Science", "degree_type": "Bachelor's", "field": "STEM", "median_salary": 102000},
                    {"name": "Business", "degree_type": "Bachelor's", "field": "Business", "median_salary": 73000},
                    {"name": "Engineering", "degree_type": "Bachelor's", "field": "STEM", "median_salary": 88000},
                ]
            },
            {
                "name": "University of Washington",
                "country": "USA",
                "state": "WA",
                "city": "Seattle",
                "website": "https://www.washington.edu",
                "description": "UW is a leading public research university with strong programs in technology, medicine, and sciences.",
                "university_type": "Public",
                "location_type": "Urban",
                "total_students": 48149,
                "global_rank": 20,
                "national_rank": 6,
                "acceptance_rate": 0.48,
                "gpa_average": 3.80,
                "sat_math_25th": 680,
                "sat_math_75th": 780,
                "sat_ebrw_25th": 650,
                "sat_ebrw_75th": 730,
                "act_composite_25th": 29,
                "act_composite_75th": 34,
                "tuition_out_state": 39906,
                "total_cost": 59400,
                "graduation_rate_4year": 0.68,
                "median_earnings_10year": 68200,
                "programs": [
                    {"name": "Computer Science", "degree_type": "Bachelor's", "field": "STEM", "median_salary": 110000},
                    {"name": "Engineering", "degree_type": "Bachelor's", "field": "STEM", "median_salary": 90000},
                    {"name": "Business", "degree_type": "Bachelor's", "field": "Business", "median_salary": 72000},
                ]
            },
            {
                "name": "Purdue University",
                "country": "USA",
                "state": "IN",
                "city": "West Lafayette",
                "website": "https://www.purdue.edu",
                "description": "Purdue is a public research university known for its strong engineering, technology, and agriculture programs.",
                "university_type": "Public",
                "location_type": "Suburban",
                "total_students": 50884,
                "global_rank": 111,
                "national_rank": 51,
                "acceptance_rate": 0.53,
                "gpa_average": 3.74,
                "sat_math_25th": 660,
                "sat_math_75th": 780,
                "sat_ebrw_25th": 620,
                "sat_ebrw_75th": 710,
                "act_composite_25th": 28,
                "act_composite_75th": 34,
                "tuition_out_state": 28794,
                "total_cost": 45934,
                "graduation_rate_4year": 0.59,
                "median_earnings_10year": 63900,
                "programs": [
                    {"name": "Engineering", "degree_type": "Bachelor's", "field": "STEM", "median_salary": 85000},
                    {"name": "Computer Science", "degree_type": "Bachelor's", "field": "STEM", "median_salary": 95000},
                    {"name": "Business", "degree_type": "Bachelor's", "field": "Business", "median_salary": 68000},
                ]
            },
            {
                "name": "Arizona State University",
                "country": "USA",
                "state": "AZ",
                "city": "Tempe",
                "website": "https://www.asu.edu",
                "description": "ASU is a large public research university known for innovation and accessibility.",
                "university_type": "Public",
                "location_type": "Urban",
                "total_students": 80065,
                "global_rank": 186,
                "national_rank": 117,
                "acceptance_rate": 0.88,
                "gpa_average": 3.54,
                "sat_math_25th": 590,
                "sat_math_75th": 710,
                "sat_ebrw_25th": 580,
                "sat_ebrw_75th": 680,
                "act_composite_25th": 24,
                "act_composite_75th": 31,
                "tuition_out_state": 29428,
                "total_cost": 47286,
                "graduation_rate_4year": 0.48,
                "median_earnings_10year": 54300,
                "programs": [
                    {"name": "Business", "degree_type": "Bachelor's", "field": "Business", "median_salary": 62000},
                    {"name": "Engineering", "degree_type": "Bachelor's", "field": "STEM", "median_salary": 75000},
                    {"name": "Computer Science", "degree_type": "Bachelor's", "field": "STEM", "median_salary": 82000},
                ]
            },
        ]

        # Create universities and programs
        for uni_data in universities_data:
            programs_data = uni_data.pop("programs", [])

            university = University(**uni_data)
            db.add(university)
            db.flush()  # Get university ID

            for prog_data in programs_data:
                program = Program(university_id=university.id, **prog_data)
                db.add(program)

        db.commit()
        logger.info(f"Successfully loaded {len(universities_data)} universities with programs")

    except Exception as e:
        logger.error(f"Error loading seed data: {e}")
        db.rollback()
        raise
    finally:
        db.close()


if __name__ == "__main__":
    load_seed_data()
