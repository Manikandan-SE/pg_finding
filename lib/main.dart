import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pg_finding/utils/index.dart';
import 'package:phone_email_auth/phone_email_auth.dart';

import 'router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesUtils.init();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: '',
            appId: '',
            messagingSenderId: '',
            projectId: '',
          ),
        )
      : await Firebase.initializeApp();
  PhoneEmail.initializeApp(
    clientId: '',
  );
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
    ],
  );
  runApp(
    const PgFindingApp(),
  );
}

class PgFindingApp extends StatelessWidget {
  const PgFindingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pg Finding App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'FiraSansExtraCondensed',
        useMaterial3: true,
      ),
      // home: const SplashScreen(),
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: getUserData() != null ? pgRoute : initRoute,
    );
  }
}
