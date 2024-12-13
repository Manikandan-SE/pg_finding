// To parse this JSON data, do
//
//     final localityModel = localityModelFromJson(jsonString);

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'locality_model.g.dart';

List<LocalityModel> localityModelFromJson(String str) =>
    List<LocalityModel>.from(
        json.decode(str).map((x) => LocalityModel.fromJson(x)));

String localityModelToJson(List<LocalityModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class LocalityModel {
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "locality")
  final String? locality;
  @JsonKey(name: "img")
  final String? img;

  LocalityModel({
    this.id,
    this.locality,
    this.img,
  });

  factory LocalityModel.fromJson(Map<String, dynamic> json) =>
      _$LocalityModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocalityModelToJson(this);
}
