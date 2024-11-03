import 'package:ayurvedic_center/providers/Patientlist_provider.dart';
import 'package:ayurvedic_center/providers/branch_list.dart';
import 'package:ayurvedic_center/providers/login_providers.dart';
import 'package:ayurvedic_center/providers/treatment_list.dart';
import 'package:ayurvedic_center/screens/home_screen.dart';
import 'package:ayurvedic_center/screens/login_screen.dart';
import 'package:ayurvedic_center/screens/patient_registeration.dart';
import 'package:ayurvedic_center/screens/splash_screen.dart';
import 'package:flutter/material.dart';

import 'config/routes.dart';
import 'package:provider/provider.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => PatientProvider()),
        ChangeNotifierProvider(create: (_) => BranchList()),
        ChangeNotifierProvider(create: (_) => TreatmentList()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        initialRoute: AppRoutes.splash,
        routes: getAppRoute(),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
      ),
    );
  }
}
Map<String,WidgetBuilder> getAppRoute(){
  return{
    AppRoutes.splash:(context)=> const SplashScreen(),
    AppRoutes.login:(context)=> LoginScreen(),
    AppRoutes.home:(context)=> const HomeScreen(),
    AppRoutes.register:(context)=> Registration(),
  };
}

