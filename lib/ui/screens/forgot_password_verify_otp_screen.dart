
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager_flutter/data/services/network_caller.dart';
import 'package:task_manager_flutter/data/utils/urls.dart';
import 'package:task_manager_flutter/ui/screens/reset_password_screen.dart';
import 'package:task_manager_flutter/ui/widgets/screen_background.dart';
import 'package:task_manager_flutter/ui/widgets/snack_bar_message.dart';

class ForgotPasswordVerifyOtpScreen extends StatefulWidget {
  const ForgotPasswordVerifyOtpScreen({super.key, required this.email});

  static const String name = '/forgot-password/verify-otp';

  final String email;

  @override
  State<ForgotPasswordVerifyOtpScreen> createState() =>
      _ForgotPasswordVerifyOtpScreenState();
}

class _ForgotPasswordVerifyOtpScreenState
    extends State<ForgotPasswordVerifyOtpScreen> {
  final TextEditingController _otpTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 100),
                Text(
                  'Pin Verification',
                  style: textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  'A 6 digits of OTP has been sent to your email address',
                  style: textTheme.titleMedium,
                ),
                const SizedBox(height: 24),
                Form(
                    key: _formKey,
                    child: PinCodeTextField(
                      validator: (String? value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            value.length != 6) {
                          return 'Enter a valid OTP number';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      length: 6,
                      obscureText: false,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor: Colors.white,
                        selectedFillColor: Colors.white,
                        inactiveFillColor: Colors.white,
                      ),
                      animationDuration: const Duration(milliseconds: 300),
                      backgroundColor: Colors.transparent,
                      enableActiveFill: true,
                      controller: _otpTEController,
                      appContext: context,
                    )
                ),
                const SizedBox(height: 12,),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _getPinVerify();
                    }
                  },
                  child: const Icon(Icons.arrow_circle_right_outlined),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _getPinVerify() async {
    // API Call
    NetworkResponse response = await NetworkCaller.getRequest(
        url: Urls.recoverVerifyOTPlUrl(widget.email, _otpTEController.text));

    if (response.responseData?['status'] == 'success') {
      Navigator.pushNamed(
          context,
          arguments: {'otp': _otpTEController.text, 'email': widget.email},
          ResetPasswordScreen.name);
    } else {
     showSnackBarMessage(context, 'Invalid OTP');
    }
  }

  @override
  void dispose() {
    _otpTEController.dispose();
    super.dispose();
  }
}