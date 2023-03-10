import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letzpay/common/common.dart';
import 'package:letzpay/core/utils.dart';
import 'package:letzpay/features/auth/controller/auth_controller.dart';
import 'package:letzpay/theme/pallete.dart';
import 'package:letzpay/theme/text.dart';

import '../../../common/common_button.dart';

class LoginViewNew extends ConsumerWidget {
  LoginViewNew({Key? key}) : super(key: key);
  var mobileController = TextEditingController();
  var pinController = TextEditingController();
  String pinEntered = '';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: Pallete.whiteColor,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const LPText(
                'Welcome back.',
                weight: TextWeight.bold,
                size: TextSize.large,
              ),
              const SizedBox(height: 8),
              const LPText(
                'Log in to your account',
                weight: TextWeight.bold,
                size: TextSize.medium,
              ),
              const SizedBox(height: 24),
              const LPText(
                'Mobile Number',
                size: TextSize.small,
                color: Pallete.lp151522,
                weight: TextWeight.lMedium,
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Pallete.lpE3E5E5,
                    ),
                    borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    const LPText(
                      '+91',
                      color: Pallete.lp0e0f0f,
                      size: TextSize.medium,
                    ),
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.keyboard_arrow_down_outlined,
                      color: Pallete.lp0e0f0f,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FormBuilderTextField(
                        controller: mobileController,
                        maxLength: 10,
                        name: 'HHHH',
                        decoration: const InputDecoration(
                            counterText: '',
                            hintStyle: TextStyle(color: Pallete.lpB4B6B8),
                            border: InputBorder.none,
                            hintText: 'Enter mobile number'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const LPText(
                'Login PIN',
                weight: TextWeight.lMedium,
                size: TextSize.small,
                color: Pallete.lp151522,
              ),
              const SizedBox(height: 6),
              PinCodeFields(
                obscureCharacter: '*',
                onChange: (String val) {
                  pinEntered = val;
                },
                obscureText: true,
                length: 6,
                controller: pinController,
                fieldBorderStyle: FieldBorderStyle.square,
                responsive: true,
                fieldHeight: 55.0,
                borderWidth: 1.0,
                activeBorderColor: Pallete.primaryColor,
                activeBackgroundColor: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                autoHideKeyboard: false,
                fieldBackgroundColor: Pallete.whiteColor,
                borderColor: Pallete.greyColor,
                textStyle: const TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
                onComplete: (String value) {},
              ),
              const SizedBox(height: 8),
              Row(
                children: const [
                  LPText(
                    'Login with OTP',
                    color: Pallete.primaryColor,
                    size: TextSize.medium,
                    weight: TextWeight.lMedium,
                  ),
                  Spacer(),
                  LPText(
                    'Forgotten Login PIN?',
                    color: Pallete.primaryColor,
                    size: TextSize.medium,
                    weight: TextWeight.lMedium,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              isLoading
                  ? const Center(
                      child: Loader(),
                    )
                  : CommonButton(
                      text: 'Login',
                      onTap: () => onLogin(ref, context),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  onLogin(WidgetRef ref, BuildContext context) async {
    if (mobileController.text.length != 10) {
      showSnackBar(context, 'Please enter proper number');
      return;
    }
    if (pinEntered.length != 6) {
      showSnackBar(context, 'Please enter proper pin');
      return;
    }
    ref.read(authControllerProvider.notifier).login(
          mobile: mobileController.text,
          pin: pinController.text,
          context: context,
        );
  }
}
