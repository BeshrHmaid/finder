import 'package:finder/core/data_source/model.dart';

import 'input_summary.dart';

class PredictionModel extends BaseModel {
  num? predictedPriceAed;
  num? logPrediction;
  InputSummary? inputSummary;

  PredictionModel({
    this.predictedPriceAed,
    this.logPrediction,
    this.inputSummary,
  });

  factory PredictionModel.fromJson(Map<String, dynamic> json) {
    return PredictionModel(
      predictedPriceAed: json['predicted_price_aed'] as num?,
      logPrediction: json['log_prediction'] as num?,
      inputSummary: json['input_summary'] == null
          ? null
          : InputSummary.fromJson(
              json['input_summary'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'predicted_price_aed': predictedPriceAed,
        'log_prediction': logPrediction,
        'input_summary': inputSummary?.toJson(),
      };
}
