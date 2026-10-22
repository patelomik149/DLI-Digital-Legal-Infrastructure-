import 'package:flutter/material.dart';

import 'app_router.dart';
import 'app_routes.dart';

class DliApp extends StatelessWidget {
  const DliApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DLI - Digital Legal Infrastructure',
      debugShowCheckedModeBanner: false,
      // Each page applies its own theme (see AppRouter).
      theme: ThemeData(useMaterial3: true),
      initialRoute: AppRoutes.loader,
      onGenerateRoute: AppRouter.onGenerateRoute,
      // Open exactly ONE page at start-up. Without this, Flutter web would
      // also stack "/" (the loader) and "/auth" under a deep link such as
      // /auth/register after a browser refresh.
      onGenerateInitialRoutes: (String initialRoute) => <Route<dynamic>>[
        AppRouter.onGenerateRoute(RouteSettings(name: initialRoute)),
      ],
    );
  }
}
