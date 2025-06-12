import 'package:finder/features/add_ad/presentation/cubit/add_property_cubit.dart';
import 'package:finder/features/auth/presentation/manager/cubit/auth_cubit.dart';
import 'package:finder/features/home/presentation/manager/home_cubit/home_cubit.dart';
import 'package:finder/features/language/cubit/language_cubit.dart';
import 'package:finder/features/onboarding/cubit/onboarding_cubit.dart';
import 'package:finder/features/profile/cubit/profile_cubit.dart';
import 'package:finder/features/root_navigation_view/data/cubit/root_page_cubit.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setUp() {
  //blocs
  getIt.registerLazySingleton(() => LanguageCubit());
  getIt.registerLazySingleton(() => OnBoardingCubit());
  getIt.registerLazySingleton(() => HomeCubit());
  getIt.registerLazySingleton(() => ProfileCubit());
  getIt.registerLazySingleton(() => AddPropertyCubit());
  getIt.registerLazySingleton(() => AuthCubit());
  getIt.registerLazySingleton(() => RootPageCubit());
}
