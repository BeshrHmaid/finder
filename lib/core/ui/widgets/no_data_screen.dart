import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:finder/core/constant/text_styles/app_text_style.dart';
import 'package:finder/core/constant/text_styles/font_size.dart';

import '../../constant/app_colors/app_colors.dart';

class NoDataScreen extends StatelessWidget {
  final double? height;
  final double? width;
  const NoDataScreen({super.key, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 70.h),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/images.png",
                width: width ?? 300.w,
                height: height ?? 230.h,
              ),
              SizedBox(height: 30.h),
              Text("AppLocalizations.of(context)!.no_data,",
                  style: AppTextStyle.getRegularStyle(
                      color: AppColors.grey9A, fontSize: AppFontSize.size_16)),
            ],
          ),
        ),
      ),
    );
  }
}
