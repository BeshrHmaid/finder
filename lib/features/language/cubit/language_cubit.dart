import 'package:finder/core/classes/cache_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finder/features/language/cubit/language_states.dart';

class LanguageCubit extends Cubit<LanguageState> {
  String lang = CacheHelper.lang;
  LanguageCubit() : super(LanguageInitialState());

  updateAppLanguage() {
    CacheHelper.setLang(lang);
    emit(UpdateLanguageState());
  }

  updateLanguage({required String lng}) {
    lang = lng;
    emit(UpdateLanguageState());
  }
}
