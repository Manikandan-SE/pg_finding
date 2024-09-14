import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/index.dart';
import '../widgets/index.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

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
                        MobileNumberFormatter(),
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
                  AppElevatedButton(
                    buttonText: sendOtp,
                    width: context.width * 0.5,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
