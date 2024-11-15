// To parse this JSON data, do
//
//     final baseUrlModel = baseUrlModelFromJson(jsonString);

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'base_url.g.dart';

List<BaseUrlModel> baseUrlModelFromJson(String str) => List<BaseUrlModel>.from(
    json.decode(str).map((x) => BaseUrlModel.fromJson(x)));

String baseUrlModelToJson(List<BaseUrlModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class BaseUrlModel {
  final String? baseUrl;
  final String? id;

  BaseUrlModel({
    this.baseUrl,
    this.id,
  });

  factory BaseUrlModel.fromJson(Map<String, dynamic> json) =>
      _$BaseUrlModelFromJson(json);

  Map<String, dynamic> toJson() => _$BaseUrlModelToJson(this);
}
