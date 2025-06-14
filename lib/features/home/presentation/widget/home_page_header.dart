import 'package:finder/core/constant/app_colors/app_colors.dart';
import 'package:finder/core/constant/app_images_icons/app_assets.dart';
import 'package:finder/core/constant/text_styles/app_text_style.dart';
import 'package:finder/core/constant/text_styles/font_size.dart';
import 'package:finder/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeViewHeader extends StatelessWidget {
  const HomeViewHeader(
      {super.key, this.isPredictPage = false, this.headerTitle});
  final bool? isPredictPage;
  final String? headerTitle;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isPredictPage!)
              SvgPicture.asset(
                Assets.iconsFinderLogo,
                height: 32,
                width: 32,
              ),
            Text(
              isPredictPage ?? false
                  ? headerTitle ?? ''
                  : AppLocalizations.of(context)!.appName,
              style: AppTextStyle.getBoldStyle(
                  color: AppColors.primary, fontSize: AppFontSize.size_24),
            )
          ],
        ),
        // if (!isPredictPage!)
        //   InkWell(
        //     borderRadius: const BorderRadius.all(Radius.circular(50)),
        //     onTap: () {},
        //     focusColor: AppColors.grey72,
        //     splashColor: AppColors.grey72,
        //     child: Container(
        //         decoration: const BoxDecoration(
        //             borderRadius: BorderRadius.all(
        //               Radius.circular(50),
        //             ),
        //             color: AppColors.grey9D),
        //         child: Padding(
        //           padding: const EdgeInsets.all(8.0),
        //           child: Icon(
        //             Icons.notifications_outlined,
        //             size: 26,
        //             color: AppColors.primary,
        //           ),
        //         )),
        //   )
      ],
    );
  }
}
