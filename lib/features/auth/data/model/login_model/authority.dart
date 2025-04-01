import 'package:hive/hive.dart';

part 'authority.g.dart';

@HiveType(typeId: 3) // Unique ID for Authority
class Authority {
  @HiveField(0)
  String? authority;

  Authority({this.authority});

  factory Authority.fromJson(Map<String, dynamic> json) => Authority(
        authority: json['authority'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'authority': authority,
      };
}
