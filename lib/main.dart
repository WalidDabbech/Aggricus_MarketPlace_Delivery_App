import 'package:aggricus_delivery_app/providers/auth_provider.dart';
import 'package:aggricus_delivery_app/screens/home_screen.dart';
import 'package:aggricus_delivery_app/screens/login_screen.dart';
import 'package:aggricus_delivery_app/screens/register_screen.dart';
import 'package:aggricus_delivery_app/screens/reset_password_screen.dart';
import 'package:aggricus_delivery_app/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

void main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_)=>AuthProvider()),
  ],
    child: MyApp(),
  )
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Delivery App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id:(context)=>SplashScreen(),
        LoginScreen.id:(context)=>LoginScreen(),
        HomeScreen.id:(context)=>HomeScreen(),
        ResetPasswordScreen.id:(context)=>ResetPasswordScreen(),
        RegisterScreen.id:(context)=>RegisterScreen(),



      },
      builder: EasyLoading.init(),);
  }
}
