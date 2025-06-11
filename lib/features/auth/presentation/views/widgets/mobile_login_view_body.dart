import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:finder/core/boilerplate/create_model/widgets/create_model.dart';
import 'package:finder/core/classes/cache_helper.dart';
import 'package:finder/core/constant/app_colors/app_colors.dart';
import 'package:finder/core/constant/app_images_icons/app_assets.dart';
import 'package:finder/core/constant/app_padding/app_padding.dart';
import 'package:finder/core/constant/text_styles/app_text_style.dart';
import 'package:finder/core/constant/text_styles/font_size.dart';
import 'package:finder/core/ui/dialogs/dialogs.dart';
import 'package:finder/core/ui/widgets/custom_button.dart';
import 'package:finder/core/ui/widgets/custom_text_form_field.dart';
import 'package:finder/core/ui/widgets/logo_widget.dart';
import 'package:finder/core/utils/app_router.dart';
import 'package:finder/core/utils/app_validator.dart';
import 'package:finder/features/auth/data/model/login_model/login_model.dart';
import 'package:finder/features/auth/data/repository/auth_repository.dart';
import 'package:finder/features/auth/domain/use_case/login_use_case.dart';
import 'package:finder/features/auth/presentation/manager/cubit/auth_cubit.dart';
import 'package:finder/features/auth/presentation/manager/cubit/auth_states.dart';
import 'package:finder/features/auth/presentation/views/widgets/login_signup_alternative.dart';
import 'package:finder/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class MobileLoginViewBody extends StatelessWidget {
  const MobileLoginViewBody({super.key});
  static final TextEditingController emailController = TextEditingController();
  static final TextEditingController passwordController =
      TextEditingController();
  static final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthStates>(
      builder: (context, state) {
        return Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppPaddingSize.padding_30),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        AppLocalizations.of(context)!.login,
                        textStyle: AppTextStyle.getSemiBoldStyle(
                            fontSize: AppFontSize.size_18,
                            color: Theme.of(context).colorScheme.themedBlack),
                        colors: [
                          Theme.of(context).colorScheme.themedBlack,
                          Colors.red,
                          Colors.green,
                          Colors.orange,
                        ],
                        speed: const Duration(seconds: 1),
                      ),
                    ],
                    pause: const Duration(seconds: 0),
                    repeatForever: false,
                    totalRepeatCount: 2,
                  ),
                  const SizedBox(
                    height: 26,
                  ),
                  CustomTextFormField(
                    onChanged: (p) {
                      context.read<AuthCubit>().loginParams.email = p;
                    },
                    labelText: AppLocalizations.of(context)!.username,
                    labelStyle: AppTextStyle.getMediumStyle(
                        color: Theme.of(context).colorScheme.themedBlack),
                    prefixIcon: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: SvgPicture.asset(
                          Assets.iconsProfile,
                          height: 20,
                          width: 20,
                          color: Colors.black,
                        )),
                    validator: (p0) => AppValidators.validateFillFields(
                        context, context.read<AuthCubit>().loginParams.email),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  CustomTextFormField(
                    // obscureText: true,
                    isObscure: context.read<AuthCubit>().isObscure,
                    suffixIcon: InkWell(
                      onTap: () =>
                          context.read<AuthCubit>().changeObscurePassword(),
                      child: Icon(
                          context.read<AuthCubit>().isObscure
                              ? Icons.visibility_off_outlined
                              : Icons.remove_red_eye,
                          color: AppColors.primary),
                    ),
                    labelText: AppLocalizations.of(context)!.password,
                    labelStyle: AppTextStyle.getMediumStyle(
                        color: Theme.of(context).colorScheme.themedBlack),

                    prefixIcon: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: SvgPicture.asset(Assets.iconsLock)),
                    onChanged: (p) {
                      context.read<AuthCubit>().loginParams.password = p;
                    },
                    validator: (p0) => AppValidators.validateFillFields(context,
                        context.read<AuthCubit>().loginParams.password),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CreateModel(
                    withValidation: true,
                    onTap: () => (_formKey.currentState?.validate() ?? false),
                    useCaseCallBack: (model) async {
                      return await LoginUseCase(AuthRepository())
                          .call(params: context.read<AuthCubit>().loginParams);
                    },
                    onError: (val) {
                      Dialogs.showErrorSnackBar(
                          message: val,
                          context: context,
                          typeSnackBar: AnimatedSnackBarType.error);
                    },
                    onSuccess: (LoginModel model) {
                      CacheHelper.setToken(model.jwtToken);
                      CacheHelper.setUserInfo(model);
                      CacheHelper.setBalance(model.balance);
                      GoRouter.of(context).go(AppRouter.kRootView);
                    },
                    child: CustomButton(
                      text: AppLocalizations.of(context)!.login,
                    ),
                  ),
                  // CustomButton(
                  //   text: AppLocalizations.of(context)!.login,
                  //   onPressed: () {
                  //     GoRouter.of(context).go(AppRouter.kRootView);
                  //   },
                  // ),
                  // const CustomOrDivider(),
                  const SizedBox(
                    height: 22,
                  ),
                  // const SizedBox(
                  //   height: 30,
                  // ),
                  const LoginAlternative(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
