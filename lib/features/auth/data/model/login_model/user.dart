import 'package:hive/hive.dart';

import 'authority.dart';
import 'role.dart';

part 'user.g.dart';

@HiveType(typeId: 1) // Unique ID for the User model
class User {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? email;

  @HiveField(3)
  String? password;

  @HiveField(4)
  List<Role>? roles;

  @HiveField(5)
  bool? enabled;

  @HiveField(6)
  bool? credentialsNonExpired;

  @HiveField(7)
  bool? accountNonExpired;

  @HiveField(8)
  bool? accountNonLocked;

  @HiveField(9)
  String? username;

  @HiveField(10)
  List<Authority>? authorities;
  @HiveField(11)
  dynamic balance;

  User({
    this.id,
    this.name,
    this.email,
    this.password,
    this.roles,
    this.enabled,
    this.credentialsNonExpired,
    this.accountNonExpired,
    this.accountNonLocked,
    this.balance,
    this.username,
    this.authorities,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as int?,
        name: json['name'] as String?,
        email: json['email'] as String?,
        balance: json['balance'] as dynamic,
        password: json['password'] as String?,
        roles: (json['roles'] as List<dynamic>?)
            ?.map((e) => Role.fromJson(e as Map<String, dynamic>))
            .toList(),
        enabled: json['enabled'] as bool?,
        credentialsNonExpired: json['credentialsNonExpired'] as bool?,
        accountNonExpired: json['accountNonExpired'] as bool?,
        accountNonLocked: json['accountNonLocked'] as bool?,
        username: json['username'] as String?,
        authorities: (json['authorities'] as List<dynamic>?)
            ?.map((e) => Authority.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'password': password,
        'roles': roles?.map((e) => e.toJson()).toList(),
        'enabled': enabled,
        'credentialsNonExpired': credentialsNonExpired,
        'accountNonExpired': accountNonExpired,
        'accountNonLocked': accountNonLocked,
        'username': username,
        'authorities': authorities?.map((e) => e.toJson()).toList(),
      };
}
