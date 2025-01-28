import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_flutter/ui/screens/add_new_task_screen.dart';
import 'package:task_manager_flutter/ui/screens/forgot_password_verify_email_screen.dart';
import 'package:task_manager_flutter/ui/screens/forgot_password_verify_otp_screen.dart';
import 'package:task_manager_flutter/ui/screens/main_bottom_nav_screen.dart';
import 'package:task_manager_flutter/ui/screens/reset_password_screen.dart';
import 'package:task_manager_flutter/ui/screens/sign_in_screen.dart';
import 'package:task_manager_flutter/ui/screens/sign_up_screen.dart';
import 'package:task_manager_flutter/ui/screens/splash_screen.dart';
import 'package:task_manager_flutter/ui/screens/update_profile_screen.dart';
import 'package:task_manager_flutter/ui/utils/app_color.dart';

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        navigatorKey: navigatorKey,
        theme: ThemeData(
          colorSchemeSeed: AppColors.themeColor,
          textTheme: const TextTheme(
            titleLarge: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
            titleSmall: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 16),
            fillColor: Colors.white,
            hintStyle:
                TextStyle(fontWeight: FontWeight.w400, color: Colors.grey),
            border: OutlineInputBorder(borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.themeColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              fixedSize: const Size.fromWidth(double.maxFinite),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              foregroundColor: Colors.white,
              textStyle: const TextStyle(fontSize: 16),
            ),
          ),
        ),
        onGenerateRoute: (RouteSettings settings) {
          late Widget widget;
          if (settings.name == '/') {
            widget = const SplashScreen();
          } else if (settings.name == '/sign-in') {
            widget = const SignInScreen();
          } else if (settings.name == '/sign-up') {
            widget = const SignUpScreen();
          } else if (settings.name == '/forgot-password/verify-email') {
            widget = const ForgotPasswordVerifyEmailScreen();
          } else if (settings.name == '/forgot-password/verify-otp') {
            final String email = settings.arguments.toString();
            widget = ForgotPasswordVerifyOtpScreen(email: email);
          } else if (settings.name == '/forgot-password/reset-password') {
            final arguments = settings.arguments as Map<String, String>;
            widget = ResetPasswordScreen(
              email: arguments['email'] ?? '',
              otp: arguments['otp'] ?? '',
            );
          } else if (settings.name == '/home') {
            widget = const MainBottomNavScreen();
          } else if (settings.name == '/add-new-task') {
            widget = const AddNewTaskScreen();
          } else if (settings.name == '/update-profile') {
            widget = const UpdateProfileScreen();
          }

          return MaterialPageRoute(builder: (ctx) => widget);
        });
  }
}
