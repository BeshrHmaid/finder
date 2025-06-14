part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileUpdateParams extends ProfileState {
  final RentVsBuyParams newParams;

  ProfileUpdateParams({required this.newParams});
}

final class ProfileMUpdateParams extends ProfileState {
  final MorgParams newParams;

  ProfileMUpdateParams({required this.newParams});
}
