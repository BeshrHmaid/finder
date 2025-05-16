import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:finder/core/constant/app_colors/app_colors.dart';
import 'package:finder/core/constant/app_images_icons/app_assets.dart';
import 'package:finder/core/ui/widgets/action_alert_dialog.dart';
import 'package:finder/features/home/presentation/home_view.dart';
import 'package:finder/features/profile/presentation/profile_view.dart';
import 'package:finder/features/root_navigation_view/data/cubit/root_page_cubit.dart';
import 'package:finder/features/root_navigation_view/data/cubit/root_page_state.dart';
import 'package:finder/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class RootView extends StatelessWidget {
  const RootView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RootPageCubit, RootPageStates>(
      builder: (context, state) => WillPopScope(
        onWillPop: () async {
          final cubit = context.read<RootPageCubit>();
          if (cubit.rootIndex != 0) {
            // If not on home screen, switch to home and prevent exit
            cubit.changePageIndex(0);
            return false;
          }

          // Show exit confirmation only on home screen
          bool shouldExit = false;
          await ActionAlertDialog.show(context,
              dialogTitle: AppLocalizations.of(context)!.dialogExitTitle,
              message: AppLocalizations.of(context)!.exitMessage,
              confirmText: AppLocalizations.of(context)!.confirmExit,
              cancelText: AppLocalizations.of(context)!.cancelExit,
              onConfirm: () {
            shouldExit = true;
            SystemNavigator.pop();
          });

          return shouldExit;
        },
        child: SafeArea(
          child: Scaffold(
            bottomNavigationBar: ConvexAppBar(
              elevation: 2,
              style: TabStyle.textIn,
              curve: Curves.easeInOut,
              curveSize: 90,
              backgroundColor: AppColors.primary,
              items: [
                TabItem(
                  icon: SvgPicture.asset(Assets.iconsHome,
                      height: 40, width: 40, fit: BoxFit.fill),
                  title: AppLocalizations.of(context)!.home,
                ),
                TabItem(
                    icon: SvgPicture.asset(
                      Assets.iconsAi,
                      height: 26,
                      width: 26,
                      fit: BoxFit.fill,
                      color: const Color(0xffEEEEe9),
                    ),
                    title: AppLocalizations.of(context)!.predict),
                TabItem(
                    icon: SvgPicture.asset(Assets.iconsAdd,
                        height: 26, width: 26, fit: BoxFit.fill),
                    title: AppLocalizations.of(context)!.add_ad),
                TabItem(
                    icon: SvgPicture.asset(Assets.iconsMAP,
                        height: 26, width: 26, fit: BoxFit.fill),
                    title: AppLocalizations.of(context)!.map),
                TabItem(
                    icon: SvgPicture.asset(Assets.iconsProfile,
                        height: 26, width: 26, fit: BoxFit.fill),
                    title: AppLocalizations.of(context)!.profile),
              ],
              onTap: (int index) {
                context.read<RootPageCubit>().changePageIndex(index);
              },
              initialActiveIndex: context.read<RootPageCubit>().rootIndex,
            ),
            body: _buildBody(context),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final index = context.watch<RootPageCubit>().rootIndex;

    if (index == 0)
      return const HomeView();
    else if (index == 1)
      return const HomeView();
    else if (index == 2)
      return const HomeView();
    else if (index == 3)
      return const HomeView();
    else if (index == 4) // && (CacheHelper.token?.isNotEmpty ?? false))
      return const ProfileView();
    else
      return const HomeView();
  }
}
