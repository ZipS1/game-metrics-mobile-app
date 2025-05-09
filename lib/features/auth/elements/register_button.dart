import 'package:flutter/material.dart';
import 'package:game_metrics_mobile_app/common/colors.dart';
import 'package:game_metrics_mobile_app/common/global/snackbar_service.dart';
import 'package:game_metrics_mobile_app/features/auth/services/register_service.dart';

class RegisterButton extends StatelessWidget {
  const RegisterButton({
    super.key,
    required GlobalKey<FormState> formKey,
    required TextEditingController emailController,
    required TextEditingController passwordController,
  })  : _formKey = formKey,
        _emailController = emailController,
        _passwordController = passwordController;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _emailController;
  final TextEditingController _passwordController;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (!_formKey.currentState!.validate()) return;
        try {
          final String message = await register(
            _emailController.text,
            _passwordController.text,
          );

          SnackbarService.showSuccess(message);
        } catch (e) {
          SnackbarService.showFail(
              e.toString().replaceFirst("Exception: ", ""));
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: gmAccentColor,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
      child: const Text(
        'Зарегистрироваться',
        style: TextStyle(
          color: gmTextColorAlternative,
          fontSize: 16,
        ),
      ),
    );
  }
}
