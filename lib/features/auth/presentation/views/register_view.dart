import 'package:flutter/material.dart';
import 'package:finder/core/utils/adaptive_layout.dart';
import 'package:finder/features/auth/presentation/views/widgets/mobile_register_view_body.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: AdaptiveLayout(
          mobileLayout: (context) => const MobileRegisterViewBody(),
          tabletLayout: (context) => const SizedBox(),
          desktopLayout: (context) => const SizedBox(),
        ),
      ),
    );
  }
}
