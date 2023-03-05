import 'dart:async';
import 'package:flutter/material.dart';
import 'package:letzpay/utils/assets_path.dart';

class SplashScreenVieW extends StatefulWidget {
  const SplashScreenVieW({super.key});

  @override
  State<SplashScreenVieW> createState() => _SplashScreenVieWState();
}

class _SplashScreenVieWState extends State<SplashScreenVieW> {
  @override
  void initState() {
    super.initState();
    //set Timer after 3 sec redirect to login screen
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushNamed(
              context,
              '/login',
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          //set Splash screen image
          child: Image.asset(
            splashScreenImage,
            fit: BoxFit.cover,
          )),
    );
  }
}
