class OwnerId {
  String? username;
  String? phoneNumber;

  OwnerId({this.username, this.phoneNumber});

  factory OwnerId.fromJson(Map<String, dynamic> json) => OwnerId(
        username: json['username'] as String?,
        phoneNumber: json['phoneNumber'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'username': username,
        'phoneNumber': phoneNumber,
      };
}
