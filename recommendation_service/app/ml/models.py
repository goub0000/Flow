"""
Machine Learning Models for Enhanced Recommendation System
Implements LightGBM ranker and Neural Network for personalized matching
"""
import numpy as np
import pandas as pd
from typing import Dict, List, Tuple, Optional
import lightgbm as lgb
from sklearn.model_selection import train_test_split
import joblib
import logging
import os

# Optional PyTorch import (only needed for neural network personalization)
try:
    import torch
    import torch.nn as nn
    import torch.nn.functional as F
    TORCH_AVAILABLE = True
except ImportError:
    TORCH_AVAILABLE = False
    torch = None
    nn = None
    F = None

logger = logging.getLogger(__name__)


# Only define neural network if PyTorch is available
if TORCH_AVAILABLE:
    class PersonalizedWeightNetwork(nn.Module):
        """
        Neural Network that learns personalized importance weights for each dimension
        Input: student features
        Output: 5 weights for [academic, financial, program, location, characteristics]
        """

        def __init__(self, input_dim: int = 13):
            super(PersonalizedWeightNetwork, self).__init__()

            self.fc1 = nn.Linear(input_dim, 64)
            self.bn1 = nn.BatchNorm1d(64)
            self.dropout1 = nn.Dropout(0.3)

            self.fc2 = nn.Linear(64, 32)
            self.bn2 = nn.BatchNorm1d(32)
            self.dropout2 = nn.Dropout(0.2)

            self.fc3 = nn.Linear(32, 16)
            self.fc_out = nn.Linear(16, 5)  # 5 dimension weights

        def forward(self, x):
            x = F.relu(self.bn1(self.fc1(x)))
            x = self.dropout1(x)

            x = F.relu(self.bn2(self.fc2(x)))
            x = self.dropout2(x)

            x = F.relu(self.fc3(x))

            # Output weights with softmax to ensure they sum to 1
            weights = F.softmax(self.fc_out(x), dim=1)

            return weights
else:
    # Placeholder when PyTorch is not available
    PersonalizedWeightNetwork = None


class LightGBMRanker:
    """
    Gradient Boosting model for learning-to-rank universities
    Learns complex feature interactions for match score prediction
    """

    def __init__(self):
        self.model = None
        self.feature_names = None

    def train(
        self,
        X: np.ndarray,
        y: np.ndarray,
        feature_names: List[str],
        val_split: float = 0.2
    ):
        """
        Train LightGBM ranking model

        Args:
            X: Feature matrix (n_samples, n_features)
            y: Target scores (n_samples,)
            feature_names: List of feature names
            val_split: Validation split ratio
        """
        logger.info(f"Training LightGBM model on {X.shape[0]} samples with {X.shape[1]} features")

        # Split data
        X_train, X_val, y_train, y_val = train_test_split(
            X, y, test_size=val_split, random_state=42
        )

        # Create datasets
        train_data = lgb.Dataset(X_train, label=y_train, feature_name=feature_names)
        val_data = lgb.Dataset(X_val, label=y_val, reference=train_data, feature_name=feature_names)

        # Parameters optimized for ranking
        params = {
            'objective': 'regression',
            'metric': 'rmse',
            'boosting_type': 'gbdt',
            'num_leaves': 31,
            'learning_rate': 0.05,
            'feature_fraction': 0.8,
            'bagging_fraction': 0.8,
            'bagging_freq': 5,
            'max_depth': 6,
            'min_data_in_leaf': 20,
            'lambda_l1': 0.1,
            'lambda_l2': 0.1,
            'verbose': -1
        }

        # Train model
        self.model = lgb.train(
            params,
            train_data,
            num_boost_round=500,
            valid_sets=[train_data, val_data],
            valid_names=['train', 'valid'],
            callbacks=[
                lgb.early_stopping(stopping_rounds=50),
                lgb.log_evaluation(period=50)
            ]
        )

        self.feature_names = feature_names

        # Log feature importance
        importance = self.model.feature_importance(importance_type='gain')
        top_features = sorted(zip(feature_names, importance), key=lambda x: x[1], reverse=True)[:10]
        logger.info("Top 10 important features:")
        for feat, imp in top_features:
            logger.info(f"  {feat}: {imp:.2f}")

    def predict(self, X: np.ndarray) -> np.ndarray:
        """
        Predict match scores for feature matrix

        Args:
            X: Feature matrix (n_samples, n_features)

        Returns:
            Predicted scores (n_samples,)
        """
        if self.model is None:
            raise ValueError("Model not trained yet")

        return self.model.predict(X)

    def save(self, path: str):
        """Save model to disk"""
        if self.model is None:
            raise ValueError("No model to save")

        self.model.save_model(path)
        logger.info(f"LightGBM model saved to {path}")

    def load(self, path: str):
        """Load model from disk"""
        self.model = lgb.Booster(model_file=path)
        logger.info(f"LightGBM model loaded from {path}")


