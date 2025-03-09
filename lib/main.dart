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

//Firebase

// {
//   "status": "success",
//   "result": {
//     "@type": "type.googleapis.com/google.firebase.service.v1beta1.AndroidApp",
//     "name": "projects/pg-finding-8c460/androidApps/1:647564243012:android:81e720a0a78f8a62a6cc11",
//     "appId": "1:647564243012:android:81e720a0a78f8a62a6cc11",
//     "displayName": "pg_finding",
//     "projectId": "pg-finding-8c460",
//     "packageName": "com.example.pg_finding",
//     "apiKeyId": "44ffdf20-57c7-42eb-bca1-4e3d837f92a0",
//     "state": "ACTIVE",
//     "expireTime": "1970-01-01T00:00:00Z",
//     "etag": "1_63dd8431-4637-4f8b-931d-f7095cf45905"
//   }
// }
