# DLI Backend - FastAPI Migration

This project keeps the existing Flutter frontend and SQLite database unchanged.

## Backend
- Framework: FastAPI
- Server: Uvicorn
- Port: 5000
- Existing API paths are preserved under `/api`.

## API endpoints
- GET `/api/health`
- POST `/api/register/start`
- POST `/api/register/verify`
- POST `/api/register/resend`
- POST `/api/login/start`
- POST `/api/login/verify`
- POST `/api/login/resend`

## Database
The existing `users.db` SQLite file and its existing tables are preserved as-is.

## Run

Open a terminal in `backend`:

```powershell
python -m pip install -r requirements.txt
python app.py
```

FastAPI will be available at:
`http://127.0.0.1:5000`

Swagger documentation:
`http://127.0.0.1:5000/docs`

## Important
The original Flask backend is preserved as `app_flask_backup.py` for rollback/reference.

Flutter API code was intentionally not changed because the FastAPI backend preserves the existing `/api` contract and port.
