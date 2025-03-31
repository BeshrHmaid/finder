import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'onboarding_state.dart';


class OnBoardingCubit extends Cubit<OnBoardingStates> {
  OnBoardingCubit() : super(OnBoardingInitialState());
  PageController? _pageController;

  PageController get pageController {
    _pageController ??= PageController();
    return _pageController!;
  }

  int index = 0;

  void changeIndex(int pageIndex) {
    index = pageIndex;
    emit(ChangeIndexState());
  }

  @override
  Future<void> close() {
    _pageController
        ?.dispose();
    return super.close();
  }
}
