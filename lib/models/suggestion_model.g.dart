// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'suggestion_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SuggestionModel _$SuggestionModelFromJson(Map<String, dynamic> json) =>
    SuggestionModel(
      pg_name: json['pg_name'] as String?,
      city: json['city'] as String?,
      area: json['area'] as String?,
    );

Map<String, dynamic> _$SuggestionModelToJson(SuggestionModel instance) =>
    <String, dynamic>{
      'pg_name': instance.pg_name,
      'city': instance.city,
      'area': instance.area,
    };
