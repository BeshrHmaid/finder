import 'package:finder/core/params/base_params.dart';
import 'package:finder/core/results/result.dart';
import 'package:finder/core/usecase/usecase.dart';
import 'package:finder/features/auth/data/model/login_model/login_model.dart';
import 'package:finder/features/auth/data/repository/auth_repository.dart';

class LoginParams extends BaseParams {
  String? email;
  String? password;

  LoginParams({this.email, this.password});

  toJson() {
    return {"email": email?.trim(), "password": password?.trim()};
  }
}

class LoginUseCase extends UseCase<LoginModel, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Result<LoginModel>> call({required LoginParams params}) {
    return repository.loginRequest(params: params);
  }
}
