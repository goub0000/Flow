"""
Training Script for ML Recommendation Models
Generates synthetic training data and trains LightGBM ranker
"""
import os
import sys
import logging
import numpy as np
from pathlib import Path

# Add app to path
sys.path.insert(0, str(Path(__file__).parent))

from app.database.config import get_supabase
from app.ml.feature_engineering import FeatureEngineer
from app.ml.models import EnsembleRecommendationModel
from app.services.recommendation_engine import RecommendationEngine

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)


def generate_synthetic_training_data(
    db,
    n_students: int = 100
):
    """
    Generate synthetic training data by creating diverse student profiles
    and calculating rule-based scores as labels

    Args:
        db: Supabase client
        n_students: Number of synthetic students to generate

    Returns:
        students, universities, programs_by_university, scores
    """
    logger.info(f"Generating {n_students} synthetic student profiles...")

    # Get universities
    response = db.table('universities').select('*').execute()
    universities = response.data
    logger.info(f"Loaded {len(universities)} universities")

    # Get programs
    programs_response = db.table('programs').select('*').execute()
    all_programs = programs_response.data

    programs_by_university = {}
    for program in all_programs:
        univ_id = program.get('university_id')
        if univ_id:
            if univ_id not in programs_by_university:
                programs_by_university[univ_id] = []
            programs_by_university[univ_id].append(program)

    logger.info(f"Loaded programs for {len(programs_by_university)} universities")

    # Generate diverse synthetic students
    students = []
    majors = ["Computer Science", "Business", "Engineering", "Biology", "Psychology",
              "Economics", "Mathematics", "Chemistry", "English", "History"]
    states = ["CA", "NY", "TX", "FL", "MA", "IL", "PA", "OH", "GA", "NC"]
    location_types = ["Urban", "Suburban", "Rural"]
    univ_types = ["Private", "Public"]

    for i in range(n_students):
        student = {
            "id": i + 1,
            "user_id": f"synthetic_student_{i}",
            "gpa": np.random.uniform(2.5, 4.0),
            "sat_total": int(np.random.uniform(900, 1600)),
            "sat_math": int(np.random.uniform(400, 800)),
            "sat_ebrw": int(np.random.uniform(400, 800)),
            "act_composite": int(np.random.uniform(15, 36)),
            "class_rank": int(np.random.uniform(1, 400)),
            "class_size": 400,
            "intended_major": np.random.choice(majors),
            "field_of_study": np.random.choice(["STEM", "Business", "Liberal Arts", "Sciences"]),
            "preferred_states": list(np.random.choice(states, size=3, replace=False)),
            "location_type_preference": np.random.choice(location_types),
            "max_budget_per_year": np.random.uniform(20000, 80000),
            "preferred_university_type": np.random.choice(univ_types),
            "career_focused": int(np.random.random() > 0.5),
            "research_opportunities": int(np.random.random() > 0.7),
            "interested_in_sports": int(np.random.random() > 0.6),
        }
        students.append(student)

    logger.info(f"Generated {len(students)} synthetic students")

    # Calculate rule-based scores as training labels
    logger.info("Calculating rule-based scores as training labels...")
    rule_engine = RecommendationEngine(db)

    scores_list = []
    for student in students:
        student_scores = []
        for university in universities:
            programs = programs_by_university.get(university['id'], [])
            dimension_scores = rule_engine._calculate_scores(
                student, university, programs_by_university
            )
            total_score = rule_engine._calculate_total_score(dimension_scores)
            student_scores.append(total_score)

        scores_list.append(student_scores)

    scores = np.array(scores_list)
    logger.info(f"Calculated scores matrix: {scores.shape}")

    return students, universities, programs_by_university, scores


def train_models(model_dir: str = "ml_models"):
    """
    Train ML models and save to disk

    Args:
        model_dir: Directory to save trained models
    """
    logger.info("=" * 80)
    logger.info("Starting ML Model Training")
    logger.info("=" * 80)

    # Connect to database
    db = get_supabase()
    logger.info("✅ Connected to Supabase")

    # Generate training data
    students, universities, programs_by_university, scores = generate_synthetic_training_data(
        db, n_students=200  # Generate 200 synthetic students
    )

    # Initialize feature engineer
    logger.info("Initializing feature engineer...")
    feature_engineer = FeatureEngineer()

    # Initialize ensemble model
    logger.info("Initializing ensemble model...")
    ml_model = EnsembleRecommendationModel(feature_engineer)

    # Train LightGBM ranker
    logger.info("=" * 80)
    logger.info("Training LightGBM Ranker")
    logger.info("=" * 80)

    ml_model.train_ranker(
        students, universities, programs_by_university, scores
    )

    # Save models
    logger.info("=" * 80)
    logger.info(f"Saving models to {model_dir}")
    logger.info("=" * 80)

    os.makedirs(model_dir, exist_ok=True)
    ml_model.save(model_dir)

    logger.info("✅ Model training completed successfully!")
    logger.info(f"✅ Models saved to {model_dir}/")
    logger.info("")
    logger.info("To use the trained models:")
    logger.info("1. The models will be automatically loaded by the API")
    logger.info("2. Set ML_MODELS_DIR environment variable (default: ./ml_models)")
    logger.info("3. Restart the API server")


if __name__ == "__main__":
    # Parse arguments
    import argparse
    parser = argparse.ArgumentParser(description="Train ML recommendation models")
    parser.add_argument(
        "--model-dir",
        type=str,
        default="ml_models",
        help="Directory to save trained models (default: ml_models)"
    )
    parser.add_argument(
        "--n-students",
        type=int,
        default=200,
        help="Number of synthetic students to generate for training (default: 200)"
    )

    args = parser.parse_args()

    try:
        train_models(model_dir=args.model_dir)
    except Exception as e:
        logger.error(f"❌ Training failed: {e}", exc_info=True)
        sys.exit(1)
