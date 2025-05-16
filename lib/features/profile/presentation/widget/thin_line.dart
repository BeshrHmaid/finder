import 'package:finder/core/constant/app_colors/app_colors.dart';
import 'package:flutter/material.dart';

class ThinLine extends StatelessWidget {
  const ThinLine({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      width: double.infinity,
      color: AppColors.primary.withOpacity(0.5),
    );
  }
}
