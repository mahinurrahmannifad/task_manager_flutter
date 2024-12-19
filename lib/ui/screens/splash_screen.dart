import 'package:flutter/material.dart';
import 'package:task_manager_flutter/ui/screens/sign_in_screen.dart';
import 'package:task_manager_flutter/ui/widgets/app_logo.dart';
import 'package:task_manager_flutter/ui/widgets/screen_background.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String name = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    moveToNextScreen();
  }

Future<void>moveToNextScreen() async{
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pushReplacementNamed(context, SignInScreen.name);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
          child: Center(
            child: AppLogo(),
          )
      ),
    );
  }
}