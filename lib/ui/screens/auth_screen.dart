import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phone_email_auth/phone_email_auth.dart';

import '../../utils/index.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();
    FocusNode focusNode = FocusNode();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: context.height,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                color: blueBackground,
                width: double.infinity,
                height: context.height * 0.5,
                child: Image.asset(
                  authImg,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: context.height * 0.54,
              padding: const EdgeInsets.only(
                top: 50,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                    20,
                  ),
                  topRight: Radius.circular(
                    20,
                  ),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: context.width * 0.8,
                    child: TextField(
                      controller: textEditingController,
                      keyboardType: TextInputType.phone,
                      focusNode: focusNode,
                      onTapOutside: (event) {
                        focusNode.unfocus();
                      },
                      cursorColor: Colors.black54,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: Colors.grey.shade500,
                        ),
                        labelText: "Enter Mobile Number",
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey.shade500, width: 4),
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade500,
                          ),
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        // MobileNumberFormatter(),
                        LengthLimitingTextInputFormatter(
                          10,
                        ),
                      ],
                      onChanged: (value) {},
                      // onTap: () {
                      // var hint = await SmsAutoFill().hint;
                      // print(hint);
                      // },
                    ),
                  ),
                  SizedBox(
                    height: context.height * 0.05,
                  ),
                  PhoneLoginButton(
                    borderRadius: 10,
                    buttonColor: Colors.teal,
                    label: 'Login with Phone',
                    onSuccess: (String accessToken, String jwtToken) {
                      if (accessToken.isNotEmpty) {
                        // setState(() {
                        //   useraccessToken = accessToken;
                        //   jwtUserToken = jwtToken;
                        //   hasUserLogin = true;
                        // });
                      }
                    },
                  ),
                  // AppElevatedButton(
                  //   buttonText: sendOtp,
                  //   width: context.width * 0.5,
                  //   onPressed: () async {
                  //     await auth.verifyPhoneNumber(
                  //       phoneNumber: '+917904696681',
                  //       verificationCompleted:
                  //           (PhoneAuthCredential credential) {},
                  //       codeSent: (verificationId, forceResendingToken) {
                  //         print('verificationId$verificationId');
                  //       },
                  //       codeAutoRetrievalTimeout: (verificationId) {},
                  //       verificationFailed: (FirebaseAuthException error) {
                  //         print('auth error $error');
                  //       },
                  //     );
                  //   },
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
