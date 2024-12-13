// To parse this JSON data, do
//
//     final suggestionModel = suggestionModelFromJson(jsonString);

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'suggestion_model.g.dart';

List<SuggestionModel> suggestionModelFromJson(String str) =>
    List<SuggestionModel>.from(
        json.decode(str).map((x) => SuggestionModel.fromJson(x)));

String suggestionModelToJson(List<SuggestionModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class SuggestionModel {
  @JsonKey(name: "pg_name")
  final String? pg_name;
  @JsonKey(name: "city")
  final String? city;
  @JsonKey(name: "area")
  final String? area;

  SuggestionModel({
    this.pg_name,
    this.city,
    this.area,
  });

  factory SuggestionModel.fromJson(Map<String, dynamic> json) =>
      _$SuggestionModelFromJson(json);

  Map<String, dynamic> toJson() => _$SuggestionModelToJson(this);
}
