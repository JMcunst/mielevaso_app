import 'package:firebase_core/firebase_core.dart';
import 'package:mielevaso_app/auths/auth_controller.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:mielevaso_app/screens/MainPage.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then((value) => Get.put(AuthController()));
  runApp(const MyApp());
}

ThemeData appTheme = ThemeData(
  primaryColor: Color(0xFFA9907E),
  secondaryHeaderColor: Color(0xFFF3DEBA),
  colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Color(0xFF675D50)),
  backgroundColor: Color(0xFFABC4AA),
);


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '로그인 앱',
      theme: appTheme,
      home: const MainPage()
    );
  }

  @override
  void initState() {
    super.initState();

  }

  @override
  dispose() async {
    super.dispose();

  }

}