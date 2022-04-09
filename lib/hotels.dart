import 'package:json_annotation/json_annotation.dart';

part 'hotels.g.dart';

@JsonSerializable()
class Hotels {
  final String uuid;
  final String name;
  final String poster;

  Hotels({
    required this.uuid,
    required this.name,
    required this.poster,
  });

  factory Hotels.fromJson(Map<String, dynamic> json) => _$HotelsFromJson(json);
  Map<String, dynamic> toJson() => _$HotelsToJson(this);
}

@JsonSerializable()
class HotelsDetails {
  final String uuid;
  final String name;
  final HotelAddress address;
  final double rating;
  final HotelServices services;
  final List<String> photos;

  HotelsDetails({
    required this.uuid,
    required this.name,
    required this.address,
    required this.rating,
    required this.services,
    required this.photos,
  });

  factory HotelsDetails.fromJson(Map<String, dynamic> json) =>
      _$HotelsDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$HotelsDetailsToJson(this);
}

@JsonSerializable()
class HotelAddress {
  final String country;
  final String street;
  final String city;

  HotelAddress({
    required this.country,
    required this.street,
    required this.city,
  });

  factory HotelAddress.fromJson(Map<String, dynamic> json) =>
      _$HotelAddressFromJson(json);
  Map<String, dynamic> toJson() => _$HotelAddressToJson(this);
}

@JsonSerializable()
class HotelServices {
  final List<String> free;
  final List<String> paid;

  HotelServices({
    required this.free,
    required this.paid,
  });

  factory HotelServices.fromJson(Map<String, dynamic> json) =>
      _$HotelServicesFromJson(json);
  Map<String, dynamic> toJson() => _$HotelServicesToJson(this);
}
