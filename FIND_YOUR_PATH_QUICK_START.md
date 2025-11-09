# Find Your Path - Quick Start Guide
## Setting Up the Separate Microservice

---

## 🚀 Quick Overview

This guide will help you quickly set up the **Find Your Path recommendation service** as a **separate microservice** from the main Flutter app.

**Architecture:**
```
Flutter App → REST API → Python Backend Service → Database
```

**Why Separate?**
- Heavy ML computations don't affect Flutter app
- Can scale independently
- Use Python's rich ML ecosystem
- Easy to maintain and update

---

## 📁 Project Structure

### Separate Repository Structure
```
find-your-path-service/              # Separate Git repo
├── app/
│   ├── __init__.py
│   ├── main.py                      # FastAPI entry point
│   ├── config.py                    # Configuration
│   ├── models/
│   │   ├── student.py               # Student profile models
│   │   ├── university.py            # University models
│   │   └── recommendation.py        # Recommendation models
│   ├── routers/
│   │   ├── recommendations.py       # /api/v1/recommend
│   │   ├── universities.py          # /api/v1/universities
│   │   └── profiles.py              # /api/v1/profiles
│   ├── services/
│   │   ├── matching_engine.py       # Core algorithm
│   │   ├── ml_model.py              # ML predictions
│   │   └── data_mining.py           # Scraping service
│   ├── database/
│   │   ├── session.py               # DB connection
│   │   ├── models.py                # SQLAlchemy models
│   │   └── migrations/              # Alembic migrations
│   └── utils/
│       ├── validators.py
│       └── helpers.py
├── scrapers/
│   ├── university_spider.py         # Scrapy spiders
│   ├── ranking_spider.py
│   └── pipelines.py
├── ml/
│   ├── train_model.py               # Model training
│   ├── feature_engineering.py
│   └── model_evaluation.py
├── tests/
│   ├── test_api.py
│   ├── test_matching.py
│   └── test_scrapers.py
├── data/
│   ├── seed_universities.json       # Initial data
│   └── sample_profiles.json
├── docker/
│   ├── Dockerfile
│   ├── docker-compose.yml
│   └── nginx.conf
├── requirements.txt
├── .env.example
├── README.md
└── pyproject.toml
```

---

## ⚙️ Setup Instructions

### 1. Create New Repository

```bash
# Create new repo (separate from Flutter app)
mkdir find-your-path-service
cd find-your-path-service
git init
```

### 2. Set Up Python Environment

```bash
# Create virtual environment
python -m venv venv

# Activate (Linux/Mac)
source venv/bin/activate

# Activate (Windows)
venv\Scripts\activate

# Install dependencies
pip install fastapi uvicorn sqlalchemy psycopg2-binary \
    pydantic python-dotenv redis scrapy \
    scikit-learn pandas numpy
```

### 3. Create requirements.txt

```txt
# Web Framework
fastapi==0.109.0
uvicorn[standard]==0.26.0
python-multipart==0.0.6

# Database
sqlalchemy==2.0.25
psycopg2-binary==2.9.9
alembic==1.13.1

# Caching & Queue
redis==5.0.1
celery==5.3.6

# Data Processing
pandas==2.1.4
numpy==1.26.3

# ML/AI
scikit-learn==1.4.0
tensorflow==2.15.0  # Optional for advanced ML

# Web Scraping
scrapy==2.11.0
beautifulsoup4==4.12.3
selenium==4.16.0

# Utilities
python-dotenv==1.0.0
pydantic==2.5.3
requests==2.31.0

# Testing
pytest==7.4.4
pytest-asyncio==0.23.3
httpx==0.26.0

# Monitoring
prometheus-client==0.19.0
sentry-sdk==1.39.2
```

### 4. Set Up Configuration

