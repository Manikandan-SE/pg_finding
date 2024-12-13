// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locality_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocalityModel _$LocalityModelFromJson(Map<String, dynamic> json) =>
    LocalityModel(
      id: (json['id'] as num?)?.toInt(),
      locality: json['locality'] as String?,
      img: json['img'] as String?,
    );

Map<String, dynamic> _$LocalityModelToJson(LocalityModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'locality': instance.locality,
      'img': instance.img,
    };
