// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finder/core/params/base_params.dart';
import 'package:finder/core/results/result.dart';
import 'package:finder/core/usecase/usecase.dart';
import 'package:finder/features/profile/integation_backend.dart';
import 'package:finder/features/profile/monthly_payment.dart';

class MorgParams extends BaseParams {
  int? propertyPrice;
  int? downPayment;
  double? annualInterestRate;
  int? loanTermYears;

  MorgParams({
    this.propertyPrice,
    this.downPayment,
    this.annualInterestRate,
    this.loanTermYears,
  });

  factory MorgParams.fromJson(Map<String, dynamic> json) => MorgParams(
        propertyPrice: json['propertyPrice'] as int?,
        downPayment: json['downPayment'] as int?,
        annualInterestRate: (json['annualInterestRate'] as num?)?.toDouble(),
        loanTermYears: json['loanTermYears'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'propertyPrice': propertyPrice,
        'downPayment': downPayment,
        'annualInterestRate': annualInterestRate,
        'loanTermYears': loanTermYears,
      };
}

class MorgCalcUsecase extends UseCase<MonthlyPayment, MorgParams> {
  final ProfileRepository profileRepository;
  MorgCalcUsecase({
    required this.profileRepository,
  });
  @override
  Future<Result<MonthlyPayment>> call({required MorgParams params}) {
    return profileRepository.morgCalc(params);
  }
}
