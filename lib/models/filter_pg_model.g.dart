// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter_pg_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilterPgModel _$FilterPgModelFromJson(Map<String, dynamic> json) =>
    FilterPgModel(
      pgId: (json['pgId'] as num?)?.toInt(),
      owner: json['owner'] == null
          ? null
          : Owner.fromJson(json['owner'] as Map<String, dynamic>),
      pg_name: json['pg_name'] as String?,
      pgAddress: json['pgAddress'] as String?,
      city: json['city'] as String?,
      pgPhoneNumber: json['pgPhoneNumber'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      img1: json['img1'] as String?,
      img2: json['img2'] as String?,
      img3: json['img3'] as String?,
      pgType: json['pgType'] as String?,
      pgCategory: json['pgCategory'] as String?,
      amount: json['amount'] as String?,
      roomCategory: json['roomCategory'] as String?,
      isSaved: json['isSaved'] as bool?,
    );

Map<String, dynamic> _$FilterPgModelToJson(FilterPgModel instance) =>
    <String, dynamic>{
      'pgId': instance.pgId,
      'owner': instance.owner,
      'pg_name': instance.pg_name,
      'pgAddress': instance.pgAddress,
      'city': instance.city,
      'pgPhoneNumber': instance.pgPhoneNumber,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'img1': instance.img1,
      'img2': instance.img2,
      'img3': instance.img3,
      'pgType': instance.pgType,
      'pgCategory': instance.pgCategory,
      'amount': instance.amount,
      'roomCategory': instance.roomCategory,
      'isSaved': instance.isSaved,
    };

Owner _$OwnerFromJson(Map<String, dynamic> json) => Owner(
      ownerId: (json['ownerId'] as num?)?.toInt(),
      ownerName: json['ownerName'] as String?,
      ownerPhoneNumber: json['ownerPhoneNumber'] as String?,
    );

Map<String, dynamic> _$OwnerToJson(Owner instance) => <String, dynamic>{
      'ownerId': instance.ownerId,
      'ownerName': instance.ownerName,
      'ownerPhoneNumber': instance.ownerPhoneNumber,
    };
