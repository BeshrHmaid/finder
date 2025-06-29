import 'package:finder/core/classes/cache_helper.dart';
import 'package:finder/core/di/di.dart';
import 'package:finder/core/utils/app_router.dart';
import 'package:finder/features/add_ad/presentation/cubit/add_property_cubit.dart';
import 'package:finder/features/auth/presentation/manager/cubit/auth_cubit.dart';
import 'package:finder/features/home/presentation/manager/home_cubit/home_cubit.dart';
import 'package:finder/features/language/cubit/language_cubit.dart';
import 'package:finder/features/language/cubit/language_states.dart';
import 'package:finder/features/onboarding/cubit/onboarding_cubit.dart';
import 'package:finder/features/profile/cubit/profile_cubit.dart';
import 'package:finder/features/root_navigation_view/data/cubit/root_page_cubit.dart';
import 'package:finder/firebase_options.dart';
import 'package:finder/translations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:overlay_support/overlay_support.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('firebase success');
  } on Exception catch (e) {
    print('firebase error $e');
  }
  await CacheHelper.init();
  setUp();
  runApp(const Finder());
}

class Finder extends StatelessWidget {
  const Finder({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<LanguageCubit>()),
        BlocProvider(create: (context) => getIt<OnBoardingCubit>()),
        BlocProvider(create: (context) => getIt<RootPageCubit>()),
        BlocProvider(create: (context) => getIt<AddPropertyCubit>()),
        BlocProvider(create: (context) => getIt<ProfileCubit>()),
        BlocProvider(create: (context) => getIt<AuthCubit>()),
        BlocProvider(create: (context) => getIt<HomeCubit>()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(429, 932),
        minTextAdapt: true,
        useInheritedMediaQuery: true,
        splitScreenMode: false,
        child: OverlaySupport.global(
          child: BlocBuilder<LanguageCubit, LanguageState>(
            builder: (context, state) {
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                routerConfig: AppRouter.router,
                locale: Locale(CacheHelper.lang),
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('en', ''),
                  Locale('ar', ''),
                ],
                theme: ThemeData(
                  iconTheme: const IconThemeData(color: Colors.white),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
