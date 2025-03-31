import 'package:finder/features/onboarding/screens/root_onboarding.dart';
import 'package:go_router/go_router.dart';
import 'package:finder/core/ui/screens/splash_screen.dart';

abstract class AppRouter {
  static const kSplash = '/';
  static const kLoginView = '/loginView';
  static const kRegisterView = '/registerView';
  static const kHomeView = '/homeView';
  static const kRootView = '/rootView';
  static const kOnBoard = '/onBoard';

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