**`.env.example`:**
```bash
# API Configuration
API_HOST=0.0.0.0
API_PORT=8000
DEBUG=True

# Database
DATABASE_URL=postgresql://user:password@localhost:5432/findyourpath
DB_ECHO=False

# Redis Cache
REDIS_URL=redis://localhost:6379/0

# Security
SECRET_KEY=your-secret-key-here
JWT_ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30

# External APIs
QS_RANKINGS_API_KEY=your-key-here
GOOGLE_PLACES_API_KEY=your-key-here

# Scraping
USER_AGENT=FindYourPath-Bot/1.0
SCRAPING_RATE_LIMIT=2  # requests per second

# ML Model
MODEL_PATH=./ml/models/recommendation_model.pkl
MODEL_VERSION=v1.0

# Monitoring
SENTRY_DSN=your-sentry-dsn
ENVIRONMENT=development
```

### 5. Create Basic FastAPI App

**`app/main.py`:**
```python
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.routers import recommendations, universities, profiles
from app.config import settings

app = FastAPI(
    title="Find Your Path API",
    description="University Recommendation Service",
    version="1.0.0"
)

# CORS - Allow Flutter app to call this API
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:8080", "https://yourdomain.com"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(recommendations.router, prefix="/api/v1", tags=["Recommendations"])
app.include_router(universities.router, prefix="/api/v1", tags=["Universities"])
app.include_router(profiles.router, prefix="/api/v1", tags=["Profiles"])

@app.get("/")
def root():
    return {"message": "Find Your Path API v1.0", "status": "running"}

@app.get("/health")
def health_check():
    return {"status": "healthy", "version": "1.0.0"}
```

**`app/routers/recommendations.py`:**
```python
from fastapi import APIRouter, HTTPException
from typing import List
from app.models.student import StudentProfile
from app.models.recommendation import UniversityMatch
from app.services.matching_engine import MatchingEngine

router = APIRouter()
matcher = MatchingEngine()

@router.post("/recommend", response_model=List[UniversityMatch])
async def get_recommendations(profile: StudentProfile):
    """
    Get university recommendations based on student profile
    """
    try:
        matches = await matcher.find_matches(profile)
        return matches
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
```

**`app/services/matching_engine.py`:**
```python
from typing import List
from app.models.student import StudentProfile
from app.models.recommendation import UniversityMatch
from app.database.session import get_db
from sqlalchemy import select

class MatchingEngine:
    """
    Core matching algorithm
    """

    async def find_matches(
        self,
        profile: StudentProfile
    ) -> List[UniversityMatch]:
        """
        Find matching universities for student profile
        """
        # Simple rule-based matching for MVP
        universities = await self._get_all_universities()
        matches = []

        for uni in universities:
            score = self._calculate_match_score(profile, uni)
            if score >= 50:  # Minimum threshold
                matches.append(
                    UniversityMatch(
                        university_id=uni.id,
                        university_name=uni.name,
                        match_score=score,
                        fit_category=self._categorize_fit(score),
                        reasons=self._generate_reasons(profile, uni)
                    )
                )

        # Sort by score, return top 15
        matches.sort(key=lambda x: x.match_score, reverse=True)
        return matches[:15]

    def _calculate_match_score(self, profile, university) -> float:
        """
        Calculate match score (0-100)
        """
        score = 0.0

        # Academic fit (40%)
        if profile.gpa >= university.avg_gpa - 0.2:
            academic_match = min(
                100,
                (profile.gpa / university.avg_gpa) * 100
            )
            score += academic_match * 0.4

        # Financial fit (25%)
        if profile.budget >= university.tuition:
            score += 25
        elif university.financial_aid_available:
            score += 15

        # Location preference (15%)
        if university.country in profile.preferred_countries:
            score += 15

        # Program availability (20%)
        if profile.major in university.programs:
            score += 20

        return round(score, 2)

    def _categorize_fit(self, score: float) -> str:
        """
        Categorize fit: safety, match, or reach
        """
        if score >= 80:
            return "safety"
        elif score >= 60:
            return "match"
        else:
            return "reach"
```

### 6. Set Up Database

**Install PostgreSQL:**
```bash
# Mac
brew install postgresql@15

# Ubuntu
sudo apt-get install postgresql-15

# Windows
# Download from https://www.postgresql.org/download/
```

