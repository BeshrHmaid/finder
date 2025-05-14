import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  int choiseIndex = 0;

  // Method to update the choice index and emit a new state
  void updateChoiceIndex(int newIndex) {
    choiseIndex = newIndex;
    emit(HomeUpdated(choiseIndex)); // Emit a new state to trigger a UI update
  }
}
