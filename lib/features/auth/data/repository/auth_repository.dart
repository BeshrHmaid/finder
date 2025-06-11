import 'package:finder/core/constant/end_points/api_url.dart';
import 'package:finder/core/data_source/remote_data_source.dart';
import 'package:finder/core/http/http_method.dart';
import 'package:finder/core/repository/core_repository.dart';
import 'package:finder/core/results/result.dart';
import 'package:finder/features/auth/data/model/login_model/login_model.dart';
import 'package:finder/features/auth/domain/use_case/login_use_case.dart';
import 'package:finder/features/auth/domain/use_case/register_use.case.dart';

class AuthRepository extends CoreRepository {
  Future<Result<LoginModel>> loginRequest({required LoginParams params}) async {
    final result = await RemoteDataSource.request(
      withAuthentication: false,
      data: params.toJson(),
      url: loginUrl,
      method: HttpMethod.POST,
      responseStr: 'LoginResponse',
      converter: (json) => LoginModel.fromJson(json["data"]),
    );
    return call(result: result);
  }

  Future<Result<LoginModel>> signupRequest(
      {required RegisterParams params}) async {
    final result = await RemoteDataSource.request(
        withAuthentication: false,
        data: params.toJson(),
        url: registerUrl,
        method: HttpMethod.POST,
        responseStr: 'SignupResponse',
        converter: (json) => LoginModel.fromJson(json["data"]));
    return call(result: result);
  }
}
