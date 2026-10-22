# DLI KYC Dashboard Integration (SQLite3)

The Dashboard KYC menu now opens the Aadhaar/PAN flow from the `dli_kyc_user_types - 2- dummy otp` project. The existing FastAPI application and `backend/users.db` remain in place. Startup creates two KYC-specific tables in that same database: `kyc_aadhaar_attempts` and `kyc_records`. Existing user/login tables are not dropped or replaced.

## Local demo values

The mock API accepts only the configured test data. Defaults (overridable through the backend environment) are:

- Aadhaar test number: `999999999999`
- OTP: `123456`
- Individual PAN: `ZZZPX1234P`
- Organization PAN: `ZZZCX1234C`

These are fictional demo values. The API does not query UIDAI or the Income Tax Department, and returned names/addresses are fictional. Do not use real Aadhaar/PAN numbers in this mock mode.

## Run

1. Start the existing backend from `backend` using the same command you already use (typically `python app.py`). It listens on port `5000`.
2. From `dli_app`, run `flutter pub get`.
3. Run the Flutter app and open **Verify KYC** from the dashboard.
4. For a Normal User, complete Aadhaar + OTP first, then PAN. For Organization, choose Organization and complete PAN only.

The flow's API base URL can be overridden at build time with `--dart-define=KYC_API_BASE_URL=http://HOST:5000`. Android emulator defaults to `10.0.2.2:5000`; web defaults to `127.0.0.1:5000`.

## Notes

- KYC records are persisted in the existing SQLite file; the original registration/login flow is retained.
- The KYC process in this archive is a mock OTP/PAN flow, not production identity verification.
- The status endpoint is `GET /api/v1/kyc/status`. Because the existing dashboard login does not yet pass a stable user identifier into this KYC flow, account-specific KYC ownership should be wired before using it with real users.
