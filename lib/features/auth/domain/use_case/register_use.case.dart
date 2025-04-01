import 'package:finder/core/params/base_params.dart';
import 'package:finder/core/results/result.dart';
import 'package:finder/core/usecase/usecase.dart';
import 'package:finder/features/auth/data/model/login_model/login_model.dart';
import 'package:finder/features/auth/data/repository/auth_repository.dart';

class RegisterParams extends BaseParams {
  String? email;
  String? password;
  String? confirmedPassword;
  String? userName;
  String? role;

  RegisterParams(
      {this.email,
      this.password,
      this.confirmedPassword,
      this.role,
      this.userName});

  toJson() {
    return {
      "email": email?.trim(),
      "password": password?.trim(),
      "name": userName?.trim(),
      "role": role
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
