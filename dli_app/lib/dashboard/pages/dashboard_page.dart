import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../models/kyc_models.dart';
import '../state/dash_state.dart';
import '../widgets/common.dart';
import '../widgets/top_bar.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        final pad = box.maxWidth >= 700 ? 32.0 : 16.0;
        return SingleChildScrollView(
          padding: EdgeInsets.all(pad),
          child: const _MainColumn(),
        );
      },
    );
  }
}

class _MainColumn extends StatelessWidget {
  const _MainColumn();

  @override
  Widget build(BuildContext context) {
    final s = DashScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Welcome Back,',
          style: TextStyle(
            color: DashColors.heading,
            fontSize: 26,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          s.user.name,
          style: const TextStyle(
            color: DashColors.accent,
            fontSize: 36,
            fontWeight: FontWeight.w700,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Here's your account overview and quick access to our services.",
          style: TextStyle(color: DashColors.muted, fontSize: 15),
        ),
        const SizedBox(height: 22),
        LayoutBuilder(
          builder: (context, box) {
            const gap = 16.0;
            final cols = box.maxWidth >= 720 ? 4 : 2;
            final itemWidth = (box.maxWidth - gap * (cols - 1)) / cols;
            final cards = <Widget>[
              const _StatCard(
                icon: Icons.person_outline_rounded,
                iconColor: Color(0xFF1E88E5),
                iconBg: DashColors.blueSoft,
                label: 'Total Applications',
                value: '2',
                footer: _TrendFooter(
                  icon: Icons.north_east_rounded,
                  text: '+1 this month',
                  color: DashColors.green,
                ),
              ),
              const _StatCard(
                icon: Icons.verified_user_outlined,
                iconColor: DashColors.green,
                iconBg: DashColors.greenSoft,
                label: 'KYC Verified',
                value: '1',
                footer: _TrendFooter(
                  icon: Icons.north_east_rounded,
                  text: '+1 this month',
                  color: DashColors.green,
                ),
              ),
              const _StatCard(
                icon: Icons.description_outlined,
                iconColor: DashColors.purple,
                iconBg: DashColors.purpleSoft,
                label: 'Pending Verification',
                value: '1',
                footer: _TrendFooter(
                  icon: Icons.arrow_forward_rounded,
                  text: '-0 this month',
                  color: DashColors.muted,
                ),
              ),
              const _StatCard(
                icon: Icons.access_time_rounded,
                iconColor: DashColors.orange,
                iconBg: DashColors.orangeSoft,
                label: 'Last Login',
                value: 'Today, 10:24 AM',
                footer: _TrendFooter(
                  icon: Icons.circle,
                  iconSize: 8,
                  text: 'Active',
                  color: DashColors.green,
                ),
              ),
            ];
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [
                for (final c in cards) SizedBox(width: itemWidth, child: c),
              ],
            );
          },
        ),
        const SizedBox(height: 22),
        LayoutBuilder(
          builder: (context, box) {
            final activity = _RecentActivity(items: s.activity);
            const secure = _SecureCard();
            if (box.maxWidth >= 760) {
              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: const [
                    Expanded(flex: 6, child: _RecentActivityHolder()),
                    SizedBox(width: 18),
                    Expanded(flex: 4, child: _SecureCard()),
                  ],
                ),
              );
            }
            return Column(
              children: [activity, const SizedBox(height: 18), secure],
            );
          },
        ),
      ],
    );
  }
}

class _RecentActivityHolder extends StatelessWidget {
  const _RecentActivityHolder();

  @override
  Widget build(BuildContext context) {
    return _RecentActivity(items: DashScope.of(context).activity);
  }
}

class _TrendFooter extends StatelessWidget {
  const _TrendFooter({
    required this.icon,
    required this.text,
    required this.color,
    this.iconSize = 15,
  });

  final IconData icon;
  final String text;
  final Color color;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: iconSize, color: color),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: color, fontSize: 13),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.value,
    required this.footer,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final String value;
  final Widget footer;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      padding: const EdgeInsets.all(18),
      radius: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 26),
          ),
          const SizedBox(height: 14),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: DashColors.heading,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: const TextStyle(
                color: DashColors.heading,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 10),
          footer,
        ],
      ),
    );
  }
}

class _RecentActivity extends StatelessWidget {
  const _RecentActivity({required this.items});

  final List<ActivityItem> items;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.history_rounded,
                  color: DashColors.primary, size: 24),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Recent Activity',
                  style: TextStyle(
                    color: DashColors.heading,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => showSoon(context, 'Activity history'),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('View All'),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward_rounded, size: 16),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 18, color: DashColors.border),
          for (var i = 0; i < items.length; i++) ...[
            _ActivityTile(item: items[i]),
            if (i != items.length - 1)
              const Divider(height: 1, color: DashColors.border),
          ],
        ],
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({required this.item});

  final ActivityItem item;

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color fg;
    Color bg;
    switch (item.kind) {
      case ActivityKind.done:
        icon = Icons.check_rounded;
        fg = Colors.white;
        bg = DashColors.green;
        break;
      case ActivityKind.aadhaar:
        icon = Icons.description_outlined;
        fg = DashColors.primary;
        bg = DashColors.blueSoft;
        break;
      case ActivityKind.pan:
        icon = Icons.schedule_rounded;
        fg = Colors.white;
        bg = DashColors.purple;
        break;
      case ActivityKind.profile:
        icon = Icons.description_outlined;
        fg = DashColors.primary;
        bg = DashColors.blueSoft;
        break;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            child: Icon(icon, color: fg, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    color: DashColors.heading,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.subtitle,
                  style: const TextStyle(
                    color: DashColors.muted,
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.time,
                style: const TextStyle(color: DashColors.muted, fontSize: 12),
              ),
              const SizedBox(height: 6),
              StatusChip(label: item.badge),
            ],
          ),
        ],
      ),
    );
  }
}

