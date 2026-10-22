import 'package:flutter/material.dart';

import '../widgets/dli_loader.dart';
import '../../../app/app_routes.dart';

class LoaderPage extends StatelessWidget {
  const LoaderPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const DliLoader(
      // Initial application stage
      //
      // 0 = CONNECT
      // 1 = VERIFY
      // 2 = PROCESS
      // 3 = COMPLETE
      currentStage: 0,

      // Initial loader duration
      duration: Duration(seconds: 4),

      // After 4 seconds open the screen defined in AppRoutes.afterLoader
      // (Login by default).
      nextRoute: AppRoutes.afterLoader,
    );
  }
}

