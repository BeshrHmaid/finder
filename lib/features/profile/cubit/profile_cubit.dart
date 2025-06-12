import 'package:bloc/bloc.dart';
import 'package:finder/features/profile/integation_backend.dart';
import 'package:finder/features/profile/morg_params.dart';
import 'package:meta/meta.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());
  RentVsBuyParams params = RentVsBuyParams(
      annualInsurance: 0,
      annualInterestRate: 0,
      annualPropertyTax: 0,
      downPayment: 0,
      homeAppreciationRate: 0,
      investmentReturnRate: 0,
      loanTermYears: 0,
      monthlyRent: 0,
      propertyPrice: 0,
      rentIncreaseRate: 0,
      yearsOfStay: 0);
  MorgParams mParams = MorgParams(
    annualInterestRate: 0,
    downPayment: 0,
    loanTermYears: 0,
    propertyPrice: 0,
  );

  void updateParams(RentVsBuyParams newParams) {
    params = newParams;
    emit(ProfileUpdateParams(newParams: newParams));
  }

  void updateMParams(MorgParams newParams) {
    mParams = newParams;
    emit(ProfileMUpdateParams(newParams: newParams));
  }
}
