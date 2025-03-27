import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:finder/core/constant/app_colors/app_colors.dart';
import 'package:finder/core/constant/app_images_icons/app_assets.dart';
import 'package:finder/core/ui/widgets/base_hens_state_screen.dart';

import '../../constant/text_styles/app_text_style.dart';
import '../../constant/text_styles/font_size.dart';

class GeneralErrorWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget? body;
  final String? message;
  final String? buttonText;
  final double? height;
  final double? width;
  const GeneralErrorWidget(
      {super.key,
      this.onTap,
      this.message,
      this.buttonText,
      this.body,
      this.height,
      this.width});

  @override
  Widget build(BuildContext context) {
    return BaseHensStateScreen(
      width: 250.w,
      textWidget: Text(message ?? '',
          textAlign: TextAlign.center,
          style: AppTextStyle.getRegularStyle(
              color: AppColors.grey9A, fontSize: AppFontSize.size_16)),
      // buttonText: AppLocalizations.of(context)!.try_again,
      buttonText: "",
      image: 'error image',
      onTap: onTap,
      description: '',
    );
  }
}
