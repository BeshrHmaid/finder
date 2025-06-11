// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:finder/core/params/base_params.dart';
import 'package:finder/core/results/result.dart';
import 'package:finder/core/usecase/usecase.dart';
import 'package:finder/features/add_ad/data/add_ad_repository.dart';

class AddAdParams extends BaseParams {
  String? title;
  String? description;
  double? price;
  String? location;
  List<File>? pics;
  String? listingType;
  AddAdParams({
    this.title,
    this.description,
    this.price,
    this.location,
    this.pics,
    this.listingType,
  });

  AddAdParams copyWith({
    String? title,
    String? description,
    double? price,
    String? location,
    List<File>? pics,
    String? listingType,
  }) {
    return AddAdParams(
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      location: location ?? this.location,
      pics: pics ?? this.pics,
      listingType: listingType ?? this.listingType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'price': price,
      'location': location,
      'listingType': listingType,
    };
  }

  String toJson() => json.encode(toMap());
}

class AddAdUsecase extends UseCase<String, AddAdParams> {
  final AddAdRepository addAdRepository;
  AddAdUsecase({
    required this.addAdRepository,
  });
  @override
  Future<Result<String>> call({required AddAdParams params}) {
    return addAdRepository.addAd(params: params);
  }
}