class _SecureCard extends StatelessWidget {
  const _SecureCard();

  @override
  Widget build(BuildContext context) {
    final s = DashScope.of(context);
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: DashColors.soft,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: DashColors.softBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Secure Your\nDigital Identity',
            style: TextStyle(
              color: DashColors.heading,
              fontSize: 21,
              fontWeight: FontWeight.w700,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Complete your KYC verification\nto access all services.',
            style: TextStyle(color: DashColors.muted, fontSize: 14, height: 1.4),
          ),
          const SizedBox(height: 14),
          const Center(child: _ShieldIllustration()),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => s.go(DashPage.kyc),
              style: ElevatedButton.styleFrom(
                backgroundColor: DashColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Verify KYC'),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_rounded, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Simple shield + ID-card illustration built from widgets (no image asset).
class _ShieldIllustration extends StatelessWidget {
  const _ShieldIllustration();

  Widget _miniCard(IconData icon) {
    return Container(
      width: 54,
      height: 62,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: Color(0x1A0B6BA6), blurRadius: 10),
        ],
      ),
      child: Icon(icon, color: const Color(0xFF3FA2E0), size: 28),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: 230,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 4,
            bottom: 12,
            child: _miniCard(Icons.person_outline_rounded),
          ),
          Positioned(
            right: 4,
            top: 6,
            child: _miniCard(Icons.badge_outlined),
          ),
          const Icon(Icons.shield, size: 128, color: Color(0xFF0B7AC2)),
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Icon(Icons.check_rounded, size: 52, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

/// Right hand profile card: avatar, user type and quick links.
class ProfilePanel extends StatelessWidget {
  const ProfilePanel({super.key, this.inDrawer = false});

  /// Shown inside the right-side drawer; closes it after an item is tapped.
  final bool inDrawer;

  @override
  Widget build(BuildContext context) {
    final s = DashScope.of(context);
    final user = s.user;
    void act(VoidCallback f) {
      f();
      if (inDrawer && context.mounted) Navigator.of(context).pop();
    }

    return SoftCard(
      padding: const EdgeInsets.all(14),
      radius: 20,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 16),
            decoration: BoxDecoration(
              color: DashColors.soft,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const UserAvatar(size: 96),
                    Positioned(
                      right: -2,
                      bottom: 2,
                      child: InkWell(
                        onTap: () => showSoon(context, 'Photo upload'),
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: DashColors.navActive,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.photo_camera_rounded,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  user.name,
                  style: const TextStyle(
                    color: DashColors.heading,
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: const TextStyle(color: DashColors.muted, fontSize: 14),
                ),
                const SizedBox(height: 10),
                StatusChip(label: user.type.label, kind: ChipKind.blue),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _PanelItem(
            icon: Icons.person_outline_rounded,
            label: 'View Profile',
            onTap: () => act(() => s.go(DashPage.allDetails)),
          ),
          _PanelItem(
            icon: Icons.edit_note_rounded,
            label: 'Update Details',
            onTap: () => act(() => showSoon(context, 'Update details')),
          ),
          _PanelItem(
            icon: Icons.verified_user_outlined,
            label: 'Verify KYC',
            highlighted: true,
            onTap: () => act(() => s.go(DashPage.kyc)),
          ),
          _PanelItem(
            icon: Icons.lock_outline_rounded,
            label: 'Change Password',
            onTap: () => act(() => showSoon(context, 'Change password')),
          ),
          _PanelItem(
            icon: Icons.logout_rounded,
            label: 'Logout',
            showChevron: false,
            onTap: () async {
              await confirmLogout(context, s);
              if (inDrawer && context.mounted) Navigator.of(context).pop();
            },
          ),
          if (inDrawer)
            TextButton(
              onPressed: () => act(() => s.switchType(
                    s.isOrganization ? UserType.normal : UserType.organization,
                  )),
              child: Text(
                s.isOrganization
                    ? 'Demo: switch to Normal User'
                    : 'Demo: switch to Organization',
                style: const TextStyle(fontSize: 12.5),
              ),
            ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: DashColors.border),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Icon(Icons.verified_user_outlined,
                    color: DashColors.primary, size: 30),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your security\nis our priority',
                        style: TextStyle(
                          color: DashColors.primary,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'We use industry-standard security measures to protect your data.',
                        style: TextStyle(
                          color: DashColors.muted,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ],
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

class _PanelItem extends StatelessWidget {
  const _PanelItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.highlighted = false,
    this.showChevron = true,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool highlighted;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final color = highlighted ? DashColors.primary : DashColors.heading;
    return Material(
      color: highlighted ? DashColors.soft : Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 15.5,
                    fontWeight: highlighted ? FontWeight.w500 : FontWeight.w400,
                  ),
                ),
              ),
              if (showChevron)
                Icon(Icons.chevron_right_rounded, color: color, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}
