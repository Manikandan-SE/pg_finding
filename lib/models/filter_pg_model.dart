// To parse this JSON data, do
//
//     final filterPgModel = filterPgModelFromJson(jsonString);

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'filter_pg_model.g.dart';

List<FilterPgModel> filterPgModelFromJson(String str) =>
    List<FilterPgModel>.from(
        json.decode(str).map((x) => FilterPgModel.fromJson(x)));

String filterPgModelToJson(List<FilterPgModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class FilterPgModel {
  @JsonKey(name: "pgId")
  final int? pgId;
  @JsonKey(name: "owner")
  final Owner? owner;
  @JsonKey(name: "pg_name")
  final String? pg_name;
  @JsonKey(name: "pgAddress")
  final String? pgAddress;
  @JsonKey(name: "city")
  final String? city;
  @JsonKey(name: "pgPhoneNumber")
  final String? pgPhoneNumber;
  @JsonKey(name: "latitude")
  final double? latitude;
  @JsonKey(name: "longitude")
  final double? longitude;
  @JsonKey(name: "img1")
  final String? img1;
  @JsonKey(name: "img2")
  final String? img2;
  @JsonKey(name: "img3")
  final String? img3;
  @JsonKey(name: "pgType")
  final String? pgType;
  @JsonKey(name: "pgCategory")
  final String? pgCategory;
  @JsonKey(name: "amount")
  final String? amount;
  @JsonKey(name: "roomCategory")
  final String? roomCategory;
  @JsonKey(name: "isSaved")
  final bool? isSaved;
  @JsonKey(name: "booking_status")
  final String? booking_status;

  FilterPgModel({
    this.pgId,
    this.owner,
    this.pg_name,
    this.pgAddress,
    this.city,
    this.pgPhoneNumber,
    this.latitude,
    this.longitude,
    this.img1,
    this.img2,
    this.img3,
    this.pgType,
    this.pgCategory,
    this.amount,
    this.roomCategory,
    this.isSaved,
    this.booking_status,
  });

  factory FilterPgModel.fromJson(Map<String, dynamic> json) =>
      _$FilterPgModelFromJson(json);

  Map<String, dynamic> toJson() => _$FilterPgModelToJson(this);

  FilterPgModel copyWith({
    int? pgId,
    Owner? owner,
    String? pg_name,
    String? pgAddress,
    String? city,
    String? pgPhoneNumber,
    double? latitude,
    double? longitude,
    String? img1,
    String? img2,
    String? img3,
    String? pgType,
    String? pgCategory,
    String? amount,
    String? roomCategory,
    bool? isSaved,
  }) {
    return FilterPgModel(
      pgId: pgId ?? this.pgId,
      owner: owner ?? this.owner,
      pg_name: pg_name ?? this.pg_name,
      pgAddress: pgAddress ?? this.pgAddress,
      city: city ?? this.city,
      pgPhoneNumber: pgPhoneNumber ?? this.pgPhoneNumber,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      img1: img1 ?? this.img1,
      img2: img2 ?? this.img2,
      img3: img3 ?? this.img3,
      pgType: pgType ?? this.pgType,
      pgCategory: pgCategory ?? this.pgCategory,
      amount: amount ?? this.amount,
      roomCategory: roomCategory ?? this.roomCategory,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}

@JsonSerializable()
class Owner {
  @JsonKey(name: "ownerId")
  final int? ownerId;
  @JsonKey(name: "ownerName")
  final String? ownerName;
  @JsonKey(name: "ownerPhoneNumber")
  final String? ownerPhoneNumber;

  Owner({
    this.ownerId,
    this.ownerName,
    this.ownerPhoneNumber,
  });

  factory Owner.fromJson(Map<String, dynamic> json) => _$OwnerFromJson(json);

  Map<String, dynamic> toJson() => _$OwnerToJson(this);
}
