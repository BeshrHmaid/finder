import 'package:flutter/material.dart';
import 'package:finder/core/utils/adaptive_layout.dart';
import 'package:finder/features/auth/presentation/views/widgets/mobile_login_view_body.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: AdaptiveLayout(
          mobileLayout: (context) => MobileLoginViewBody(),
          tabletLayout: (context) => const SizedBox(),
          desktopLayout: (context) => const SizedBox(),
        ),
      ),
    );
  }
}
