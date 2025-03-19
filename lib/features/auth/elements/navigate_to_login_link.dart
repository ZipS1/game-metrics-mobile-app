import 'package:flutter/material.dart';
import 'package:game_metrics_mobile_app/common/colors.dart';
import 'package:game_metrics_mobile_app/features/auth/pages/login_page.dart';

class NavigateToLoginLink extends StatelessWidget {
  const NavigateToLoginLink({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (Route<dynamic> route) => false,
        );
      },
      child: const Text(
        "Уже есть аккаунт? Войти",
        style: TextStyle(
          color: gmSecondaryColor,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
