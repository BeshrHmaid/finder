import 'package:finder/core/params/base_params.dart';
import 'package:finder/core/results/result.dart';
import 'package:finder/core/usecase/usecase.dart';
import 'package:finder/features/auth/data/model/login_model/login_model.dart';
import 'package:finder/features/auth/data/repository/auth_repository.dart';

class RegisterParams extends BaseParams {
  String? username;
  String? password;
  String? confirmedPassword;
  String? phone;

  RegisterParams(
      {this.username, this.password, this.confirmedPassword, this.phone});

  toJson() {
    return {
      "username": username?.trim(),
      "password": password?.trim(),
      "phoneNumber": phone?.trim(),
    };
  }
}

class RegisterUseCase extends UseCase<LoginModel, RegisterParams> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Result<LoginModel>> call({required RegisterParams params}) {
    return repository.signupRequest(params: params);
  }
}
