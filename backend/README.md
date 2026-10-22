# DLI Flask OTP Backend

This backend exposes registration OTP APIs for the Flutter app and sends one OTP by email and one OTP through a linked WhatsApp Web session using piwapp.

## WhatsApp first-time setup

1. Install dependencies:
   `pip install -r requirements.txt`
2. Create `backend/.env` from `.env.example` and add your email sender + Gmail App Password.
3. Start the backend:
   `python app.py`
4. If a fresh login is required, the terminal prints a QR code and also writes `backend/piwapp_qr.png`.
5. On your phone open WhatsApp -> Linked devices -> Link a device and scan the QR.
6. Wait until the backend prints `WhatsApp connected successfully.`
7. Only then submit the Flutter registration form.

If the saved WhatsApp session has been rejected, the backend automatically starts a fresh QR login. You can also force a fresh login by setting `WHATSAPP_FRESH_LOGIN=true` in `.env` for one run. After scanning, set it back to `false` for future runs.

## APIs

- `POST /api/register/start` validates email/phone/terms, generates two OTPs, and sends them.
- `POST /api/register/verify` verifies both 6-digit OTPs.
- `POST /api/register/resend` resends both OTPs after cooldown.
- `GET /api/health` reports email configuration and WhatsApp connection state.

## Important

Do not publish WhatsApp session files or `.env` to GitHub. The OTP store is in memory for this demo; restarting Flask clears pending OTPs.
