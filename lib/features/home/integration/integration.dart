// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:finder/core/constant/end_points/api_url.dart';
import 'package:finder/core/data_source/remote_data_source.dart';
import 'package:finder/core/http/http_method.dart';
import 'package:finder/core/params/base_params.dart';
import 'package:finder/core/repository/core_repository.dart';
import 'package:finder/core/results/result.dart';
import 'package:finder/core/usecase/usecase.dart';
import 'package:finder/features/home/integration/house_model/house_model.dart';

class GetHouseParams extends BaseParams {
  GetHouseParams();
}

class GetHousesUseCase extends UseCase<ListHouseModel, GetHouseParams> {
  final HomeRepository homeRepository;
  GetHousesUseCase({
    required this.homeRepository,
  });
  @override
  Future<Result<ListHouseModel>> call({required GetHouseParams params}) {
    return homeRepository.getHouses(params);
  }
}

class HomeRepository extends CoreRepository {
  Future<Result<ListHouseModel>> getHouses(GetHouseParams params) async {
    final result = await RemoteDataSource.request(
        responseStr: 'ss',
        converter: (json) => ListHouseModel.fromJson(json),
        method: HttpMethod.GET,
        url: housesUrl);
    return call(result: result);
  }
}
