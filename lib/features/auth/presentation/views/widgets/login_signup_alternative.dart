import 'package:finder/core/constant/app_colors/app_colors.dart';
import 'package:finder/core/constant/app_padding/app_padding.dart';
import 'package:finder/core/constant/text_styles/app_text_style.dart';
import 'package:finder/core/utils/app_router.dart';
import 'package:finder/translations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginAlternative extends StatelessWidget {
  const LoginAlternative({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            GoRouter.of(context).push(AppRouter.kForgotPassView);
          },
          child: Text(
            AppLocalizations.of(context)!.forgotPassword,
            style: AppTextStyle.getRegularStyle(color: AppColors.primary),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Text(
              AppLocalizations.of(context)!.newUser,
              style: AppTextStyle.getRegularStyle(
                  color: Theme.of(context).colorScheme.themedBlack),
            ),
            const SizedBox(
              width: AppPaddingSize.padding_6,
            ),
            InkWell(
              onTap: () {
                GoRouter.of(context).push(AppRouter.kRegisterView);
              },
              child: Text(
                AppLocalizations.of(context)!.registerHere,
                style: AppTextStyle.getRegularStyle(color: AppColors.primary),
              ),
            )
          ],
        ),
      ],
    );
  }
}

class RegisterAlternative extends StatelessWidget {
  const RegisterAlternative({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          AppLocalizations.of(context)!.alreadyHaveAccount,
          style: AppTextStyle.getRegularStyle(
              color: Theme.of(context).colorScheme.themedBlack),
        ),
        const SizedBox(
          width: AppPaddingSize.padding_6,
        ),
        InkWell(
          onTap: () {
            GoRouter.of(context).pop();
          },
          child: Text(
            AppLocalizations.of(context)!.loginHere,
            style: AppTextStyle.getRegularStyle(color: AppColors.primary),
          ),
        )
      ],
    );
  }
}
