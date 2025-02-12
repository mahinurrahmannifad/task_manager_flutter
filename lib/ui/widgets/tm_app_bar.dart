// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
//
// import '../controllers/auth_controller.dart';
// import '../screens/sign_in_screen.dart';
// import '../screens/update_profile_screen.dart';
// import '../utils/app_color.dart';
//
// class TMAppBar extends StatefulWidget implements PreferredSizeWidget {
//   const TMAppBar({
//     super.key,
//     this.fromUpdateProfile = false,
//     required this.textTheme,
//   });
//
//   final bool fromUpdateProfile;
//   final TextTheme textTheme;
//
//   @override
//   State<TMAppBar> createState() => _TMAppBarState();
//
//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }
//
// class _TMAppBarState extends State<TMAppBar> {
//   final authController = Get.find<AuthController>();
//   @override
//   void initState() {
//     super.initState();
//     _refreshUserData();
//   }
//
//   Future<void> _refreshUserData() async {
//     await AuthController.();
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final textTheme = Theme.of(context).textTheme;
//     return AppBar(
//       backgroundColor: AppColors.themeColor,
//       title: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Row(
//           children: [
//             CircleAvatar(
//               radius: 16,
//               backgroundImage: MemoryImage(
//                 base64Decode(AuthController.userModel?.photo ?? ''),
//               ),
//               onBackgroundImageError: (_, __) =>
//                   const Icon(Icons.person_outline),
//             ),
//             const SizedBox(width: 8),
//             Expanded(
//               child: GestureDetector(
//                 onTap: () {
//                   if (!widget.fromUpdateProfile) {
//                     Navigator.pushNamed(context, UpdateProfileScreen.name);
//                   }
//                 },
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       AuthController.?.fullName ?? '',
//                       style:
//                           textTheme.titleSmall?.copyWith(color: Colors.white),
//                     ),
//                     Text(
//                       AuthController.?.email ?? '',
//                       style: textTheme.bodySmall?.copyWith(color: Colors.white),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             IconButton(
//               onPressed: () async {
//                 await AuthController();
//                 Navigator.pushNamedAndRemoveUntil(
//                     context, SignInScreen.name, (predicate) => false);
//               },
//               icon: const Icon(Icons.logout),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }


// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:task_manager_flutter/ui/screens/sign_in_screen.dart';
// import 'package:task_manager_flutter/ui/screens/update_profile_screen.dart';
// import 'package:task_manager_flutter/ui/utils/app_color.dart';
//
// import '../controllers/auth_controller.dart';
// import 'alert_dialog.dart';
//
//
// class TaskManagerAppBar extends StatelessWidget implements PreferredSizeWidget {
//   const TaskManagerAppBar({
//     super.key,
//     required this.textTheme,
//     this.fromUpdateProfile = false,
//   });
//
//   final bool fromUpdateProfile;
//   final TextTheme textTheme;
//
//   @override
//   Size get preferredSize => const Size.fromHeight(56);
//
//   @override
//   Widget build(BuildContext context) {
//     final authController = Get.find<AuthController>();
//
//     return AppBar(
//       backgroundColor: AppColors.themeColor,
//       title: Row(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Obx(() => CircleAvatar(
//               backgroundImage: _getValidImage(authController.userModel.value?.photo),
//               child: (authController.userModel.value?.photo == null ||
//                   authController.userModel.value!.photo!.isEmpty)
//                   ? const Icon(Icons.person_outline)
//                   : null,
//             )),
//           ),
//           Expanded(
//             child: GestureDetector(
//               onTap: () async {
//                 final result = await Navigator.pushNamed(context, UpdateProfileScreen.name);
//                 if (result == true) {
//                   await authController.getUserData(); // Update AppBar after returning
//                 }
//               },
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Obx(() => Text(
//                     authController.userModel.value?.fullName ?? 'Unknown User',
//                     style: textTheme.titleLarge?.copyWith(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   )),
//                   Obx(() => Text(
//                     authController.userModel.value?.email ?? 'Unknown Email',
//                     style: textTheme.titleSmall?.copyWith(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   )),
//                 ],
//               ),
//             ),
//           ),
//           IconButton(
//             onPressed: () {
//               showAlertDialog(
//                 context,
//                 text: const Text(
//                   'Logout!',
//                   style: TextStyle(fontSize: 20),
//                 ),
//                 message: 'Are you sure you want to logout?',
//                 confirmAction: () async {
//                   await authController.clearUserData();
//                   Navigator.pushNamedAndRemoveUntil(
//                     context,
//                     SignInScreen.name,
//                         (route) => false,
//                   );
//                 }, confirmAction: () {  },
//               );
//             },
//             icon: const Icon(Icons.output),
//           ),
//         ],
//       ),
//     );
//   }
//
//   ImageProvider? _getValidImage(String? base64String) {
//     try {
//       if (base64String != null && base64String.isNotEmpty) {
//         final cleanedBase64 = base64String.startsWith("data:image")
//             ? base64String.split(",").last
//             : base64String;
//         return MemoryImage(base64Decode(cleanedBase64));
//       }
//     } catch (e) {
//       debugPrint('Error decoding base64 image: $e');
//     }
//     return null; // Return null if decoding fails
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_flutter/ui/screens/sign_in_screen.dart';
import 'package:task_manager_flutter/ui/screens/update_profile_screen.dart';
import 'package:task_manager_flutter/ui/utils/app_color.dart';
import '../controllers/auth_controller.dart';
import 'alert_dialog.dart';

class TmAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TmAppBar({
    super.key,
    required this.textTheme,
    this.fromUpdateProfile = false,
  });

  final bool fromUpdateProfile;
  final TextTheme textTheme;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return AppBar(
      backgroundColor: AppColors.themeColor,
      title: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(() => CircleAvatar(
              backgroundImage: _getValidImage(authController.userModel.value?.photo),
              child: (authController.userModel.value?.photo == null ||
                  authController.userModel.value!.photo!.isEmpty)
                  ? const Icon(Icons.person_outline)
                  : null,
            )),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                final result = await Navigator.pushNamed(context, UpdateProfileScreen.name);
                if (result == true) {
                  authController.getUserData(); // No need for await
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => Text(
                    authController.userModel.value?.fullName ?? 'Unknown User',
                    style: textTheme.titleLarge?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )),
                  Obx(() => Text(
                    authController.userModel.value?.email ?? 'Unknown Email',
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              showAlertDialog(
                context,
                text: const Text(
                  'Logout!',
                  style: TextStyle(fontSize: 20),
                ),
                message: 'Are you sure you want to logout?',
                confirmAction: () async {
                  await authController.clearUserData();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    SignInScreen.name,
                        (route) => false,
                  );
                },
              );
            },
            icon: const Icon(Icons.output),
          ),
        ],
      ),
    );
  }

  ImageProvider? _getValidImage(String? base64String) {
    try {
      if (base64String != null && base64String.isNotEmpty) {
        final cleanedBase64 = base64String.startsWith("data:image")
            ? base64String.split(",").last
            : base64String;
        return MemoryImage(base64Decode(cleanedBase64));
      }
    } catch (e) {
      debugPrint('Error decoding base64 image: $e');
    }
    return null; // Return null if decoding fails
  }
}