if TORCH_AVAILABLE:
    class PersonalizedWeightPredictor:
        """
        Wrapper for PersonalizedWeightNetwork with training and inference methods
        """

        def __init__(self, input_dim: int = 13):
            self.input_dim = input_dim
            self.model = PersonalizedWeightNetwork(input_dim)
            self.device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
            self.model.to(self.device)

        def train(
            self,
            X: np.ndarray,
            y_weights: np.ndarray,
            epochs: int = 100,
            batch_size: int = 32,
            learning_rate: float = 0.001,
            val_split: float = 0.2
        ):
            """
            Train personalized weight network

            Args:
                X: Student features (n_students, input_dim)
                y_weights: Target weights (n_students, 5) - for 5 dimensions
                epochs: Number of training epochs
                batch_size: Batch size
                learning_rate: Learning rate
                val_split: Validation split ratio
            """
            logger.info(f"Training PersonalizedWeightNetwork on {X.shape[0]} students")

            # Split data
            X_train, X_val, y_train, y_val = train_test_split(
                X, y_weights, test_size=val_split, random_state=42
            )

            # Convert to tensors
            X_train_t = torch.FloatTensor(X_train).to(self.device)
            y_train_t = torch.FloatTensor(y_train).to(self.device)
            X_val_t = torch.FloatTensor(X_val).to(self.device)
            y_val_t = torch.FloatTensor(y_val).to(self.device)

            # Create data loaders
            train_dataset = torch.utils.data.TensorDataset(X_train_t, y_train_t)
            train_loader = torch.utils.data.DataLoader(
                train_dataset, batch_size=batch_size, shuffle=True
            )

            # Optimizer and loss
            optimizer = torch.optim.Adam(self.model.parameters(), lr=learning_rate)
            criterion = nn.MSELoss()

            # Training loop
            self.model.train()
            best_val_loss = float('inf')

            for epoch in range(epochs):
                train_loss = 0.0
                for batch_X, batch_y in train_loader:
                    optimizer.zero_grad()
                    outputs = self.model(batch_X)
                    loss = criterion(outputs, batch_y)
                    loss.backward()
                    optimizer.step()
                    train_loss += loss.item()

                # Validation
                self.model.eval()
                with torch.no_grad():
                    val_outputs = self.model(X_val_t)
                    val_loss = criterion(val_outputs, y_val_t).item()

                self.model.train()

                if (epoch + 1) % 10 == 0:
                    logger.info(f"Epoch [{epoch+1}/{epochs}], Train Loss: {train_loss/len(train_loader):.4f}, Val Loss: {val_loss:.4f}")

                # Save best model
                if val_loss < best_val_loss:
                    best_val_loss = val_loss

            logger.info(f"Training completed. Best val loss: {best_val_loss:.4f}")

        def predict(self, X: np.ndarray) -> np.ndarray:
            """
            Predict personalized weights for students

            Args:
                X: Student features (n_students, input_dim)

            Returns:
                Predicted weights (n_students, 5)
            """
            self.model.eval()
            with torch.no_grad():
                X_tensor = torch.FloatTensor(X).to(self.device)
                weights = self.model(X_tensor)
                return weights.cpu().numpy()

        def save(self, path: str):
            """Save model to disk"""
            torch.save({
                'model_state_dict': self.model.state_dict(),
                'input_dim': self.input_dim
            }, path)
            logger.info(f"PersonalizedWeightNetwork saved to {path}")

        def load(self, path: str):
            """Load model from disk"""
            checkpoint = torch.load(path, map_location=self.device)
            self.model.load_state_dict(checkpoint['model_state_dict'])
            self.model.eval()
            logger.info(f"PersonalizedWeightNetwork loaded from {path}")
