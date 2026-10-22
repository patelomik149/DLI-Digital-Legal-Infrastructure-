import 'package:flutter/material.dart';

import '../models/kyc_models.dart';

enum DashPage {
  dashboard,
  kyc,
  documents,
  profile,
  settings,
  help,
  aadhaarDetails,
  panDetails,
  allDetails,
}

/// Sidebar entries (the highlighted one is derived from the current page).
enum NavSection { dashboard, kyc, documents, profile, settings, help }

class DashState extends ChangeNotifier {
  DashState({
    UserType initialType = UserType.normal,
    this.repository = const MockKycRepository(),
    this.onLogout,
  }) : _type = initialType;

  final KycRepository repository;
  final VoidCallback? onLogout;

  UserType _type;
  final List<DashPage> _stack = [DashPage.dashboard];

  UserType get userType => _type;
  bool get isOrganization => _type == UserType.organization;
  UserProfile get user => repository.profile(_type);
  KycData get kyc => repository.kyc(_type);
  List<ActivityItem> get activity => repository.activity(_type);

  DashPage get page => _stack.last;
  bool get canGoBack => _stack.length > 1;

  NavSection get section {
    switch (page) {
      case DashPage.dashboard:
        return NavSection.dashboard;
      case DashPage.kyc:
      case DashPage.aadhaarDetails:
      case DashPage.panDetails:
        return NavSection.kyc;
      case DashPage.documents:
        return NavSection.documents;
      case DashPage.profile:
      case DashPage.allDetails:
        return NavSection.profile;
      case DashPage.settings:
        return NavSection.settings;
      case DashPage.help:
        return NavSection.help;
    }
  }

  /// Top level navigation (sidebar / menu).
  void go(DashPage p) {
    _stack
      ..clear()
      ..add(p);
    notifyListeners();
  }

  /// Opens a page on top of the current one (back arrow returns).
  void push(DashPage p) {
    _stack.add(p);
    notifyListeners();
  }

  void back() {
    if (_stack.length > 1) {
      _stack.removeLast();
    } else {
      _stack
        ..clear()
        ..add(DashPage.dashboard);
    }
    notifyListeners();
  }

  /// Demo helper: switch between Normal User and Organization accounts.
  void switchType(UserType t) {
    if (t == _type) return;
    _type = t;
    _stack
      ..clear()
      ..add(DashPage.kyc);
    notifyListeners();
  }
}

class DashScope extends InheritedNotifier<DashState> {
  const DashScope({
    super.key,
    required DashState state,
    required super.child,
  }) : super(notifier: state);

  static DashState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<DashScope>();
    assert(scope != null, 'DashScope not found in widget tree');
    return scope!.notifier!;
  }
}
