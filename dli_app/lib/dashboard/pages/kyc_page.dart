import 'package:flutter/material.dart';

import '../../kyc_flow/app_router.dart' as flow_router;
import '../../kyc_flow/core/kyc_data.dart' as flow;
import '../../kyc_flow/core/route_names.dart' as flow_routes;
import '../../kyc_flow/core/theme.dart' as flow_theme;
import '../models/kyc_models.dart';
import '../state/dash_state.dart';

/// Integrates the separate Aadhaar/PAN process into the existing dashboard.
class KycPage extends StatelessWidget {
  const KycPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboard = DashScope.of(context);
    return _KycFlowApp(
      key: ValueKey(dashboard.userType),
      initialType: dashboard.userType,
      onExit: () => dashboard.go(DashPage.dashboard),
    );
  }
}

class _KycFlowApp extends StatefulWidget {
  const _KycFlowApp({super.key, required this.initialType, required this.onExit});
  final UserType initialType;
  final VoidCallback onExit;

  @override
  State<_KycFlowApp> createState() => _KycFlowAppState();
}

class _KycFlowAppState extends State<_KycFlowApp> {
  @override
  void initState() {
    super.initState();
    flow.KycData.userType = widget.initialType == UserType.organization
        ? flow.UserType.organization
        : flow.UserType.normal;
    flow.KycData.reset();
    flow.KycData.onExitToDashboard = widget.onExit;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DLI KYC Verification',
      debugShowCheckedModeBanner: false,
      theme: flow_theme.buildTheme(),
      initialRoute: flow_routes.R.home,
      onGenerateRoute: flow_router.onGenerateRoute,
      onUnknownRoute: (_) => flow_router.onGenerateRoute(
        const RouteSettings(name: flow_routes.R.home),
      ),
    );
  }
}
