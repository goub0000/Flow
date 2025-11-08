# Find Your Path - College Recommendation API

## 🚀 Quick Deploy to Railway

This API is **100% cloud-ready** and can be deployed to Railway in under 5 minutes.

### ✅ System Status

- **Database**: Supabase (Cloud PostgreSQL) ✅
- **Local Dependencies**: None ✅
- **Railway Configuration**: Complete ✅
- **Environment Variables**: Configured ✅
- **Health Checks**: Enabled ✅

## 🎯 One-Click Deploy

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/new/template)

### Quick Start

1. **Fork/Clone this repository**
2. **Connect to Railway**:
   ```bash
   # Option 1: GitHub Integration (Recommended)
   - Push to GitHub
   - Go to railway.app/dashboard
   - Click "New Project" → "Deploy from GitHub"

   # Option 2: Railway CLI
   railway login
   railway init
   railway up
   ```

3. **Set Environment Variables** (in Railway dashboard):
   ```bash
   SUPABASE_URL=https://wmuarotbdjhqbyjyslqg.supabase.co
   SUPABASE_KEY=your_service_role_key
   ALLOWED_ORIGINS=https://your-app.railway.app
   ```

4. **Deploy!** Railway will automatically build and deploy.

## 📚 Full Documentation

See [RAILWAY_DEPLOYMENT.md](./RAILWAY_DEPLOYMENT.md) for complete deployment guide including:
- Detailed deployment steps
- Environment variable configuration
- Custom domain setup
- Monitoring and logs
- Troubleshooting
- Scaling options

## 🏗️ Architecture

```
Railway (FastAPI) → Supabase (PostgreSQL)
     ↓
17,137+ Universities
60+ Countries
Multi-Factor Recommendation Algorithm
```

## 🔗 API Endpoints

Once deployed, access your API at: `https://your-app.railway.app`

- `GET /` - API info
- `GET /health` - Health check
- `GET /docs` - Interactive API documentation (Swagger UI)
- `POST /api/v1/recommendations/generate` - Generate recommendations
- `GET /api/v1/universities` - Search universities
- `POST /api/v1/students/profile` - Create/update student profile

## 🛠️ Tech Stack

- **Backend**: FastAPI (Python 3.9+)
- **Database**: Supabase (PostgreSQL)
- **Hosting**: Railway
- **APIs**: College Scorecard, Universities List, QS Rankings

## 📊 Features

- 🎓 17,137+ university database (60+ countries)
- 🤖 5-factor recommendation algorithm
- 📈 Safety/Match/Reach categorization
- 💰 Financial fit scoring
- 📍 Location preferences
- 🏫 Program matching
- ⭐ Favorites and notes

## 🔧 Local Development

```bash
# Install dependencies
pip install -r requirements.txt

# Copy environment file
cp .env.example .env

# Edit .env with your Supabase credentials

# Run locally
uvicorn app.main:app --reload

# Access at http://localhost:8000
```

## 📈 Monitoring

Railway provides built-in monitoring:
- Request logs
- CPU/Memory usage
- Response times
- Error rates

Access via Railway Dashboard → Metrics

## 🆘 Support

- **Deployment Issues**: See [RAILWAY_DEPLOYMENT.md](./RAILWAY_DEPLOYMENT.md)
- **Supabase Setup**: See [SUPABASE_SETUP.md](./SUPABASE_SETUP.md)
- **API Documentation**: Access `/docs` endpoint after deployment

## 📝 License

MIT License - See LICENSE file

---

**Ready to deploy?** Follow the [Quick Start](#quick-start) above! 🚀
