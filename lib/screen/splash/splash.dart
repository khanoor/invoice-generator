import 'dart:async';

import 'package:flutter/material.dart';
import 'package:invoice_generater/screen/global/global.dart';
import 'package:invoice_generater/screen/home.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    var _duration = const Duration(seconds: 3);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Home()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Image(
              height: 200,
              image: AssetImage('images/invoice.png'),
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Invoice Generator",
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, color: app_color),
            ),
          ],
        ),
      ),
    );
  }
}
