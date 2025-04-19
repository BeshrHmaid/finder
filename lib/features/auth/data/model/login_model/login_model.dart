import 'package:finder/core/data_source/model.dart';
import 'package:hive/hive.dart';

import 'user.dart';

part 'login_model.g.dart';

@HiveType(typeId: 0)
class LoginModel extends BaseModel {
  @HiveField(0)
  String? token;

  @HiveField(1)
  int? expiresAt;

  @HiveField(2)
  User? user;
  bool? isGoogle;
  LoginModel({this.token, this.isGoogle, this.expiresAt, this.user});

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        token: json['token'] as String?,
        expiresAt: json['expiresAt'] as int?,
        user: json['user'] == null
            ? null
            : User.fromJson(json['user'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'token': token,
        'expiresAt': expiresAt,
        'user': user?.toJson(),
      };
}
