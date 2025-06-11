import 'package:finder/core/data_source/model.dart';
import 'package:hive/hive.dart';

part 'login_model.g.dart';

@HiveType(typeId: 0)
class LoginModel extends BaseModel {
  @HiveField(0)
  String? username;

  @HiveField(1)
  String? phoneNumber;

  @HiveField(2)
  int? balance;

  @HiveField(3)
  String? jwtToken;

  LoginModel({
    this.username,
    this.phoneNumber,
    this.balance,
    this.jwtToken,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        username: json['username'] as String?,
        phoneNumber: json['phoneNumber'] as String?,
        balance: json['balance'] as int?,
        jwtToken: json['jwtToken'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'username': username,
        'phoneNumber': phoneNumber,
        'balance': balance,
        'jwtToken': jwtToken,
      };
}
