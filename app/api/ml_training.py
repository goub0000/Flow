"""
ML Model Training API
Train models directly on Railway
"""
from fastapi import APIRouter, BackgroundTasks
from app.database.config import get_supabase
import logging

router = APIRouter()
logger = logging.getLogger(__name__)

training_status = {
    "is_training": False,
    "status": "idle",
    "message": None
}


def train_models_background():
    """Background task to train ML models"""
    global training_status
    try:
        training_status["is_training"] = True
        training_status["status"] = "training"
        training_status["message"] = "Training ML models..."

        logger.info("Starting ML model training...")

        # Import here to avoid loading if not needed
        from app.ml.feature_engineering import FeatureEngineer
        from app.ml.models import EnsembleRecommendationModel
        from app.services.recommendation_engine import RecommendationEngine
        import numpy as np
        import os

        db = get_supabase()

        # Generate synthetic training data
        logger.info("Generating synthetic training data...")
        students, universities, programs_by_university, scores = generate_synthetic_data(db)

        # Train models
        logger.info("Training ensemble model...")
        feature_engineer = FeatureEngineer()
        ml_model = EnsembleRecommendationModel(feature_engineer)
        ml_model.train_ranker(students, universities, programs_by_university, scores)

        # Save models
        model_dir = "ml_models"
        os.makedirs(model_dir, exist_ok=True)
        ml_model.save(model_dir)

        training_status["is_training"] = False
        training_status["status"] = "completed"
        training_status["message"] = f"Models trained and saved to {model_dir}/"
        logger.info("ML training completed successfully!")

    except Exception as e:
        logger.error(f"ML training failed: {e}")
        training_status["is_training"] = False
        training_status["status"] = "failed"
        training_status["message"] = str(e)


def generate_synthetic_data(db, n_students=200):
    """Generate synthetic training data"""
    import numpy as np
    from app.services.recommendation_engine import RecommendationEngine

    # Get data
    response = db.table('universities').select('*').limit(500).execute()
    universities = response.data

    programs_by_university = {}

    # Generate synthetic students
    students = []
    majors = ["Computer Science", "Business", "Engineering", "Biology"]

    for i in range(n_students):
        student = {
            "id": i + 1,
            "user_id": f"synthetic_{i}",
            "gpa": np.random.uniform(2.5, 4.0),
            "sat_total": int(np.random.uniform(900, 1600)),
            "intended_major": np.random.choice(majors),
            "max_budget_per_year": np.random.uniform(20000, 80000),
        }
        students.append(student)

    # Calculate scores
    rule_engine = RecommendationEngine(db)
    scores_list = []

    for student in students:
        student_scores = []
        for university in universities:
            dimension_scores = rule_engine._calculate_scores(student, university, programs_by_university)
            total_score = rule_engine._calculate_total_score(dimension_scores)
            student_scores.append(total_score)
        scores_list.append(student_scores)

    scores = np.array(scores_list)

    return students, universities, programs_by_university, scores


@router.post("/ml/train")
async def start_training(background_tasks: BackgroundTasks):
    """Start ML model training in background"""
    global training_status

    if training_status["is_training"]:
        return {
            "status": "already_training",
            "message": "Training is already in progress"
        }

    background_tasks.add_task(train_models_background)

    return {
        "status": "started",
        "message": "ML model training started in background"
    }


@router.get("/ml/training-status")
async def get_training_status():
    """Get ML training status"""
    return training_status
