import 'package:finder/features/auth/presentation/manager/cubit/auth_cubit.dart';
import 'package:finder/features/language/cubit/language_cubit.dart';
import 'package:finder/features/onboarding/cubit/onboarding_cubit.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setUp() {
  //blocs
  getIt.registerLazySingleton(() => LanguageCubit());
  getIt.registerLazySingleton(() => OnBoardingCubit());

  getIt.registerLazySingleton(() => AuthCubit());

}
