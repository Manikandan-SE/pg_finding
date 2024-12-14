// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingListModel _$BookingListModelFromJson(Map<String, dynamic> json) =>
    BookingListModel(
      bookingId: (json['bookingId'] as num?)?.toInt(),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      pgDetails: json['pgDetails'] == null
          ? null
          : PgDetails.fromJson(json['pgDetails'] as Map<String, dynamic>),
      bookingDate: json['bookingDate'] as String?,
      booked: json['booked'] as String?,
      amount: json['amount'] as String?,
    );

Map<String, dynamic> _$BookingListModelToJson(BookingListModel instance) =>
    <String, dynamic>{
      'bookingId': instance.bookingId,
      'user': instance.user,
      'pgDetails': instance.pgDetails,
      'bookingDate': instance.bookingDate,
      'booked': instance.booked,
      'amount': instance.amount,
    };

PgDetails _$PgDetailsFromJson(Map<String, dynamic> json) => PgDetails(
      pgId: (json['pgId'] as num?)?.toInt(),
      owner: json['owner'] == null
          ? null
          : BookingListOwner.fromJson(json['owner'] as Map<String, dynamic>),
      pgName: json['pg_name'] as String?,
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
      isSaved: json['isSaved'] as bool?,
      roomCategory: json['roomCategory'] as String?,
    );

Map<String, dynamic> _$PgDetailsToJson(PgDetails instance) => <String, dynamic>{
      'pgId': instance.pgId,
      'owner': instance.owner,
      'pg_name': instance.pgName,
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
      'isSaved': instance.isSaved,
      'roomCategory': instance.roomCategory,
    };

BookingListOwner _$BookingListOwnerFromJson(Map<String, dynamic> json) =>
    BookingListOwner(
      ownerId: (json['ownerId'] as num?)?.toInt(),
      ownerName: json['ownerName'] as String?,
      ownerPhoneNumber: json['ownerPhoneNumber'] as String?,
    );

Map<String, dynamic> _$BookingListOwnerToJson(BookingListOwner instance) =>
    <String, dynamic>{
      'ownerId': instance.ownerId,
      'ownerName': instance.ownerName,
      'ownerPhoneNumber': instance.ownerPhoneNumber,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      userId: (json['userId'] as num?)?.toInt(),
      name: json['name'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      otp: json['otp'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'userId': instance.userId,
      'name': instance.name,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'password': instance.password,
      'otp': instance.otp,
    };
