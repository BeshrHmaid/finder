import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:finder/core/classes/cache_helper.dart';
import 'package:finder/core/constant/app_colors/app_colors.dart';
import 'package:finder/core/constant/app_padding/app_padding.dart';
import 'package:finder/core/constant/end_points/cashe_helper_constant.dart';
import 'package:finder/core/constant/text_styles/app_text_style.dart';
import 'package:finder/core/constant/text_styles/font_size.dart';
import 'package:finder/core/utils/app_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    if (!CacheHelper.box.containsKey(isFirstTime)) {
      CacheHelper.setFirstTime(true);
    }

    Timer(const Duration(seconds: 1, milliseconds: 3), () async {
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
    return SafeArea(
        child: Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // const Expanded(child: SketchLogo()),
          const CupertinoActivityIndicator(),
          Text(
            "Sketch",
            style: AppTextStyle.getBoldStyle(
                color: AppColors.black1c, fontSize: AppFontSize.size_20),
          ),
          const SizedBox(
            height: AppPaddingSize.padding_50,
          ),
        ],
      ),
    ));
  }
}
