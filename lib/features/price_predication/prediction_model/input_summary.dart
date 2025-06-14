class InputSummary {
  String? priceCategory;
  String? type;
  String? furnishing;
  String? completionStatus;
  String? community;
  String? city;
  num? sizeSqft;
  num? totalRooms;
  num? propertyAge;

  InputSummary({
    this.priceCategory,
    this.type,
    this.furnishing,
    this.completionStatus,
    this.community,
    this.city,
    this.sizeSqft,
    this.totalRooms,
    this.propertyAge,
  });

  factory InputSummary.fromJson(Map<String, dynamic> json) => InputSummary(
        priceCategory: json['PriceCategory'] as String?,
        type: json['Type'] as String?,
        furnishing: json['Furnishing'] as String?,
        completionStatus: json['CompletionStatus'] as String?,
        community: json['Community'] as String?,
        city: json['City'] as String?,
        sizeSqft: json['Size_sqft'] as num?,
        totalRooms: json['TotalRooms'] as num?,
        propertyAge: json['PropertyAge'] as num?,
      );

  Map<String, dynamic> toJson() => {
        'PriceCategory': priceCategory,
        'Type': type,
        'Furnishing': furnishing,
        'CompletionStatus': completionStatus,
        'Community': community,
        'City': city,
        'Size_sqft': sizeSqft,
        'TotalRooms': totalRooms,
        'PropertyAge': propertyAge,
      };
}
