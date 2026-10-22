import 'package:flutter/material.dart';

import '../../../../../app/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/presentation/widgets/dli_logo.dart';
import 'widgets/dashboard_footer.dart';
import 'widgets/feature_grid.dart';
import 'widgets/hero_section.dart';
import 'widgets/stats_strip.dart';

const _navItems = ['Home', 'Services', 'About', 'Contact'];

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key, this.userName = 'DLI'});

  final String userName;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  static const _wideBreakpoint = 900.0;
  int _selected = 0;

  void _select(int i) {
    setState(() => _selected = i);
    // TODO: open the real Services / About / Contact pages.
  }

  void _logout() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.login,
      (route) => false,
    );
  }

  void _comingSoon(String what) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$what is coming soon')));
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= _wideBreakpoint;

    return Scaffold(
      backgroundColor: AppColors.dashboardBg,
      drawer: wide ? null : _drawer(),
      appBar: AppBar(
        toolbarHeight: 72,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        shape: const Border(bottom: BorderSide(color: AppColors.border)),
        iconTheme: const IconThemeData(color: AppColors.navy),
        titleSpacing: wide ? 32 : 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const DliLogo(height: 46, trimmed: true),
            if (wide) ...[
              const SizedBox(width: 56),
              for (var i = 0; i < _navItems.length; i++)
                _NavLink(
                  label: _navItems[i],
                  selected: i == _selected,
                  onTap: () => _select(i),
                ),
            ],
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Notifications',
            onPressed: () => _comingSoon('Notifications'),
            icon: const Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(Icons.notifications_none, color: AppColors.navy, size: 26),
                Positioned(
                  right: 1,
                  top: 1,
                  child: CircleAvatar(radius: 4, backgroundColor: AppColors.error),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            tooltip: 'Account',
            offset: const Offset(0, 48),
            onSelected: (v) => v == 'logout' ? _logout() : _comingSoon('Profile'),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'profile', child: Text('View Profile')),
              PopupMenuItem(value: 'logout', child: Text('Log out')),
            ],
            child: const CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.navy,
              child: Icon(Icons.person, color: Colors.white),
            ),
          ),
          SizedBox(width: wide ? 32 : 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(wide ? 32 : 20, 32, wide ? 32 : 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeroSection(
                        userName: widget.userName,
                        wide: wide,
                        onGetStarted: () => _comingSoon('Get Started'),
                      ),
                      const SizedBox(height: 40),
                      FeatureGrid(onTap: _comingSoon),
                      const SizedBox(height: 24),
                      const StatsStrip(),
                    ],
                  ),
                ),
              ),
            ),
            DashboardFooter(items: _navItems, wide: wide),
          ],
        ),
      ),
    );
  }

  Drawer _drawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: DliLogo(height: 52, trimmed: true),
              ),
            ),
            for (var i = 0; i < _navItems.length; i++)
              ListTile(
                title: Text(
                  _navItems[i],
                  style: TextStyle(
                    color: i == _selected ? AppColors.primary : AppColors.navy,
                    fontWeight: i == _selected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
                selected: i == _selected,
                onTap: () {
                  Navigator.of(context).pop();
                  _select(i);
                },
              ),
            const Divider(color: AppColors.border),
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.navy),
              title: const Text('Log out'),
              onTap: _logout,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  const _NavLink({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selected ? AppColors.primary : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            color: selected ? AppColors.primary : AppColors.navy,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
