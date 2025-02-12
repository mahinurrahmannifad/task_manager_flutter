import 'package:get/get.dart';
import 'package:task_manager_flutter/ui/controllers/add_new_task_controller.dart';
import 'package:task_manager_flutter/ui/controllers/auth_controller.dart';
import 'package:task_manager_flutter/ui/controllers/recover_reset_password_controller.dart';
import 'package:task_manager_flutter/ui/controllers/sign_up_controller.dart';
import 'ui/controllers/new_task_controller.dart';
import 'ui/controllers/sign_in_controller.dart';
import 'ui/controllers/update_profile_controller.dart';

class ControllerBinder extends Bindings{
  @override
  void dependencies() {
   Get.lazyPut(()=> SignInController());
   Get.lazyPut(()=> UpdateProfileController());
   Get.lazyPut(()=> AuthController());
   Get.lazyPut(()=> SignUpController());
   Get.lazyPut(()=> RecoverResetPasswordController());
   Get.lazyPut(()=> AddNewTaskController());
   Get.put(NewTaskController());
  }
}