import 'package:flutter/material.dart';

import 'core/theme.dart';
import 'models/kyc_models.dart';
import 'pages/dashboard_page.dart';
import 'pages/detail_pages.dart';
import 'pages/kyc_page.dart';
import 'pages/placeholder_page.dart';
import 'state/dash_state.dart';
import 'widgets/side_nav.dart';
import 'widgets/top_bar.dart';

/// Entry widget of the dashboard. Use it anywhere in your app, for example
/// after OTP verification:
///
///   Navigator.pushReplacement(context,
///       MaterialPageRoute(builder: (_) => DliDashboard(onLogout: () {...})));
class DliDashboard extends StatefulWidget {
  const DliDashboard({
    super.key,
    this.initialType = UserType.normal,
    this.repository = const MockKycRepository(),
    this.onLogout,
  });

  final UserType initialType;
  final KycRepository repository;
  final VoidCallback? onLogout;

  @override
  State<DliDashboard> createState() => _DliDashboardState();
}

class _DliDashboardState extends State<DliDashboard> {
  late final DashState _state = DashState(
    initialType: widget.initialType,
    repository: widget.repository,
    onLogout: widget.onLogout,
  );

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DashScope(state: _state, child: const _Shell());
  }
}

class _Shell extends StatelessWidget {
  const _Shell();

  Widget _body(DashState s) {
    switch (s.page) {
      case DashPage.dashboard:
        return const DashboardPage();
      case DashPage.kyc:
        return const KycPage();
      case DashPage.aadhaarDetails:
        return s.isOrganization ? const KycPage() : const AadhaarDetailsPage();
      case DashPage.panDetails:
        return const PanDetailsPage();
      case DashPage.allDetails:
      case DashPage.profile:
        return const AllDetailsPage();
      case DashPage.documents:
        return const PlaceholderPage(
          title: 'Documents',
          icon: Icons.description_outlined,
        );
      case DashPage.settings:
        return const PlaceholderPage(
          title: 'Settings',
          icon: Icons.settings_outlined,
        );
      case DashPage.help:
        return const PlaceholderPage(
          title: 'Help & Support',
          icon: Icons.headset_mic_outlined,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = DashScope.of(context);
    final wide = MediaQuery.sizeOf(context).width >= kWideBreakpoint;
    return Scaffold(
      backgroundColor: DashColors.bg,
      drawer: wide
          ? null
          : const Drawer(
              backgroundColor: DashColors.navy,
              child: SideNav(inDrawer: true),
            ),
      endDrawer: Drawer(
        width: MediaQuery.sizeOf(context).width < 400
            ? MediaQuery.sizeOf(context).width * 0.92
            : 360.0,
        backgroundColor: DashColors.bg,
        child: const SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(12),
            child: ProfilePanel(inDrawer: true),
          ),
        ),
      ),
      body: Column(
        children: [
          TopBar(showMenu: !wide),
          Expanded(
            child: Row(
              children: [
                if (wide)
                  const SizedBox(
                    width: 265,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(26),
                      ),
                      child: SideNav(),
                    ),
                  ),
                Expanded(
                  child: KeyedSubtree(
                    key: ValueKey<DashPage>(s.page),
                    child: _body(s),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
