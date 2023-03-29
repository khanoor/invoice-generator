import 'package:flutter/material.dart';
import 'package:invoice_generater/screen/global/global.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:invoice_generater/screen/splash/splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("invoice");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: app_color_full,
      ),
      home: Splash(),
    );
  }
}
