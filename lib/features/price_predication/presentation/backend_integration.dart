// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finder/core/constant/end_points/api_url.dart';
import 'package:finder/core/data_source/remote_data_source.dart';
import 'package:finder/core/http/http_method.dart';
import 'package:finder/core/params/base_params.dart';
import 'package:finder/core/repository/core_repository.dart';
import 'package:finder/core/results/result.dart';
import 'package:finder/core/usecase/usecase.dart';
import 'package:finder/features/price_predication/prediction_model/prediction_model.dart';

class PredictHouseParams extends BaseParams {
  String? priceCategory;
  String? type;
  String? furnishing;
  String? completionStatus;
  String? community;
  String? city;
  int? sizeSqft;
  int? totalRooms;
  int? propertyAge;

  PredictHouseParams({
    this.priceCategory,
    this.type,
    this.furnishing,
    this.completionStatus,
    this.community,
    this.city,
    this.sizeSqft,
    this.totalRooms,
    this.propertyAge,
  });

  Map<String, dynamic> toJson() => {
        'PriceCategory': priceCategory,
        'Type': type,
        'Furnishing': furnishing,
        'CompletionStatus': completionStatus,
        'Community': community,
        'City': city,
        'Size_sqft': sizeSqft,
        'TotalRooms': totalRooms,
        'PropertyAge': propertyAge,
      };
}

class PredictHouseUsecase extends UseCase<PredictionModel, PredictHouseParams> {
  final PredictionRepository predictionRepository;
  PredictHouseUsecase({
    required this.predictionRepository,
  });
  @override
  Future<Result<PredictionModel>> call({required PredictHouseParams params}) {
    return predictionRepository.predict(params);
  }
}

class PredictionRepository extends CoreRepository {
  Future<Result<PredictionModel>> predict(PredictHouseParams params) async {
    final result = await RemoteDataSource.request(
        responseStr: 'sss',
        data: params.toJson(),
        converter: (json) => PredictionModel.fromJson(json),
        method: HttpMethod.POST,
        url: predictUrl);
    return call(result: result);
  }
}
