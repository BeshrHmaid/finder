import 'package:finder/core/constant/app_images_icons/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
class LogoWidget extends StatelessWidget {
  final double? height;
  final double? width;
  const LogoWidget({super.key, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SvgPicture.asset(
      Assets.iconsFinderLogo,
      width: width,
      height: height,
      fit: BoxFit.fill,
    ));
  }
}
