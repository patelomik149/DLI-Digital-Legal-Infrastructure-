# DLI Flutter + Flask Email & WhatsApp OTP Registration

This is the supplied Flutter DLI demo merged with the supplied Python email OTP and WhatsApp OTP logic.

## Registration flow

1. Flutter registration page validates mobile number, email and Terms & Conditions.
2. Flutter calls Flask `POST /api/register/start`.
3. Flask generates two 6-digit OTPs.
4. One OTP is sent by Gmail SMTP to the email address.
5. One OTP is sent by the supplied `piwapp` WhatsApp logic.
6. Flutter opens a combined OTP page.
7. The user enters both OTPs.
8. Flutter calls Flask `POST /api/register/verify`.
9. On success, a green success message is shown and the app opens the dashboard.

## Important: credentials

The merged archive intentionally does **not** contain the email `.env` credentials from the supplied project. Create `backend/.env` from `backend/.env.example` and enter your own Gmail app password and Flask secret.

The WhatsApp session files supplied with the number OTP project are included under `backend/whatsapp_session/`. Treat them as private credentials and do not upload them publicly.

## Backend setup on Windows

Open a terminal in `backend`:

```powershell
python -m venv venv
venv\\Scripts\\activate
pip install -r requirements.txt
copy .env.example .env
python app.py
```

Wait for the WhatsApp connection to become ready before requesting phone OTP.

Backend URL:

`http://127.0.0.1:5000`

## Flutter setup

Open a terminal in `dli_app`:

```powershell
flutter pub get
flutter run -d chrome
```

The Flutter API base URL is in:

`lib/services/api_service.dart`

For Flutter Web on the same PC it is already set to:

`http://127.0.0.1:5000/api`

For Android emulator, use `http://10.0.2.2:5000/api` instead.

## No PostgreSQL in this version

PostgreSQL is not required for this OTP demo. Pending OTPs are stored in Flask memory. Restarting Flask clears pending OTPs. PostgreSQL/Redis can be added later when you want to permanently save user registrations.

## Main files changed

- `dli_app/lib/services/api_service.dart` — Flutter → Flask API calls
- `dli_app/lib/modules/register/pages/register_page.dart` — registration validation + send OTP
- `dli_app/lib/modules/otp/features/auth/presentation/verify_registration_otp_screen.dart` — email + WhatsApp OTP page
- `dli_app/lib/app/app_routes.dart` — registration OTP route
- `dli_app/lib/app/app_router.dart` — registration OTP routing
- `dli_app/pubspec.yaml` — adds `http`
- `backend/app.py` — combined Flask API and supplied OTP logic
