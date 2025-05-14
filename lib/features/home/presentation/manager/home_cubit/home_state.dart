part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

class HomeUpdated extends HomeState {
  final int choiseIndex;

  HomeUpdated(this.choiseIndex);
}
