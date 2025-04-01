import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:finder/core/boilerplate/create_model/widgets/create_model.dart';
import 'package:finder/core/classes/cache_helper.dart';
import 'package:finder/core/constant/app_colors/app_colors.dart';
import 'package:finder/core/constant/app_images_icons/app_assets.dart';
import 'package:finder/core/constant/app_padding/app_padding.dart';
import 'package:finder/core/constant/text_styles/app_text_style.dart';
import 'package:finder/core/constant/text_styles/font_size.dart';
import 'package:finder/core/ui/dialogs/dialogs.dart';
import 'package:finder/core/ui/widgets/custom_button.dart';
import 'package:finder/core/utils/app_router.dart';
import 'package:finder/features/auth/data/model/login_model/login_model.dart';
import 'package:finder/features/auth/data/repository/auth_repository.dart';
import 'package:finder/features/auth/domain/use_case/social_login_usecase.dart';
import 'package:finder/translations.dart';

class SocialLoginWidget extends StatelessWidget {
  const SocialLoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(child: Divider(color: Colors.grey)),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppPaddingSize.padding_12),
              child: Text(AppLocalizations.of(context)!.or,
                  style: AppTextStyle.getMediumStyle(
                      color: AppColors.grey9A, fontSize: AppFontSize.size_16)),
            ),
            const Expanded(child: Divider(color: Colors.grey))
          ],
        ),
        Padding(
          padding:
              const EdgeInsets.symmetric(vertical: AppPaddingSize.padding_16),
          child: Column(children: [
            CreateModel(
              withValidation: false,
              onError: (val) {
                print('the error is : $val');
                String errorMsg = '';
                if (val.contains(
                        '[firebase_auth/unknown] An internal error has occurred.') ||
                    val.contains(
                      '[firebase_auth/channel-error]',
                    )) {
                  errorMsg = 'An er error occurred while signing in.';
                } else if (val.contains(
                    '\'accessToken != null || idToken != null\': At least one of ID token and access token is required')) {
                  errorMsg = 'request canceled';
                } else {
                  errorMsg = val;
                }
                errorMsg.isEmpty
                    ? null
                    : Dialogs.showErrorSnackBar(
                        context: context,
                        message: errorMsg,
                        typeSnackBar: AnimatedSnackBarType.error);
              },
              onTap: () {},
              onSuccess: (LoginModel model) async {
                model.isGoogle = true;
                CacheHelper.setToken(model.token);
                CacheHelper.setUserId(model.user!.id);
                CacheHelper.setUserInfo(model);

                GoRouter.of(context).go(AppRouter.kRootView);
              },
              useCaseCallBack: (model) {
                return LoginSocialUseCase(AuthRepository())
                    .call(params: SocialLoginParams('google'));
              },
              child: CustomButton(
                text: '',
                borderSideColor: AppColors.greyDD,
                color: Colors.transparent,
                rowChild: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      Assets.iconsGmail,
                      height: 23,
                      width: 23,
                    ),
                    const SizedBox(
                      width: AppPaddingSize.padding_16,
                    ),
                    Text(AppLocalizations.of(context)!.continueWithGoogle,
                        style: AppTextStyle.getMediumStyle(
                            color: Theme.of(context).colorScheme.themedBlack,
                            fontSize: AppFontSize.size_12))
                  ],
                ),
              ),
            ),
          ]),
        ),
      ],
    );
  }
}
