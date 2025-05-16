import 'package:finder/core/constant/app_colors/app_colors.dart';
import 'package:finder/core/constant/app_images_icons/app_assets.dart';
import 'package:finder/core/constant/text_styles/app_text_style.dart';
import 'package:finder/core/constant/text_styles/font_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfileActionCard extends StatelessWidget {
  const ProfileActionCard({
    super.key,
    required this.onPressed,
    required this.actionTitle,
    this.svgPath = Assets.iconsUser,
  });
  final VoidCallback onPressed;
  final String actionTitle;
  final String svgPath;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppFontSize.size_10),
      child: InkWell(
        onTap: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(
              svgPath,
              height: 32,
              width: 32,
            ),
            Text(
              actionTitle,
              style: AppTextStyle.getRegularStyle(
                  color: Theme.of(context).colorScheme.themedBlack,
                  fontSize: AppFontSize.size_18),
            ),
          ],
        ),
      ),
    );
  }
}
