// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finder/core/constant/end_points/api_url.dart';
import 'package:finder/core/data_source/remote_data_source.dart';
import 'package:finder/core/http/http_method.dart';
import 'package:finder/core/params/base_params.dart';
import 'package:finder/core/repository/core_repository.dart';
import 'package:finder/core/results/result.dart';
import 'package:finder/core/usecase/usecase.dart';
import 'package:finder/features/profile/monthly_payment.dart';
import 'package:finder/features/profile/morg_params.dart';
import 'package:finder/features/profile/rent_vs_buy_model.dart';

class RentVsBuyParams extends BaseParams {
  int? propertyPrice;
  int? downPayment;
  double? annualInterestRate;
  int? loanTermYears;
  int? monthlyRent;
  int? yearsOfStay;
  int? annualPropertyTax;
  int? annualInsurance;
  int? homeAppreciationRate;
  int? rentIncreaseRate;
  int? investmentReturnRate;

  RentVsBuyParams({
    this.propertyPrice,
    this.downPayment,
    this.annualInterestRate,
    this.loanTermYears,
    this.monthlyRent,
    this.yearsOfStay,
    this.annualPropertyTax,
    this.annualInsurance,
    this.homeAppreciationRate,
    this.rentIncreaseRate,
    this.investmentReturnRate,
  });

  factory RentVsBuyParams.fromJson(Map<String, dynamic> json) {
    return RentVsBuyParams(
      propertyPrice: json['propertyPrice'] as int?,
      downPayment: json['downPayment'] as int?,
      annualInterestRate: (json['annualInterestRate'] as num?)?.toDouble(),
      loanTermYears: json['loanTermYears'] as int?,
      monthlyRent: json['monthlyRent'] as int?,
      yearsOfStay: json['yearsOfStay'] as int?,
      annualPropertyTax: json['annualPropertyTax'] as int?,
      annualInsurance: json['annualInsurance'] as int?,
      homeAppreciationRate: json['homeAppreciationRate'] as int?,
      rentIncreaseRate: json['rentIncreaseRate'] as int?,
      investmentReturnRate: json['investmentReturnRate'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'propertyPrice': propertyPrice,
        'downPayment': downPayment,
        'annualInterestRate': annualInterestRate,
        'loanTermYears': loanTermYears,
        'monthlyRent': monthlyRent,
        'yearsOfStay': yearsOfStay,
        'annualPropertyTax': annualPropertyTax,
        'annualInsurance': annualInsurance,
        'homeAppreciationRate': homeAppreciationRate,
        'rentIncreaseRate': rentIncreaseRate,
        'investmentReturnRate': investmentReturnRate,
      };
}

class ProfileRepository extends CoreRepository {
  Future<Result<RentVsBuyModel>> rentVsBuy(RentVsBuyParams params) async {
    final result = await RemoteDataSource.request(
        responseStr: 'ds',
        data: params.toJson(),
        converter: (json) => RentVsBuyModel.fromJson(json['data']),
        method: HttpMethod.POST,
        url: rentVsBuyUrl);
    return call(result: result);
  }

  Future<Result<MonthlyPayment>> morgCalc(MorgParams params) async {
    final result = await RemoteDataSource.request(
        responseStr: 'dss',
        data: params.toJson(),
        converter: (json) => MonthlyPayment.fromJson(json['data']),
        method: HttpMethod.POST,
        url: morgUrl);
    return call(result: result);
  }
}

class RentVsBuyUseCase extends UseCase<RentVsBuyModel, RentVsBuyParams> {
  final ProfileRepository profileRepository;
  RentVsBuyUseCase({
    required this.profileRepository,
  });
  @override
  Future<Result<RentVsBuyModel>> call({required RentVsBuyParams params}) {
    return profileRepository.rentVsBuy(params);
  }
}
