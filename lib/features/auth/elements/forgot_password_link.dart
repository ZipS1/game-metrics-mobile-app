import 'package:flutter/material.dart';
import 'package:game_metrics_mobile_app/common/colors.dart';
import 'package:game_metrics_mobile_app/common/global/snackbar_service.dart';

class ForgotPasswordLink extends StatelessWidget {
  const ForgotPasswordLink({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        SnackbarService.showFail("Очень жаль, очень жаль");
      },
      child: const Text(
        "Забыли пароль?",
        style: TextStyle(
          color: gmSecondaryColor,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
