import 'package:finder/features/auth/data/model/login_model/login_model.dart';
import 'package:finder/features/auth/data/repository/auth_repository.dart';

import '../../../../core/params/base_params.dart';
import '../../../../core/results/result.dart';
import '../../../../core/usecase/usecase.dart';

class SocialLoginParams extends BaseParams {
  final String socialMethod;
  SocialLoginParams(this.socialMethod);
}

class LoginSocialUseCase extends UseCase<LoginModel, SocialLoginParams> {
  final AuthRepository repository;

  LoginSocialUseCase(this.repository);

  @override
  Future<Result<LoginModel>> call({required SocialLoginParams params}) {
    return repository.socialLogIn(params: params);
  }
}
