import 'package:flutter/material.dart';
import 'package:pg_finding/utils/index.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    color: Colors.amber.shade50,
                    width: double.infinity,
                    height: context.height * 0.5,
                    child: Center(
                      child: SizedBox(
                        height: context.height * 0.8,
                        width: context.width * 0.8,
                        child: Image.asset(
                          profileAvator,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: context.height * 0.07,
                    left: 10,
                    child: Container(
                      width: 45,
                      height: 40,
                      margin: const EdgeInsets.all(
                        6,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          20,
                        ),
                        color: const Color.fromARGB(
                          227,
                          255,
                          255,
                          255,
                        ),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        color: Colors.black,
                        iconSize: 35,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(
                    20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Name:',
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(
                            width: 18,
                          ),
                          Text(
                            getUserData()?.name ?? 'Buddy',
                            style: const TextStyle(
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Mobile:',
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(
                            width: 18,
                          ),
                          Text(
                            getUserData()?.phoneNumber ?? '',
                            style: const TextStyle(
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 20,
                          ),
                          backgroundColor: Colors.black,
                          overlayColor: Colors.black,
                          surfaceTintColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              12,
                            ),
                          ),
                          side: const BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        onPressed: () async {
                          handleLogout();
                          await Navigator.of(context).pushNamedAndRemoveUntil(
                            initRoute,
                            (route) => false,
                          );
                        },
                        child: const Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
