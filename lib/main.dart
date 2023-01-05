import 'package:doctors_online/enums.dart';
import 'package:doctors_online/providers/app_provider.dart';
import 'package:doctors_online/providers/auth_provider.dart';
import 'package:doctors_online/providers/lang_provider.dart';
import 'package:doctors_online/shared_preferences/shared_preferences.dart';
import 'package:doctors_online/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'models/consultation_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Shared Preferences
  await SharedPreferencesController().initSharedPreferences();

  /// Firebase
  await Firebase.initializeApp();
  // await FbNotifications;
  FirebaseMessaging.instance.getToken().then((value) {
    SharedPreferencesController()
        .setter(type: String, key: SpKeys.fcmToken, value: value ?? '');
    print('Fcm Token ==> $value');
    print('Finish');
  }).catchError((onError) {});
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  FirebaseMessaging.instance.subscribeToTopic('general');

  /// Setter
  await setter();

  /// App
  runApp(const MyApp());
}

Future<void> setter() async {
  if (SharedPreferencesController()
          .getter(type: String, key: SpKeys.lang)
          .toString() ==
      '') {
    await SharedPreferencesController()
        .setter(type: String, key: SpKeys.lang, value: 'en');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LangProviders>(
          create: (context) => LangProviders(),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProvider<AppProvider>(
          create: (context) => AppProvider(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) {
          return MaterialApp(
            home: const SplashScreen(),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: const [
              Locale('ar'),
              Locale('en'),
            ],
            locale: Locale(Provider.of<LangProviders>(context).lang_),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
