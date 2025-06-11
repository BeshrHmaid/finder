import 'package:finder/core/data_source/model.dart';

class RentVsBuyModel extends BaseModel {
  double? totalCostOfBuying;
  double? totalCostOfRenting;
  double? equityGained;
  double? finalPropertyValue;
  String? suggestion;

  RentVsBuyModel({
    this.totalCostOfBuying,
    this.totalCostOfRenting,
    this.equityGained,
    this.finalPropertyValue,
    this.suggestion,
  });

  factory RentVsBuyModel.fromJson(Map<String, dynamic> json) {
    return RentVsBuyModel(
      totalCostOfBuying: (json['totalCostOfBuying'] as num?)?.toDouble(),
      totalCostOfRenting: (json['totalCostOfRenting'] as num?)?.toDouble(),
      equityGained: (json['equityGained'] as num?)?.toDouble(),
      finalPropertyValue: (json['finalPropertyValue'] as num?)?.toDouble(),
      suggestion: json['suggestion'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'totalCostOfBuying': totalCostOfBuying,
        'totalCostOfRenting': totalCostOfRenting,
        'equityGained': equityGained,
        'finalPropertyValue': finalPropertyValue,
        'suggestion': suggestion,
      };
}
