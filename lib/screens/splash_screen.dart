import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../config/routes.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushNamed(context, AppRoutes.home);
      });
    });
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey, width: 4),
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/icons/logo1.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
