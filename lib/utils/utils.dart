import 'dart:convert';

import 'package:flutter/material.dart';

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

Future<void> handleLogout() async {
  SharedPreferencesUtils.clearAllPref();
  await AuthServices.signOutFromGoogle();
}
