import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:finder/core/constant/app_colors/app_colors.dart';
import 'package:finder/core/constant/text_styles/font_size.dart';

import '../../../core/constant/app_padding/app_padding.dart';
import '../../../core/constant/text_styles/app_text_style.dart';
import '../../../core/ui/widgets/custom_button.dart';

class BaseHensStateScreen extends StatelessWidget {
  final String image;
  final double? width;
  final double? heightBetweenImageAndBetween;
  final String description;
  final String? buttonText;
  final Widget? buttonWidget;
  final Widget? textWidget;
  final VoidCallback? onTap;
  const BaseHensStateScreen(
      {super.key,
      required this.description,
      this.buttonText,
      required this.image,
      this.textWidget,
      this.onTap,
      this.width,
      this.heightBetweenImageAndBetween,
      this.buttonWidget});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            image,
            width: width ?? double.infinity,
            fit: BoxFit.fill,
          ),
          SizedBox(height: heightBetweenImageAndBetween ?? 80.h),
          textWidget ??
              Text(description,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.getBoldStyle(
                      color: AppColors.black14, fontSize: AppFontSize.size_16)),
          const SizedBox(height: AppPaddingSize.padding_90),
          buttonWidget ??
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppPaddingSize.padding_16),
                child: InkWell(
                  onTap: onTap,
                  child: CustomButton(
                    textStyle: AppTextStyle.getMediumStyle(
                        color: AppColors.white, fontSize: AppFontSize.size_14),
                    text: buttonText,
                  ),
                ),
              ),
          const SizedBox(height: AppPaddingSize.padding_16),
        ],
      ),
    );
  }
}
