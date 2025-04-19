import 'package:finder/features/root_navigation_view/data/cubit/root_page_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RootPageCubit extends Cubit<RootPageStates> {
  int rootIndex = 0;
  int homeIndex = 0;
  String? keywordsFarm;

  RootPageCubit() : super(RootPageInitialState());

  void changePageIndex(int pageIndex) {
    rootIndex = pageIndex;
    emit(ChangeIndexState());
  }

  void changeHomePageIndex(int pageIndex) {
    homeIndex = pageIndex;
    emit(ChangeIndexState());
  }
}
