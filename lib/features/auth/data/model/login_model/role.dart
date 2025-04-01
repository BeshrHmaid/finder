import 'package:hive/hive.dart';

part 'role.g.dart';

@HiveType(typeId: 2)
class Role {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String? name;

  Role({required this.id, required this.name});

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json['id'] as int?,
        name: json['name'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
