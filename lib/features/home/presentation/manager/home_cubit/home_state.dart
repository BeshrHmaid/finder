part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

class HomeUpdated extends HomeState {
  final int choiseIndex;

  HomeUpdated(this.choiseIndex);
}

// Add new state for params update
class HomeParamsUpdated extends HomeState {
  final PredictHouseParams params;
  HomeParamsUpdated(this.params);
}

// Add new state for search params update
class HomeSearchParamsUpdated extends HomeState {
  final SearchNewsParams searchParams;
  HomeSearchParamsUpdated(this.searchParams);
}
