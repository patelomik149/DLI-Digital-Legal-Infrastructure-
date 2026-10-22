# DLI Dashboard integration

The dashboard from `dli_dashboard` has been integrated into this app.

- The login/register/OTP flow is unchanged.
- The `/home` route now opens `DliDashboard` instead of the previous public landing page.
- Dashboard source files are under `lib/dashboard/`.
- The dashboard logo is at `assets/images/primary_logo.png` and is covered by the existing `assets/images/` asset declaration.

## Run
From this `dli_app` directory:
1. Run `flutter pub get`
2. Run `flutter run -d chrome` for web, or choose an available device.

The dashboard currently uses the sample/mock KYC repository included with the supplied dashboard ZIP. Connect it to your real API/database before relying on displayed application counts or KYC status.
