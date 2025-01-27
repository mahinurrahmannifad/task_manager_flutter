import 'dart:convert';

import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';
import '../screens/sign_in_screen.dart';
import '../screens/update_profile_screen.dart';
import '../utils/app_color.dart';

class TMAppBar extends StatefulWidget implements PreferredSizeWidget {
  const TMAppBar({
    super.key,
    this.fromUpdateProfile = false,
    required this.textTheme,
  });

  final bool fromUpdateProfile;
  final TextTheme textTheme;

  @override
  State<TMAppBar> createState() => _TMAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _TMAppBarState extends State<TMAppBar> {
  @override
  void initState() {
    super.initState();
    _refreshUserData();
  }

  Future<void> _refreshUserData() async {
    await AuthController.getUserData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return AppBar(
      backgroundColor: AppColors.themeColor,
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: MemoryImage(
                base64Decode(AuthController.userModel?.photo ?? ''),
              ),
              onBackgroundImageError: (_, __) =>
                  const Icon(Icons.person_outline),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  if (!widget.fromUpdateProfile) {
                    Navigator.pushNamed(context, UpdateProfileScreen.name);
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AuthController.userModel?.fullName ?? '',
                      style:
                          textTheme.titleSmall?.copyWith(color: Colors.white),
                    ),
                    Text(
                      AuthController.userModel?.email ?? '',
                      style: textTheme.bodySmall?.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: () async {
                await AuthController.clearUserData();
                Navigator.pushNamedAndRemoveUntil(
                    context, SignInScreen.name, (predicate) => false);
              },
              icon: const Icon(Icons.logout),
            )
          ],
        ),
      ),
    );
  }
}
