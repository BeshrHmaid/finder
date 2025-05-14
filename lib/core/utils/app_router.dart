import 'package:finder/core/ui/screens/splash_screen.dart';
import 'package:finder/features/auth/presentation/views/forgot_password_view.dart';
import 'package:finder/features/auth/presentation/views/login_view.dart';
import 'package:finder/features/auth/presentation/views/register_view.dart';
import 'package:finder/features/onboarding/screens/root_onboarding.dart';
import 'package:finder/features/root_navigation_view/view/root_view.dart';
import 'package:go_router/go_router.dart';

abstract class AppRouter {
  static const kSplash = '/';
  static const kLoginView = '/loginView';
  static const kRegisterView = '/registerView';
  static const kHomeView = '/homeView';
  static const kRootView = '/rootView';
  static const kOnBoard = '/onBoard';
  static const kForgotPassView = '/kForgotPassView';

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

      // GoRoute(
      //   path: kPostDetailsView,
      //   builder: (BuildContext context, GoRouterState state) {
      //     final post = state.extra as PostModel;
      //     return PostDetailsView(
      //       post: post,
      //     );
      //   },
      // ),
    ],
  );
}
