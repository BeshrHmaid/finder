import 'package:flutter/material.dart';
import 'package:finder/core/constant/app_colors/app_colors.dart';
import 'package:finder/translations.dart';

class CustomOrDivider extends StatelessWidget {
  const CustomOrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            color: AppColors.grey3C,
            thickness: 1,
            indent: 16,
            endIndent: 8,
          ),
        ),
        Text(
          AppLocalizations.of(context)!.or,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        const Expanded(
          child: Divider(
            color: AppColors.grey3C,
            thickness: 1,
            indent: 8,
            endIndent: 16,
          ),
        ),
      ],
    );
  }
}
