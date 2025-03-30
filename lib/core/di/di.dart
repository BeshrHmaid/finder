import 'package:finder/features/language/cubit/language_cubit.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setUp() {
  //blocs
  getIt.registerLazySingleton(() => LanguageCubit());
}
