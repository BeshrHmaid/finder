part of 'add_property_cubit.dart';

@immutable
sealed class AddPropertyState {}

final class AddPropertyInitial extends AddPropertyState {}

final class AddAdParamsUpdate extends AddPropertyState {
  final AddAdParams params;

  AddAdParamsUpdate({required this.params});
}
