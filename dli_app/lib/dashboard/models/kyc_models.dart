/// Account type. A normal user verifies Aadhaar + PAN, an organization only PAN.
enum UserType { normal, organization }

extension UserTypeLabel on UserType {
  String get label => this == UserType.normal ? 'Normal User' : 'Organization';
}

class UserProfile {
  const UserProfile({
    required this.name,
    required this.email,
    required this.type,
  });

  final String name;
  final String email;
  final UserType type;
}

/// Only the masked Aadhaar number is ever stored/shown (last 4 digits).
class AadhaarDetails {
  const AadhaarDetails({
    required this.maskedNumber,
    required this.name,
    required this.dob,
    required this.gender,
    required this.address,
    required this.status,
  });

  final String maskedNumber;
  final String name;
  final String dob;
  final String gender;
  final String address;
  final String status;

  bool get verified => status == 'Active';
}

/// PAN of an individual (normal user).
class PanDetails {
  const PanDetails({
    required this.number,
    required this.name,
    required this.fatherName,
    required this.dob,
    required this.panType,
    required this.status,
  });

  final String number;
  final String name;
  final String fatherName;
  final String dob;
  final String panType;
  final String status;

  bool get verified => status == 'Active';
}

/// PAN of an organization.
class OrganizationPan {
  const OrganizationPan({
    required this.panNumber,
    required this.orgName,
    required this.orgType,
    required this.dateOfIncorporation,
    required this.address,
    required this.status,
  });

  final String panNumber;
  final String orgName;
  final String orgType;
  final String dateOfIncorporation;
  final String address;
  final String status;

  bool get verified => status == 'Active';
}

class KycData {
  const KycData({this.aadhaar, this.pan, this.orgPan});

  final AadhaarDetails? aadhaar;
  final PanDetails? pan;
  final OrganizationPan? orgPan;
}

enum ActivityKind { done, aadhaar, pan, profile }

class ActivityItem {
  const ActivityItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.badge,
    required this.kind,
  });

  final String title;
  final String subtitle;
  final String time;
  final String badge;
  final ActivityKind kind;
}

/// Replace this with your real backend call later (e.g. FastAPI endpoints).
abstract class KycRepository {
  UserProfile profile(UserType type);
  KycData kyc(UserType type);
  List<ActivityItem> activity(UserType type);
}

class MockKycRepository implements KycRepository {
  const MockKycRepository();

  @override
  UserProfile profile(UserType type) => UserProfile(
        name: 'Yash Patel',
        email: 'yashpatel@gmail.com',
        type: type,
      );

  @override
  KycData kyc(UserType type) {
    if (type == UserType.normal) {
      return const KycData(
        aadhaar: AadhaarDetails(
          maskedNumber: '**** **** 1234',
          name: 'Yash Patel',
          dob: '12-06-1998',
          gender: 'Male',
          address: '12, Green Park Society,\nAhmedabad, Gujarat - 380015',
          status: 'Active',
        ),
        pan: PanDetails(
          number: 'ABCDE1234F',
          name: 'Yash Patel',
          fatherName: 'Ramesh Patel',
          dob: '12-06-1998',
          panType: 'Individual',
          status: 'Active',
        ),
      );
    }
    return const KycData(
      orgPan: OrganizationPan(
        panNumber: 'ABCDE1234F',
        orgName: 'DLI Technologies Pvt. Ltd.',
        orgType: 'Private Limited',
        dateOfIncorporation: '15-08-2020',
        address: '101, Business Tower,\nSG Highway, Ahmedabad - 380015',
        status: 'Active',
      ),
    );
  }

  @override
  List<ActivityItem> activity(UserType type) => const [
        ActivityItem(
          title: 'KYC Verification Completed',
          subtitle: 'Your KYC has been successfully verified.',
          time: 'Today, 09:45 AM',
          badge: 'Completed',
          kind: ActivityKind.done,
        ),
        ActivityItem(
          title: 'Aadhaar Verification',
          subtitle: 'Aadhaar number verified successfully.',
          time: 'Yesterday, 04:20 PM',
          badge: 'Verified',
          kind: ActivityKind.aadhaar,
        ),
        ActivityItem(
          title: 'PAN Verification Pending',
          subtitle: 'Your PAN verification is under process.',
          time: 'Yesterday, 02:15 PM',
          badge: 'Pending',
          kind: ActivityKind.pan,
        ),
        ActivityItem(
          title: 'Profile Updated',
          subtitle: 'Your account details have been updated.',
          time: '12 Oct 2025, 11:30 AM',
          badge: 'Info',
          kind: ActivityKind.profile,
        ),
      ];
}