**Create Database:**
```bash
psql -U postgres
CREATE DATABASE findyourpath;
\q
```

**Database Models (`app/database/models.py`):**
```python
from sqlalchemy import Column, String, Integer, Float, JSON, DateTime
from sqlalchemy.ext.declarative import declarative_base
from datetime import datetime
import uuid

Base = declarative_base()

class University(Base):
    __tablename__ = "universities"

    id = Column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    name = Column(String, nullable=False)
    country = Column(String, nullable=False)
    city = Column(String)
    type = Column(String)  # Public, Private
    rankings = Column(JSON)
    programs = Column(JSON)
    admissions = Column(JSON)
    financials = Column(JSON)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
```

**Run Migrations:**
```bash
# Initialize Alembic
alembic init alembic

# Create first migration
alembic revision --autogenerate -m "Initial migration"

# Run migration
alembic upgrade head
```

### 7. Seed Initial Data

**`data/seed_universities.json`:**
```json
[
  {
    "name": "Massachusetts Institute of Technology",
    "country": "United States",
    "city": "Cambridge",
    "state": "MA",
    "type": "Private",
    "rankings": {
      "qs_world": 1,
      "us_news": 2
    },
    "programs": ["Computer Science", "Engineering", "Business"],
    "admissions": {
      "acceptance_rate": 0.04,
      "avg_gpa": 4.0,
      "avg_sat": 1540
    },
    "financials": {
      "tuition": 55000,
      "financial_aid_available": true
    }
  }
]
```

**Seed Script:**
```python
# scripts/seed_data.py
import json
from app.database.session import SessionLocal
from app.database.models import University

def seed_universities():
    db = SessionLocal()

    with open('data/seed_universities.json', 'r') as f:
        universities = json.load(f)

    for uni_data in universities:
        uni = University(**uni_data)
        db.add(uni)

    db.commit()
    print(f"Seeded {len(universities)} universities")

if __name__ == "__main__":
    seed_universities()
```

### 8. Run Development Server

```bash
# Start PostgreSQL
brew services start postgresql@15  # Mac
sudo service postgresql start      # Linux

# Start Redis (for caching)
brew services start redis          # Mac
sudo service redis-server start    # Linux

# Run FastAPI
uvicorn app.main:app --reload --port 8000

# API available at: http://localhost:8000
# Docs available at: http://localhost:8000/docs
```

---

## 🔌 Flutter Integration

### 1. Add to Flutter App

**`lib/config/api_config.dart`:**
```dart
class ApiConfig {
  static const String findYourPathBaseUrl =
      'http://localhost:8000/api/v1';  // Development
      // 'https://api.flowedtech.com/find-your-path/v1';  // Production
}
```

**`lib/features/find_your_path/data/services/recommendation_api_service.dart`:**
```dart
import 'package:dio/dio.dart';
import '../../domain/models/student_profile.dart';
import '../../domain/models/university_match.dart';
import '../../../../config/api_config.dart';

class RecommendationApiService {
  final Dio _dio;

  RecommendationApiService(this._dio);

  Future<List<UniversityMatch>> getRecommendations(
    StudentProfile profile,
  ) async {
    try {
      final response = await _dio.post(
        '${ApiConfig.findYourPathBaseUrl}/recommend',
        data: profile.toJson(),
      );

      return (response.data as List)
          .map((json) => UniversityMatch.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to get recommendations: $e');
    }
  }
}
```

### 2. Test Integration

```dart
// Test in Flutter app
final service = RecommendationApiService(Dio());
final profile = StudentProfile(
  gpa: 3.8,
  major: 'Computer Science',
  preferredCountries: ['United States'],
  budget: 50000,
);

final matches = await service.getRecommendations(profile);
print('Found ${matches.length} matches');
```

---

## 🐳 Docker Setup (Optional)

**`docker/Dockerfile`:**
```dockerfile
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

**`docker-compose.yml`:**
```yaml
version: '3.8'

