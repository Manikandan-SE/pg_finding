// To parse this JSON data, do
//
//     final bookingListModel = bookingListModelFromJson(jsonString);

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'booking_list_model.g.dart';

List<BookingListModel> bookingListModelFromJson(String str) =>
    List<BookingListModel>.from(
        json.decode(str).map((x) => BookingListModel.fromJson(x)));

String bookingListModelToJson(List<BookingListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class BookingListModel {
  @JsonKey(name: "bookingId")
  final int? bookingId;
  @JsonKey(name: "user")
  final User? user;
  @JsonKey(name: "pgDetails")
  final PgDetails? pgDetails;
  @JsonKey(name: "bookingDate")
  final String? bookingDate;
  @JsonKey(name: "booked")
  final String? booked;
  @JsonKey(name: "amount")
  final String? amount;
  @JsonKey(name: "transactionId")
  final String? transactionId;

  BookingListModel({
    this.bookingId,
    this.user,
    this.pgDetails,
    this.bookingDate,
    this.booked,
    this.amount,
    this.transactionId,
  });

  factory BookingListModel.fromJson(Map<String, dynamic> json) =>
      _$BookingListModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookingListModelToJson(this);

  BookingListModel copyWith({
    int? bookingId,
    User? user,
    PgDetails? pgDetails,
    String? bookingDate,
    String? booked,
    String? amount,
    String? transactionId,
  }) {
    return BookingListModel(
      bookingId: bookingId ?? this.bookingId,
      user: user ?? this.user,
      pgDetails: pgDetails ?? this.pgDetails,
      bookingDate: bookingDate ?? this.bookingDate,
      booked: booked ?? this.booked,
      amount: amount ?? this.amount,
      transactionId: transactionId ?? this.transactionId,
    );
  }
}

@JsonSerializable()
class PgDetails {
  @JsonKey(name: "pgId")
  final int? pgId;
  @JsonKey(name: "owner")
  final BookingListOwner? owner;
  @JsonKey(name: "pg_name")
  final String? pgName;
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
  @JsonKey(name: "isSaved")
  final bool? isSaved;
  @JsonKey(name: "roomCategory")
  final String? roomCategory;
  @JsonKey(name: "booking_status")
  final String? booking_status;

  PgDetails({
    this.pgId,
    this.owner,
    this.pgName,
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
    this.isSaved,
    this.roomCategory,
    this.booking_status,
  });

  factory PgDetails.fromJson(Map<String, dynamic> json) =>
      _$PgDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$PgDetailsToJson(this);
}

@JsonSerializable()
class BookingListOwner {
  @JsonKey(name: "ownerId")
  final int? ownerId;
  @JsonKey(name: "ownerName")
  final String? ownerName;
  @JsonKey(name: "ownerPhoneNumber")
  final String? ownerPhoneNumber;

  BookingListOwner({
    this.ownerId,
    this.ownerName,
    this.ownerPhoneNumber,
  });

  factory BookingListOwner.fromJson(Map<String, dynamic> json) =>
      _$BookingListOwnerFromJson(json);

  Map<String, dynamic> toJson() => _$BookingListOwnerToJson(this);
}

@JsonSerializable()
class User {
  @JsonKey(name: "userId")
  final int? userId;
  @JsonKey(name: "name")
  final String? name;
  @JsonKey(name: "phoneNumber")
  final String? phoneNumber;
  @JsonKey(name: "email")
  final String? email;
  @JsonKey(name: "password")
  final String? password;
  @JsonKey(name: "otp")
  final String? otp;

  User({
    this.userId,
    this.name,
    this.phoneNumber,
    this.email,
    this.password,
    this.otp,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
