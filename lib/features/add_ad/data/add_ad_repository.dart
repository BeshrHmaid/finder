import 'package:finder/core/constant/end_points/api_url.dart';
import 'package:finder/core/data_source/remote_data_source.dart';
import 'package:finder/core/http/http_method.dart';
import 'package:finder/core/repository/core_repository.dart';
import 'package:finder/core/results/result.dart';
import 'package:finder/features/add_ad/data/usecase/add_ad_usecase.dart';
import 'package:finder/features/home/integration/house_model/house_model.dart';

class AddAdRepository extends CoreRepository {
  Future<Result<HouseModel>> addAd({required AddAdParams params}) async {
    final result = await RemoteDataSource.request(
        responseStr: '',
        converter: (p0) => HouseModel.fromJson(p0['data']),
        files: params.pics,
        data: params.toMap(),
        fileKey: 'photos',
        method: HttpMethod.POST,
        url: addAdUrl,
        withAuthentication: true);
    return call(result: result);
  }
}
