import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:finder/core/constant/text_styles/app_text_style.dart';
import 'package:finder/core/constant/text_styles/font_size.dart';
import 'package:finder/core/ui/widgets/custom_text_form_field.dart';
import 'package:finder/core/ui/widgets/logo_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:finder/core/boilerplate/create_model/widgets/create_model.dart';
import 'package:finder/core/classes/cache_helper.dart';
import 'package:finder/core/constant/app_colors/app_colors.dart';
import 'package:finder/core/constant/app_images_icons/app_assets.dart';
import 'package:finder/core/constant/app_padding/app_padding.dart';
import 'package:finder/core/ui/dialogs/dialogs.dart';
import 'package:finder/core/ui/widgets/custom_button.dart';
import 'package:finder/core/utils/app_router.dart';
import 'package:finder/core/utils/app_validator.dart';
import 'package:finder/features/auth/data/model/login_model/login_model.dart';
import 'package:finder/features/auth/data/repository/auth_repository.dart';
import 'package:finder/features/auth/domain/use_case/register_use.case.dart';
import 'package:finder/features/auth/presentation/manager/cubit/auth_cubit.dart';
import 'package:finder/features/auth/presentation/manager/cubit/auth_states.dart';
import 'package:finder/features/auth/presentation/views/widgets/login_signup_alternative.dart';
import 'package:finder/translations.dart';

class MobileRegisterViewBody extends StatelessWidget {
  const MobileRegisterViewBody({super.key});

  static final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthStates>(
      builder: (context, state) {
        return Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppPaddingSize.padding_30),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50.h,
                  ),
                  const LogoWidget(),
                  SizedBox(
                    height: 20.h,
                  ),
                  AnimatedTextKit(
                    animatedTexts: [
                      ColorizeAnimatedText(
                        AppLocalizations.of(context)!.register,
                        textStyle: AppTextStyle.getSemiBoldStyle(
                            fontSize: AppFontSize.size_18,
                            color: Theme.of(context).colorScheme.themedBlack),
                        colors: [
                          Theme.of(context).colorScheme.themedBlack,
                          Colors.red,
                          Colors.green,
                          Colors.orange,
                        ],
                     speed: Duration(seconds: 1),
                     
                      ),
                    ],
                    pause: Duration(seconds: 0),
                    repeatForever: false,
                    totalRepeatCount: 1,
                  ),
                  const SizedBox(
                    height: 26,
                  ),
                  CustomTextFormField(
                    onChanged: (p) {
                      context.read<AuthCubit>().registerParams.userName = p;
                    },
                    labelText: AppLocalizations.of(context)!.username,
                    labelStyle: AppTextStyle.getMediumStyle(
                        color: Theme.of(context).colorScheme.themedBlack),
                    prefixIcon: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: SvgPicture.asset(
                          Assets.iconsUser,
                        )),
                    validator: (value) => AppValidators.validateFillFields(
                        context,
                        context.read<AuthCubit>().registerParams.userName),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  CustomTextFormField(
                    onChanged: (p) {
                      context.read<AuthCubit>().registerParams.email = p;
                    },
                    labelText: AppLocalizations.of(context)!.email,
                    labelStyle: AppTextStyle.getMediumStyle(
                        color: Theme.of(context).colorScheme.themedBlack),
                    prefixIcon: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: SvgPicture.asset(
                          Assets.iconsMail,
                        )),
                    validator: (value) => AppValidators.validateEmailFields(
                        context,
                        context.read<AuthCubit>().registerParams.email),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  CustomTextFormField(
                    isObscure: context.read<AuthCubit>().passwordObscure,
                    suffixIcon: InkWell(
                      onTap: () => context
                          .read<AuthCubit>()
                          .changeObscurePasswordSignUp(),
                      child: Icon(
                          context.read<AuthCubit>().passwordObscure
                              ? Icons.visibility_off_outlined
                              : Icons.remove_red_eye,
                          color: AppColors.primary),
                    ),
                    labelText: AppLocalizations.of(context)!.password,
                    labelStyle: AppTextStyle.getMediumStyle(
                        color: Theme.of(context).colorScheme.themedBlack),
                    prefixIcon: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: SvgPicture.asset(
                          Assets.iconsLock,
                        )),
                    onChanged: (p) {
                      context.read<AuthCubit>().registerParams.password = p;
                    },
                    validator: (value) => AppValidators.validatePasswordFields(
                        context,
                        context.read<AuthCubit>().registerParams.password),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  CustomTextFormField(
                      isObscure:
                          context.read<AuthCubit>().confirmPasswordObscure,
                      suffixIcon: InkWell(
                        onTap: () => context
                            .read<AuthCubit>()
                            .changeObscureConfirmPassword(),
                        child: Icon(
                            context.read<AuthCubit>().confirmPasswordObscure
                                ? Icons.visibility_off_outlined
                                : Icons.remove_red_eye,
                            color: AppColors.primary),
                      ),
                      labelText: AppLocalizations.of(context)!.confirmPassword,
                      labelStyle: AppTextStyle.getMediumStyle(
                          color: Theme.of(context).colorScheme.themedBlack),
                      prefixIcon: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: SvgPicture.asset(
                            Assets.iconsLock,
                          )),
                      onChanged: (p) {
                        context
                            .read<AuthCubit>()
                            .registerParams
                            .confirmedPassword = p;
                      },
                      validator: (value) =>
                          AppValidators.validateRepeatPasswordFields(
                              context,
                              context.read<AuthCubit>().registerParams.password,
                              context
                                  .read<AuthCubit>()
                                  .registerParams
                                  .confirmedPassword)),
                  const SizedBox(
                    height: 30,
                  ),
                  CreateModel(
                    withValidation: true,
                    useCaseCallBack: (model) {
                      return RegisterUseCase(AuthRepository()).call(
                          params: context.read<AuthCubit>().registerParams);
                    },
                    onTap: () => (_formKey.currentState?.validate() ?? false),
                    onError: (val) {
                      Dialogs.showErrorSnackBar(
                          message: val,
                          context: context,
                          typeSnackBar: AnimatedSnackBarType.error);
                    },
                    onSuccess: (LoginModel model) {
                      CacheHelper.setToken(model.token);
                      CacheHelper.setUserId(model.user!.id);
                      CacheHelper.setUserInfo(model);
                      GoRouter.of(context).go(AppRouter.kRootView);
                    },
                    child: CustomButton(
                      text: AppLocalizations.of(context)!.next,
                    ),
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  const RegisterAlternative(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
