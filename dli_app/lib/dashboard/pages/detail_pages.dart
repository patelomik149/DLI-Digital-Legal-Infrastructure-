import 'package:flutter/material.dart';

import '../models/kyc_models.dart';
import '../state/dash_state.dart';
import '../widgets/common.dart';

List<DetailEntry> aadhaarEntries(AadhaarDetails a) => [
      DetailEntry('Aadhaar Number', a.maskedNumber),
      DetailEntry('Name', a.name),
      DetailEntry('Date of Birth', a.dob),
      DetailEntry('Gender', a.gender),
      DetailEntry('Address', a.address),
      DetailEntry('Status', a.status, isStatus: true),
    ];

List<DetailEntry> panEntries(PanDetails p) => [
      DetailEntry('PAN Number', p.number),
      DetailEntry('Name', p.name),
      DetailEntry("Father's Name", p.fatherName),
      DetailEntry('Date of Birth', p.dob),
      DetailEntry('PAN Type', p.panType),
      DetailEntry('Status', p.status, isStatus: true),
    ];

List<DetailEntry> orgPanEntries(OrganizationPan o) => [
      DetailEntry('PAN Number', o.panNumber),
      DetailEntry('Organization Name', o.orgName),
      DetailEntry('Type', o.orgType),
      DetailEntry('Date of Incorporation', o.dateOfIncorporation),
      DetailEntry('Registered Address', o.address),
      DetailEntry('Status', o.status, isStatus: true),
    ];

const _aadhaarNote =
    'Your Aadhaar details are verified with UIDAI.\nThis information is used for identity verification purposes only.';
const _panNote =
    'Your PAN details are verified with Income Tax Department.\nThis information is used for identity verification purposes only.';

/// Aadhaar details (normal users only).
class AadhaarDetailsPage extends StatelessWidget {
  const AadhaarDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = DashScope.of(context);
    final a = s.kyc.aadhaar;
    return PageFrame(
      title: 'Aadhaar Details',
      onBack: s.back,
      chipLabel: s.userType.label,
      children: [
        if (a == null)
          const InfoBanner(text: 'Aadhaar details are not available.')
        else ...[
          DetailsCard(
            leading: const AadhaarBadge(size: 54),
            statusLabel: a.verified ? 'Verified' : 'Pending',
            entries: aadhaarEntries(a),
          ),
          const SizedBox(height: 18),
          const InfoBanner(text: _aadhaarNote),
        ],
      ],
    );
  }
}

/// PAN details. For an organization this shows the organization's PAN only.
class PanDetailsPage extends StatelessWidget {
  const PanDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = DashScope.of(context);
    final org = s.isOrganization;
    final p = s.kyc.pan;
    final o = s.kyc.orgPan;
    final entries = org
        ? (o == null ? <DetailEntry>[] : orgPanEntries(o))
        : (p == null ? <DetailEntry>[] : panEntries(p));
    final verified = org ? (o?.verified ?? false) : (p?.verified ?? false);
    return PageFrame(
      title: 'PAN Details',
      onBack: s.back,
      chipLabel: s.userType.label,
      children: [
        DetailsCard(
          leading: const PanIcon(size: 48),
          title: 'PAN Card',
          statusLabel: verified ? 'Verified' : 'Pending',
          entries: entries,
        ),
        const SizedBox(height: 18),
        const InfoBanner(text: _panNote),
      ],
    );
  }
}

/// "All Details" with tabs.
/// Normal user  : Aadhaar Details | PAN Details
/// Organization : PAN Details | Organization Details
class AllDetailsPage extends StatefulWidget {
  const AllDetailsPage({super.key});

  @override
  State<AllDetailsPage> createState() => _AllDetailsPageState();
}

class _AllDetailsPageState extends State<AllDetailsPage> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final s = DashScope.of(context);
    final org = s.isOrganization;
    final kyc = s.kyc;
    final tabs = org
        ? ['PAN Details', 'Organization Details']
        : ['Aadhaar Details', 'PAN Details'];
    final int index = _tab.clamp(0, tabs.length - 1).toInt();

    Widget card;
    if (org) {
      final o = kyc.orgPan!;
      if (index == 0) {
        card = DetailsCard(
          leading: const PanIcon(size: 48),
          title: 'PAN Card',
          entries: orgPanEntries(o),
        );
      } else {
        card = DetailsCard(
          leading: const Icon(Icons.apartment_rounded,
              size: 44, color: Color(0xFF1E88E5)),
          title: 'Organization',
          entries: [
            DetailEntry('Organization Name', o.orgName),
            DetailEntry('Type', o.orgType),
            DetailEntry('Date of Incorporation', o.dateOfIncorporation),
            DetailEntry('Registered Address', o.address),
            DetailEntry('Status', o.status, isStatus: true),
          ],
        );
      }
    } else {
      if (index == 0) {
        card = DetailsCard(
          leading: const AadhaarBadge(size: 48),
          entries: aadhaarEntries(kyc.aadhaar!),
        );
      } else {
        card = DetailsCard(
          leading: const PanIcon(size: 48),
          title: 'PAN Card',
          entries: panEntries(kyc.pan!),
        );
      }
    }

    return PageFrame(
      title: 'All Details',
      onBack: s.back,
      chipLabel: s.userType.label,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5EDF5)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Row(
            children: [
              for (var i = 0; i < tabs.length; i++)
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _tab = i),
                    child: Container(
                      height: 48,
                      alignment: Alignment.center,
                      color: i == index
                          ? const Color(0xFF05619D)
                          : Colors.transparent,
                      child: Text(
                        tabs[i],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: i == index
                              ? Colors.white
                              : const Color(0xFF05619D),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        card,
        const SizedBox(height: 18),
        const InfoBanner(
          text:
              'All details are verified with the respective authorities.\nThis information is used for identity verification purposes only.',
        ),
      ],
    );
  }
}
