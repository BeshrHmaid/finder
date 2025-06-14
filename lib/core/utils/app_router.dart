import 'package:finder/core/ui/screens/splash_screen.dart';
import 'package:finder/features/auth/presentation/views/forgot_password_view.dart';
import 'package:finder/features/auth/presentation/views/login_view.dart';
import 'package:finder/features/auth/presentation/views/register_view.dart';
import 'package:finder/features/auth/presentation/views/reset_password_view.dart';
import 'package:finder/features/auth/presentation/views/verify_otp_view.dart';
import 'package:finder/features/home/integration/house_model/house_model.dart';
import 'package:finder/features/home/presentation/widget/house_details_view.dart';
import 'package:finder/features/onboarding/screens/root_onboarding.dart';
import 'package:finder/features/price_predication/presentation/views/predict_house_price_view.dart';
import 'package:finder/features/profile/morg_page.dart';
import 'package:finder/features/profile/presentation/edit_profile_view.dart';
import 'package:finder/features/profile/presentation/profile_view.dart';
import 'package:finder/features/profile/presentation/rentvsbuy_page.dart';
import 'package:finder/features/root_navigation_view/view/root_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract class AppRouter {
  static const kSplash = '/';
  static const kLoginView = '/loginView';
  static const kRegisterView = '/registerView';
  static const kHomeView = '/homeView';
  static const kRootView = '/rootView';
  static const kOnBoard = '/onBoard';
  static const kForgotPassView = '/forgotPassView';
  static const kVerifyOtpView = '/verifyOtpView';
  static const kProfileView = '/profileView';
  static const kEditProfileView = '/editProfileView';
  static const kResetPasswordView = '/resetPasswordView';
  static const kPredictHousePriceView = '/predictHousePriceView';
  static const kRentvsBuy = '/rentVsBuy';
  static const kMortgageCalculator = '/morgi';
  static const kHouseDetailes = '/houseDetails';

  static final router = GoRouter(
    routes: [
      GoRoute(
        path: kSplash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: kOnBoard,
        builder: (context, state) => const RootOnBoardingScreen(),
      ),
      GoRoute(
        path: kLoginView,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: kRegisterView,
        builder: (context, state) => const RegisterView(),
      ),
      GoRoute(
        path: kRootView,
        builder: (context, state) => const RootView(),
      ),
      GoRoute(
        path: kForgotPassView,
        builder: (context, state) => const ForgotPasswordView(),
      ),
      GoRoute(
        path: kVerifyOtpView,
        builder: (context, state) => const OTPVerificationScreen(),
      ),
      GoRoute(
        path: kProfileView,
        builder: (context, state) => const ProfileView(),
      ),
      GoRoute(
        path: kEditProfileView,
        builder: (context, state) => const EditProfileView(),
      ),
      GoRoute(
        path: kForgotPassView,
        builder: (context, state) => const ResetPasswordView(),
      ),
      GoRoute(
        path: kPredictHousePriceView,
        builder: (context, state) => const PredictHousePricePage(),
      ),
      GoRoute(
        path: kRentvsBuy,
        builder: (context, state) => const BuyVsRentCalculatorPage(),
      ),
      GoRoute(
        path: kMortgageCalculator,
        builder: (context, state) => const MortgageCalculatorPage(),
      ),
      GoRoute(
        path: kHouseDetailes,
        builder: (BuildContext context, GoRouterState state) {
          final house = state.extra as HouseModel;
          return HouseDetailsPage(
            houseModel: house,
          );
        },
      ),
    ],
  );
}
