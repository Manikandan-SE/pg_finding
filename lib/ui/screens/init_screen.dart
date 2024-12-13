// import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:pg_finding/models/index.dart';
import 'package:phone_email_auth/phone_email_auth.dart';
import 'package:video_player/video_player.dart';

import '../../utils/index.dart';

class InitScreen extends StatefulWidget {
  const InitScreen({super.key});

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen>
// with SingleTickerProviderStateMixin
{
  VideoPlayerController? _controller;
  final phoneEmail = PhoneEmail();

  @override
  void initState() {
    super.initState();
    initBaseUrl();
    _controller = VideoPlayerController.asset(animatedLogo);
    _controller?.initialize();
    _controller?.play();
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  void initBaseUrl() async {
    await AppServices().fetchBaseUrl();
  }

  @override
  void dispose() {
    // SystemChrome.setEnabledSystemUIMode(
    //   SystemUiMode.manual,
    //   overlays: SystemUiOverlay.values,
    // );
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child:
                //Lottie.asset(appLogoLottie),
                _controller != null
                    ? AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        child: VideoPlayer(_controller!),
                      )
                    : Image.asset(
                        appLogo,
                      ),
          ),
          if (getUserData() == null) ...[
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Container(
                  //   height: context.height * 0.05,
                  //   width: double.infinity,
                  //   padding: const EdgeInsets.only(
                  //     left: 30,
                  //     right: 30,
                  //   ),
                  //   child: ElevatedButton(
                  //     style: ElevatedButton.styleFrom(
                  //       foregroundColor: Colors.black,
                  //       backgroundColor: Colors.white,
                  //     ),
                  //     onPressed: () async {
                  //       var credential = await AuthServices.signInWithGoogle();
                  //       print('credential $credential');
                  //       if (credential != null) {
                  //         var userDetails = UserModel(
                  //           name: credential.user?.displayName ?? '',
                  //           email: credential.user?.email ?? '',
                  //         );
                  //         await SharedPreferencesUtils.setString(
                  //           userDataKey,
                  //           jsonEncode(
                  //             userDetails,
                  //           ),
                  //         );
                  //         Navigator.of(context).pushReplacementNamed(
                  //           pgRoute,
                  //         );
                  //       }
                  //     },
                  //     child: Padding(
                  //       padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                  //       child: Row(
                  //         mainAxisSize: MainAxisSize.min,
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           Image.asset(
                  //             googleLogo,
                  //             height: 24,
                  //             width: 24,
                  //           ),
                  //           SizedBox(
                  //             width: context.width * 0.03,
                  //           ),
                  //           const Text(
                  //             signInWithGoogle,
                  //             style: TextStyle(
                  //               fontSize: 18,
                  //               color: Colors.black54,
                  //               fontWeight: FontWeight.w600,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: context.height * 0.02,
                  // ),
                  Container(
                    height: context.height * 0.09,
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                      left: 30,
                      right: 30,
                      bottom: 30,
                    ),
                    child: PhoneLoginButton(
                      borderRadius: 30,
                      buttonColor: mLoginButtonColor,
                      buttonTextStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      label: loginWithPhone,
                      onSuccess: (String accessToken, String jwtToken) {
                        if (accessToken.isNotEmpty) {
                          PhoneEmail.getUserInfo(
                            accessToken: accessToken,
                            clientId: phoneEmail.clientId,
                            onSuccess: (userData) async {
                              var userDetails = UserModel(
                                name: (userData.firstName != null &&
                                        userData.firstName!.isNotEmpty)
                                    ? '${userData.firstName} ${(userData.lastName != null && userData.lastName!.isNotEmpty) ? userData.lastName : ''}'
                                        .trim()
                                    : 'Buddy',
                                phoneNumber: userData.phoneNumber ?? '',
                              );
                              await AppServices().postUserMobileNumber(
                                  phoneNumber: userData.phoneNumber ?? '');
                              await setUserData(userDetails);
                              Navigator.of(context).pushReplacementNamed(
                                pgRoute,
                              );
                            },
                          );
                        }
                      },
                      onFailure: (_) {
                        Flushbar(
                          message: "Something went wrong",
                          flushbarPosition: FlushbarPosition.TOP,
                          duration: const Duration(seconds: 3),
                          flushbarStyle: FlushbarStyle.FLOATING,
                          margin: const EdgeInsets.all(12),
                          borderRadius: BorderRadius.circular(8),
                          icon: const Icon(
                            Icons.info_outline,
                            size: 28.0,
                            color: Colors.white,
                          ),
                          backgroundColor: mLoginButtonColor,
                        ).show(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }
}