services:
  api:
    build:
      context: .
      dockerfile: docker/Dockerfile
    ports:
      - "8000:8000"
    environment:
      - DATABASE_URL=postgresql://postgres:password@db:5432/findyourpath
      - REDIS_URL=redis://redis:6379/0
    depends_on:
      - db
      - redis

  db:
    image: postgres:15
    environment:
      - POSTGRES_DB=findyourpath
      - POSTGRES_PASSWORD=password
    volumes:
      - postgres_data:/var/lib/postgresql/data

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"

volumes:
  postgres_data:
```

**Run with Docker:**
```bash
docker-compose up -d
```

---

## 📊 Testing the Service

### Manual Testing (Postman/curl)

```bash
# Test health endpoint
curl http://localhost:8000/health

# Test recommendation endpoint
curl -X POST http://localhost:8000/api/v1/recommend \
  -H "Content-Type: application/json" \
  -d '{
    "gpa": 3.8,
    "major": "Computer Science",
    "preferred_countries": ["United States"],
    "budget": 50000
  }'
```

### Automated Testing

**`tests/test_api.py`:**
```python
import pytest
from httpx import AsyncClient
from app.main import app

@pytest.mark.asyncio
async def test_recommend_endpoint():
    async with AsyncClient(app=app, base_url="http://test") as client:
        response = await client.post("/api/v1/recommend", json={
            "gpa": 3.8,
            "major": "Computer Science",
            "preferred_countries": ["United States"],
            "budget": 50000
        })
        assert response.status_code == 200
        data = response.json()
        assert len(data) > 0
        assert "university_name" in data[0]
```

Run tests:
```bash
pytest tests/
```

---

## 🚀 Deployment

### Deploy to Heroku (Quick)

```bash
# Login to Heroku
heroku login

# Create app
heroku create find-your-path-api

# Add PostgreSQL
heroku addons:create heroku-postgresql:mini

# Add Redis
heroku addons:create heroku-redis:mini

# Set config
heroku config:set SECRET_KEY=your-secret-key

# Deploy
git push heroku main

# Check logs
heroku logs --tail
```

### Deploy to AWS (Production)

See full deployment guide in main implementation plan.

---

## 📝 Next Steps

After basic setup:

1. **Add More Universities** - Expand from 10 to 50+ manually
2. **Improve Algorithm** - Refine matching logic
3. **Build Flutter UI** - Create questionnaire screens
4. **Add Web Scraping** - Automate data collection
5. **Implement ML** - Train recommendation model
6. **Add Monitoring** - Set up logging and alerts

---

## 🆘 Troubleshooting

**Issue:** Can't connect to database
```bash
# Check PostgreSQL is running
pg_isready

# Check connection string
echo $DATABASE_URL
```

**Issue:** CORS errors from Flutter
```python
# In app/main.py, add Flutter dev URL
allow_origins=["http://localhost:8080"]
```

**Issue:** Slow recommendations
```python
# Add Redis caching
from fastapi_cache import FastAPICache
from fastapi_cache.backends.redis import RedisBackend

@app.on_event("startup")
async def startup():
    redis = await aioredis.from_url("redis://localhost")
    FastAPICache.init(RedisBackend(redis), prefix="fastapi-cache")
```

---

## 📚 Resources

- **FastAPI Docs:** https://fastapi.tiangolo.com
- **PostgreSQL Tutorial:** https://www.postgresqltutorial.com
- **Scrapy Docs:** https://docs.scrapy.org
- **Full Implementation Plan:** `FIND_YOUR_PATH_IMPLEMENTATION_PLAN.md`

---

## ✅ Checklist

- [ ] Repository created and initialized
- [ ] Python environment set up
- [ ] Dependencies installed
- [ ] Database created and migrated
- [ ] Initial data seeded
- [ ] API server running
- [ ] Flutter integration working
- [ ] Basic tests passing
- [ ] Docker setup complete (optional)
- [ ] Deployed to staging (optional)

**Time to Complete:** 1-2 days for basic setup

---

**Ready to start building!** 🚀
