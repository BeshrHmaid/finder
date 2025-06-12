import 'package:finder/core/data_source/model.dart';

import 'location_geo.dart';
import 'owner_id.dart';

class ListHouseModel extends BaseModel {
  List<HouseModel> data;
  ListHouseModel(this.data);
  factory ListHouseModel.fromJson(Map<String, dynamic> json) {
    return ListHouseModel(
      List<HouseModel>.from(
        json['data'].map(
          (x) => HouseModel.fromJson(
            x,
          ),
        ),
      ),
    );
  }
}

class HouseModel extends BaseModel {
  LocationGeo? locationGeo;
  String? id;
  String? title;
  String? description;
  num? price;
  String? location;
  OwnerId? ownerId;
  List<dynamic>? photos;
  String? listingType;
  int? v;

  HouseModel({
    this.locationGeo,
    this.id,
    this.title,
    this.description,
    this.price,
    this.location,
    this.ownerId,
    this.photos,
    this.listingType,
    this.v,
  });

  factory HouseModel.fromJson(Map<String, dynamic> json) => HouseModel(
        locationGeo: json['locationGeo'] == null
            ? null
            : LocationGeo.fromJson(json['locationGeo'] as Map<String, dynamic>),
        id: json['_id'] as String?,
        title: json['title'] as String?,
        description: json['description'] as String?,
        price: json['price'] as num?,
        location: json['location'] as String?,
        ownerId: json['ownerId'] == null
            ? null
            : OwnerId.fromJson(json['ownerId'] as Map<String, dynamic>),
        photos: json['photos'] as List<dynamic>?,
        listingType: json['listingType'] as String?,
        v: json['__v'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'locationGeo': locationGeo?.toJson(),
        '_id': id,
        'title': title,
        'description': description,
        'price': price,
        'location': location,
        'ownerId': ownerId?.toJson(),
        'photos': photos,
        'listingType': listingType,
        '__v': v,
      };
}
