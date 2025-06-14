// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finder/core/constant/end_points/api_url.dart';
import 'package:finder/core/data_source/remote_data_source.dart';
import 'package:finder/core/http/http_method.dart';
import 'package:finder/core/params/base_params.dart';
import 'package:finder/core/repository/core_repository.dart';
import 'package:finder/core/results/result.dart';
import 'package:finder/core/usecase/usecase.dart';
import 'package:finder/features/home/integration/house_model/house_model.dart';

class SearchNewsParams extends BaseParams {
  String? q;
  num? minPrice;
  String? listingType;
  SearchNewsParams({
    this.q,
    this.minPrice,
    this.listingType,
  });
  Map<String, dynamic> toJson() {
    return {
      "q": this.q,
      "minPrice": this.minPrice,
      "listingType": this.listingType
    };
  }
}

class SearchNewsUseCase extends UseCase<ListHouseModel, SearchNewsParams> {
  final SerachNewsRepository repos;
  SearchNewsUseCase({
    required this.repos,
  });
  @override
  Future<Result<ListHouseModel>> call({required SearchNewsParams params}) {
    return repos.search(params);
  }
}

class SerachNewsRepository extends CoreRepository {
  Future<Result<ListHouseModel>> search(SearchNewsParams params) async {
    final result = await RemoteDataSource.request(
        responseStr: 'sa',
        converter: (json) => ListHouseModel.fromJson(json),
        method: HttpMethod.POST,
        data: params.toJson(),
        url: searchUrl);
    return call(result: result);
  }
}
