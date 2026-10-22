import 'package:flutter/material.dart';

import '../core/theme.dart';

/// DLI logo. The asset is shown unchanged; only the empty white margin around
/// the wordmark is cropped visually (the image file itself is not modified).
class DliLogo extends StatelessWidget {
  const DliLogo({super.key, this.height = 56});

  /// Visible height of the logo area.
  final double height;

  @override
  Widget build(BuildContext context) {
    const heightFactor = 0.56;
    const widthFactor = 0.64;
    final full = height / heightFactor;
    return ClipRect(
      child: Align(
        alignment: Alignment.center,
        widthFactor: widthFactor,
        heightFactor: heightFactor,
        child: Image.asset(
          'assets/images/primary_logo.png',
          height: full,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class SoftCard extends StatelessWidget {
  const SoftCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.color = Colors.white,
    this.radius = 18,
    this.borderColor = DashColors.border,
  });

  final Widget child;
  final EdgeInsets padding;
  final Color color;
  final double radius;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F0B2C5C),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

enum ChipKind { green, orange, blue, purple }

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.label, this.kind});

  final String label;
  final ChipKind? kind;

  ChipKind get _kind {
    if (kind != null) return kind!;
    switch (label) {
      case 'Completed':
      case 'Verified':
      case 'Active':
        return ChipKind.green;
      case 'Pending':
        return ChipKind.orange;
      default:
        return ChipKind.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    switch (_kind) {
      case ChipKind.green:
        bg = DashColors.greenSoft;
        fg = DashColors.green;
        break;
      case ChipKind.orange:
        bg = DashColors.orangeSoft;
        fg = DashColors.orange;
        break;
      case ChipKind.purple:
        bg = DashColors.purpleSoft;
        fg = DashColors.purple;
        break;
      case ChipKind.blue:
        bg = DashColors.blueSoft;
        fg = DashColors.primary;
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, this.size = 40});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A4F8B), Color(0xFF00264F)],
        ),
      ),
      child: Icon(Icons.person, color: Colors.white, size: size * 0.62),
    );
  }
}

class InfoBanner extends StatelessWidget {
  const InfoBanner({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: DashColors.soft,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: DashColors.softBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 1),
            child: Icon(Icons.info, color: DashColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: DashColors.primary,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DetailEntry {
  const DetailEntry(this.label, this.value, {this.isStatus = false});

  final String label;
  final String value;
  final bool isStatus;
}

class DetailRow extends StatelessWidget {
  const DetailRow({super.key, required this.entry});

  final DetailEntry entry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              entry.label,
              style: const TextStyle(color: DashColors.muted, fontSize: 14),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              entry.value,
              style: TextStyle(
                color: entry.isStatus ? DashColors.green : DashColors.heading,
                fontSize: 14.5,
                fontWeight: FontWeight.w500,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AadhaarBadge extends StatelessWidget {
  const AadhaarBadge({super.key, this.size = 48});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size * 1.5,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.fingerprint, color: const Color(0xFFE8542B), size: size),
          Text(
            'AADHAAR',
            style: TextStyle(
              color: const Color(0xFFC62828),
              fontSize: size * 0.2,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }
}

class PanIcon extends StatelessWidget {
  const PanIcon({super.key, this.size = 48});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFDCEEFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.credit_card_rounded,
        color: const Color(0xFF1E88E5),
        size: size * 0.6,
      ),
    );
  }
}

/// A white card with a header (logo / title / status chip), detail rows
/// and an optional footer (button).
class DetailsCard extends StatelessWidget {
  const DetailsCard({
    super.key,
    required this.leading,
    this.title,
    required this.entries,
    this.statusLabel = 'Verified',
    this.footer,
  });

  final Widget leading;
  final String? title;
  final List<DetailEntry> entries;
  final String statusLabel;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              leading,
              const SizedBox(width: 12),
              Expanded(
                child: title == null
                    ? const SizedBox.shrink()
                    : Text(
                        title!,
                        style: const TextStyle(
                          color: DashColors.heading,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
              StatusChip(label: statusLabel),
            ],
          ),
          const SizedBox(height: 14),
          for (final e in entries) DetailRow(entry: e),
          if (footer != null) ...[
            const SizedBox(height: 14),
            footer!,
          ],
        ],
      ),
    );
  }
}

class OutlineActionButton extends StatelessWidget {
  const OutlineActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon = Icons.visibility_outlined,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: DashColors.primary,
          side: const BorderSide(color: DashColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),
    );
  }
}

/// Scrolling page body with the page header (back arrow, title, account chip).
class PageFrame extends StatelessWidget {
  const PageFrame({
    super.key,
    required this.title,
    this.subtitle,
    this.onBack,
    this.chipLabel,
    required this.children,
    this.maxWidth = 1000,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onBack;
  final String? chipLabel;
  final List<Widget> children;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final pad = w >= 700 ? 32.0 : 16.0;
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(pad, pad, pad, pad + 8),
      child: Align(
        alignment: Alignment.topLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (onBack != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: onBack,
                        child: const Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(
                            Icons.arrow_back,
                            color: DashColors.heading,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: DashColors.heading,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            subtitle!,
                            style: const TextStyle(
                              color: DashColors.muted,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (chipLabel != null) ...[
                    const SizedBox(width: 8),
                    StatusChip(label: chipLabel!, kind: ChipKind.blue),
                  ],
                ],
              ),
              const SizedBox(height: 22),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}
