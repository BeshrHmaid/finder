import 'package:finder/core/data_source/model.dart';

class MonthlyPayment extends BaseModel {
  double? monthlyPayment;

  MonthlyPayment({this.monthlyPayment});

  factory MonthlyPayment.fromJson(Map<String, dynamic> json) {
    return MonthlyPayment(
      monthlyPayment: (json['monthlyPayment'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'monthlyPayment': monthlyPayment,
      };
}
