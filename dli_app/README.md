# DLI App (UI only)

Combined Flutter project: **Loader -> Login / Register -> OTP verification (Mobile & Email) -> Dashboard**.
UI only - every place that needs the backend is marked `// TODO: call ... API`.

## Run

```bash
flutter pub get
flutter run -d chrome        # web
flutter run                  # mobile / desktop
```

Google Fonts (Poppins, Inter) are downloaded at runtime, so the first launch needs internet.

## Flow

```
Loader (4 s) -> Login --(mobile number)--> Verify OTP --> Dashboard
                  |     --(email address)-> Verify OTP --> Dashboard   (same URL: /auth/verify-otp)
                  |
                  +--> Register --> Login
```

* The OTP screen shows the mobile number or the e-mail in the "OTP sent to" card,
  depending on what the user entered at login.
* Route names, route arguments and the start-up target: `lib/app/app_routes.dart`
  (`AppRoutes.afterLoader` = screen shown after the loader; `login` by default, set it to `register` if you prefer).
* Route table + per-page theme: `lib/app/app_router.dart`

## Structure

```
lib/
  main.dart
  app/                 routes, router, MaterialApp
  modules/
    login/             login page + dashboard        (Poppins theme, login palette)
    otp/               verify OTP - mobile and email (Inter theme, OTP palette)
    register/          loader + register page        (own colours, Poppins)
assets/images/         primary_logo.png (shared logo), login_hero.jpg
```

The three parts were designed with different themes/palettes, so each module keeps its own
`AppColors` / `AppTheme` and the router wraps every page in its module's theme. This is why all
pages look exactly like the originals. Do not merge the theme files unless you want to restyle.
