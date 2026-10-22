import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../state/dash_state.dart';

class _NavEntry {
  const _NavEntry(this.section, this.page, this.label, this.icon);

  final NavSection section;
  final DashPage page;
  final String label;
  final IconData icon;
}

const _entries = [
  _NavEntry(NavSection.dashboard, DashPage.dashboard, 'Dashboard',
      Icons.home_rounded),
  _NavEntry(NavSection.kyc, DashPage.kyc, 'KYC Verification',
      Icons.verified_user_outlined),
  _NavEntry(NavSection.documents, DashPage.documents, 'Documents',
      Icons.description_outlined),
  _NavEntry(NavSection.profile, DashPage.allDetails, 'My Profile',
      Icons.person_outline_rounded),
  _NavEntry(NavSection.settings, DashPage.settings, 'Settings',
      Icons.settings_outlined),
  _NavEntry(NavSection.help, DashPage.help, 'Help & Support',
      Icons.headset_mic_outlined),
];

class SideNav extends StatelessWidget {
  const SideNav({super.key, this.inDrawer = false});

  /// When shown inside the mobile drawer it closes itself after a tap.
  final bool inDrawer;

  @override
  Widget build(BuildContext context) {
    final s = DashScope.of(context);
    final content = LayoutBuilder(
      builder: (context, box) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: box.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 28),
                  for (final e in _entries)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
                      child: _NavItem(
                        entry: e,
                        active: s.section == e.section,
                        onTap: () {
                          s.go(e.page);
                          if (inDrawer) Navigator.of(context).pop();
                        },
                      ),
                    ),
                  Expanded(
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: CustomPaint(painter: _CircuitPainter()),
                        ),
                        const Positioned(
                          left: 0,
                          right: 0,
                          bottom: 18,
                          child: Text(
                            'Secure  •  Compliant  •  Digital',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFFBFDFF5),
                              fontSize: 12.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    return Container(
      color: DashColors.navy,
      child: content,
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.entry,
    required this.active,
    required this.onTap,
  });

  final _NavEntry entry;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active ? DashColors.navActive : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(entry.icon, color: Colors.white, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  entry.label,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Thin circuit-line decoration at the bottom of the sidebar.
class _CircuitPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    if (size.height < 110) return;
    final line = Paint()
      ..color = const Color(0xFF2A8FD0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final dot = Paint()
      ..color = const Color(0xFF2A8FD0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final bottom = size.height - 56;
    final top = bottom - 80;
    final w = size.width;

    final p = Path()
      ..moveTo(0, top)
      ..lineTo(w * 0.28, top)
      ..lineTo(w * 0.42, top + 32)
      ..lineTo(w * 0.42, top + 56)
      ..moveTo(w * 0.28, bottom)
      ..lineTo(w * 0.48, bottom)
      ..lineTo(w * 0.62, bottom - 28)
      ..lineTo(w * 0.62, top + 20);
    canvas.drawPath(p, line);
    canvas.drawCircle(Offset(w * 0.42, top + 62), 6, dot);
    canvas.drawCircle(Offset(w * 0.22, bottom), 6, dot);
    canvas.drawCircle(Offset(w * 0.64, top + 12), 6, dot);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
