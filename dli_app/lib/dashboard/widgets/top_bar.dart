import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../state/dash_state.dart';
import 'common.dart';

Future<void> confirmLogout(BuildContext context, DashState state) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Logout'),
      content: const Text('Are you sure you want to log out?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: const Text('Logout'),
        ),
      ],
    ),
  );
  if (ok == true) {
    if (state.onLogout != null) {
      state.onLogout!();
    } else if (context.mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Logout is not connected yet')),
        );
    }
  }
}

class TopBar extends StatelessWidget {
  const TopBar({super.key, required this.showMenu});

  final bool showMenu;

  @override
  Widget build(BuildContext context) {
    final s = DashScope.of(context);
    final w = MediaQuery.sizeOf(context).width;
    return Container(
      height: 72,
      padding: EdgeInsets.symmetric(horizontal: w >= 600 ? 28 : 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          if (showMenu)
            IconButton(
              icon: const Icon(Icons.menu_rounded, color: DashColors.heading),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          InkWell(
            onTap: () => s.go(DashPage.dashboard),
            child: const DliLogo(height: 58),
          ),
          const Spacer(),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: DashColors.heading,
                  size: 26,
                ),
                onPressed: () => ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(content: Text('No new notifications')),
                  ),
              ),
              Positioned(
                right: 10,
                top: 10,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: const BoxDecoration(
                    color: DashColors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: 1,
            height: 36,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            color: DashColors.border,
          ),
          InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () => Scaffold.of(context).openEndDrawer(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const UserAvatar(size: 40),
                if (w >= 520) ...[
                  const SizedBox(width: 10),
                  Text(
                    s.user.name,
                    style: const TextStyle(
                      color: DashColors.heading,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                ],
                const SizedBox(width: 4),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: DashColors.heading,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