else:
    # Placeholder when PyTorch is not available
    PersonalizedWeightPredictor = None


class EnsembleRecommendationModel:
    """
    Ensemble model combining LightGBM ranker and personalized weights
    Provides both match score prediction and dimension-wise scoring
    """

    def __init__(self, feature_engineer):
        self.feature_engineer = feature_engineer
        self.lgb_ranker = LightGBMRanker()
        self.weight_predictor = None  # Optional personalized weights
        self.use_personalized_weights = False

    def train_ranker(
        self,
        students: List[Dict],
        universities: List[Dict],
        programs_by_university: Dict[int, List[Dict]],
        scores: np.ndarray
    ):
        """
        Train the LightGBM ranking model

        Args:
            students: List of student profiles
            universities: List of universities
            programs_by_university: Mapping of university_id to programs
            scores: Target match scores
        """
        logger.info("Preparing training data for LightGBM...")

        # Extract features for all student-university pairs
        features_list = []
        for i, student in enumerate(students):
            for j, university in enumerate(universities):
                programs = programs_by_university.get(university['id'], [])
                features = self.feature_engineer.create_feature_vector(
                    student, university, programs
                )
                features_list.append(features)

        X = np.array(features_list)
        y = scores.flatten()

        feature_names = self.feature_engineer.get_feature_names()

        # Train model
        self.lgb_ranker.train(X, y, feature_names)

    def predict_match_score(
        self,
        student: Dict,
        university: Dict,
        programs: List[Dict]
    ) -> float:
        """
        Predict match score for student-university pair

        Args:
            student: Student profile dict
            university: University dict
            programs: List of university programs

        Returns:
            Predicted match score (0-100)
        """
        features = self.feature_engineer.create_feature_vector(
            student, university, programs
        )
        features = features.reshape(1, -1)

        score = self.lgb_ranker.predict(features)[0]

        # Clip to 0-100 range
        return float(np.clip(score, 0, 100))

    def predict_batch(
        self,
        student: Dict,
        universities: List[Dict],
        programs_by_university: Dict[int, List[Dict]]
    ) -> np.ndarray:
        """
        Predict match scores for a student against multiple universities (batch processing)

        Args:
            student: Student profile dict
            universities: List of universities
            programs_by_university: Mapping of university_id to programs

        Returns:
            Array of predicted scores (n_universities,)
        """
        features_list = []
        for university in universities:
            programs = programs_by_university.get(university['id'], [])
            features = self.feature_engineer.create_feature_vector(
                student, university, programs
            )
            features_list.append(features)

        X = np.array(features_list)
        scores = self.lgb_ranker.predict(X)

        # Clip to 0-100 range
        return np.clip(scores, 0, 100)

    def save(self, model_dir: str):
        """Save all models to directory"""
        os.makedirs(model_dir, exist_ok=True)

        # Save LightGBM
        lgb_path = os.path.join(model_dir, 'lightgbm_ranker.txt')
        self.lgb_ranker.save(lgb_path)

        # Save feature engineer metadata
        metadata_path = os.path.join(model_dir, 'feature_metadata.pkl')
        metadata = {
            'feature_names': self.feature_engineer.get_feature_names()
        }
        joblib.dump(metadata, metadata_path)

        logger.info(f"Ensemble model saved to {model_dir}")

    def load(self, model_dir: str):
        """Load all models from directory"""
        # Load LightGBM
        lgb_path = os.path.join(model_dir, 'lightgbm_ranker.txt')
        self.lgb_ranker.load(lgb_path)

        logger.info(f"Ensemble model loaded from {model_dir}")
