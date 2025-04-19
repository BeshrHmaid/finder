import 'dart:async';

import 'package:finder/core/classes/cache_helper.dart';
import 'package:finder/core/constant/app_colors/app_colors.dart';
import 'package:finder/core/constant/app_lottie/app_lottie.dart';
import 'package:finder/core/constant/app_padding/app_padding.dart';
import 'package:finder/core/constant/end_points/cashe_helper_constant.dart';
import 'package:finder/core/constant/text_styles/app_text_style.dart';
import 'package:finder/core/constant/text_styles/font_size.dart';
import 'package:finder/core/utils/app_router.dart';
import 'package:finder/translations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Color _backgroundColor = AppColors.primary;
  @override
  void initState() {
    super.initState();
    _animateBackground();
    if (!CacheHelper.box.containsKey(isFirstTime)) {
      CacheHelper.setFirstTime(true);
    }
  }

  void _animateBackground() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _backgroundColor = AppColors.lightSecondaryColor;
        });
      }
    });

    Timer(const Duration(seconds: 5), () async {
      if (CacheHelper.token?.isEmpty ?? true) {
        if (CacheHelper.firstTime == true) {
          GoRouter.of(context).go(AppRouter.kOnBoard);
        } else {
          GoRouter.of(context).go(AppRouter.kLoginView);
        }
      } else {
        GoRouter.of(context).go(AppRouter.kRootView);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(seconds: 5),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [_backgroundColor, AppColors.primary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                splashLottie,
                width: 300,
                height: 300,
              ),
              const SizedBox(height: AppPaddingSize.padding_20),
              Text(
                AppLocalizations.of(context)!.appName,
                style: AppTextStyle.getBoldStyle(
                  color: Colors.white,
                  fontSize: AppFontSize.size_24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
