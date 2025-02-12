import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_flutter/ui/controllers/auth_controller.dart';
import 'package:task_manager_flutter/ui/screens/main_bottom_nav_screen.dart';
import 'package:task_manager_flutter/ui/screens/sign_in_screen.dart';
import 'package:task_manager_flutter/ui/widgets/screen_background.dart';

import '../widgets/app_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String name = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  AuthController authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    moveToNextScreen();
  }

  Future<void> moveToNextScreen() async {
    await Future.delayed(const Duration(seconds: 4));
    bool userLoggedIn = await authController.userLoggedIn();
    if (userLoggedIn) {
      Get.offNamed( MainBottomNavScreen.name);
    } else {
      Get.offNamed(SignInScreen.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ScreenBackground(
        child: Center(
          child: AppLogo(),
        ),
      ),
    );
  }
}
