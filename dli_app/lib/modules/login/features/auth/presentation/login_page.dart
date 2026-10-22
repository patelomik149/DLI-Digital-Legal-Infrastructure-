import 'package:flutter/material.dart';

import 'widgets/auth_layout.dart';
import 'widgets/hero_panel.dart';
import 'widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      hero: const HeroPanel(),
      formBuilder: (context, isWide) => LoginForm(
        logoAlignment: isWide ? Alignment.centerLeft : Alignment.center,
        logoHeight: isWide ? 84 : 100,
      ),
    );
  }
}
