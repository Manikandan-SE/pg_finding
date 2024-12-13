import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/index.dart';
import 'index.dart';

extension MediaQueryValues on BuildContext {
  double get height => MediaQuery.sizeOf(this).height;
  double get width => MediaQuery.sizeOf(this).width;
}

//Color
const mPrimary = Color(0xFF2596be);

const mLoginButtonColor = Color(0x9DA00303);

const blueBackground = Color(0xffc8efff);

// const blue = Color(0xFF2596be);
// const blueBackground = Color(0xff64aeef);
// const buttonColor = Color(0xFF56a7f0);
// const orangeContainer = Color(0xFFf8c63b);
// const pawColor1 = Color(0xFFf7b803);
// const pawColor2 = Color(0xFF3494ec);
// const color2 =  Color(0xffffd690);
// const color1 = Color(0xffcaeda1);
// const color3 = Color(0xffa4e1ff);
// const black = Colors.black;

Future<void> setUserData(UserModel userDetails) async {
  await SharedPreferencesUtils.setString(
    userDataKey,
    jsonEncode(
      userDetails,
    ),
  );
}

UserModel? getUserData() {
  String userData = SharedPreferencesUtils.getString(
    userDataKey,
  );
  if (userData.isNotEmpty) {
    Map<String, dynamic> userJsonData = jsonDecode(
      userData,
    );
    return UserModel.fromJson(userJsonData);
  }
  return null;
}

Future<void> setBaseUrl(String? baseUrl) async {
  await SharedPreferencesUtils.setString(
    baseUrlKey,
    baseUrl ?? '',
  );
}

String? getBaseUrl() {
  String baseUrl = SharedPreferencesUtils.getString(
    baseUrlKey,
  );
  if (baseUrl.isNotEmpty) {
    return baseUrl;
  }
  return null;
}

Future<void> setUserId(String? userId) async {
  await SharedPreferencesUtils.setString(
    userIdKey,
    userId ?? '',
  );
}

String? getUserId() {
  String userId = SharedPreferencesUtils.getString(
    userIdKey,
  );
  if (userId.isNotEmpty) {
    return userId;
  }
  return null;
}

Future<void> handleLogout() async {
  await SharedPreferencesUtils.clearAllPref();
  //await AuthServices.signOutFromGoogle();
}

String getPgCategory({String? pgCategory}) {
  switch (pgCategory) {
    case 'Boy':
      return 'Boys PG';
    case 'Girl':
      return 'Girls PG';
    case 'Co-Living':
      return 'Co-Living';
    default:
      return '';
  }
}

String getPgType({String? pgType}) {
  switch (pgType) {
    case 'Double':
      return 'Double sharing';
    case 'Single':
      return 'Single';
    case 'Triple':
      return 'Triple sharing';
    default:
      return '';
  }
}

String formatAmount(String? amount) {
  if (amount == null) return '0';
  // Format the amount as INR with commas
  final formatCurrency = NumberFormat.currency(
    locale: 'en_IN', // For Indian locale
    symbol: '₹', // INR symbol
    decimalDigits: 0,
  );
  return formatCurrency.format(double.tryParse(amount) ?? 0);
}
