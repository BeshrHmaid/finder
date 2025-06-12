class LocationGeo {
  String? type;
  List<dynamic>? coordinates;

  LocationGeo({this.type, this.coordinates});

  factory LocationGeo.fromJson(Map<String, dynamic> json) => LocationGeo(
        type: json['type'] as String?,
        coordinates: json['coordinates'] as List<dynamic>?,
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'coordinates': coordinates,
      };
}
