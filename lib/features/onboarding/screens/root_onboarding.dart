import 'package:finder/core/constant/app_padding/app_padding.dart';
import 'package:finder/core/ui/widgets/logo_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:finder/core/classes/cache_helper.dart';
import 'package:finder/core/constant/app_colors/app_colors.dart';
import 'package:finder/core/constant/app_images_icons/app_assets.dart';
import 'package:finder/core/constant/text_styles/app_text_style.dart';
import 'package:finder/core/constant/text_styles/font_size.dart';
import 'package:finder/core/ui/widgets/back_widget.dart';
import 'package:finder/core/ui/widgets/custom_button.dart';
import 'package:finder/core/utils/app_router.dart';
import 'package:finder/features/onboarding/cubit/onboarding_cubit.dart';
import 'package:finder/translations.dart';

import '../cubit/onboarding_state.dart';

class RootOnBoardingScreen extends StatelessWidget {
  const RootOnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<OnBoardingCubit, OnBoardingStates>(
        listener: (context, state) {},
        builder: (context, state) => Stack(
          children: [
            PageView.builder(
              onPageChanged: (int index) {
                context.read<OnBoardingCubit>().changeIndex(index);
              },
              physics: const BouncingScrollPhysics(),
              controller: context.read<OnBoardingCubit>().pageController,
              itemBuilder: (context, index) {
                return BaseOnboardingContent(
                  image: _getImageForIndex(index),
                );
              },
              itemCount: 3,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: BackWidget(
                      existBack: context.read<OnBoardingCubit>().index == 0
                          ? false
                          : true,
                      onBack: () => context
                          .read<OnBoardingCubit>()
                          .pageController
                          .previousPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeIn),
                      titleWidget: LogoWidget(
                        height: AppPaddingSize.padding_100,
                        width: AppPaddingSize.padding_100,
                      )),
                ),
                Expanded(flex: 4, child: SizedBox()),
                Expanded(flex: 2, child: _BottomSection()),
              ],
            ),
          ],
        ),
      ),
    ));
  }

  String _getImageForIndex(int index) {
    switch (index) {
      case 0:
        return Assets.imagesOnBoard1;
      case 1:
        return Assets.imagesOnBoard2;
      default:
        return Assets.imagesOnBoard3;
    }
  }
}

class BaseOnboardingContent extends StatelessWidget {
  final String image;

  const BaseOnboardingContent({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Image.asset(
            image,
            fit: BoxFit.fill,
          ),
        ),
      ],
    );
  }
}

class _BottomSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 7,
                  child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) =>
                        context.read<OnBoardingCubit>().index == index
                            ? Container(
                                height: 7,
                                width: 25,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: AppColors.primary,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                ),
                              )
                            : const CircleAvatar(
                                radius: 5,
                                backgroundColor: AppColors.greyDD,
                              ),
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 5),
                    itemCount: 3,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: BlocBuilder<OnBoardingCubit, OnBoardingStates>(
                builder: (context, state) {
                  final currentIndex = context.read<OnBoardingCubit>().index;
                  return Column(
                    children: [
                      Text(
                        _getTitle(context, currentIndex),
                        textAlign: TextAlign.center,
                        style: AppTextStyle.getBoldStyle(
                          color: AppColors.white,
                          fontSize: AppFontSize.size_20,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Column(
              children: [
                // Buttons
                BlocBuilder<OnBoardingCubit, OnBoardingStates>(
                  builder: (context, state) {
                    return CustomButton(
                      onPressed: () async {
                        if (context.read<OnBoardingCubit>().index != 2) {
                          context
                              .read<OnBoardingCubit>()
                              .pageController
                              .nextPage(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeIn);
                        } else {
                          await CacheHelper.setFirstTime(false);
                          GoRouter.of(context).go(AppRouter.kLoginView);
                        }
                      },
                      color: Theme.of(context).colorScheme.primaryColor,
                      text: context.read<OnBoardingCubit>().index != 2
                          ? AppLocalizations.of(context)!.next
                          : AppLocalizations.of(context)!.getStarted,
                      textStyle: AppTextStyle.getMediumStyle(
                        color: AppColors.white,
                        fontSize: AppFontSize.size_16,
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                if (context.read<OnBoardingCubit>().index != 2)
                  InkWell(
                    onTap: () async {
                      await CacheHelper.setFirstTime(false);
                      GoRouter.of(context).go(AppRouter.kLoginView);
                    },
                    child: Text(
                      AppLocalizations.of(context)!.skip,
                      style: AppTextStyle.getRegularStyle(
                        color: AppColors.white,
                        fontSize: AppFontSize.size_13,
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getTitle(BuildContext context, int index) {
    switch (index) {
      case 0:
        return "Rent , Purchase and Showcase Your House";
      case 1:
        return "Chat, Collaborate & Call";
      default:
        return "Predicet Price with AI And So Much More!";
    }
  }
}
