import 'package:flutter/material.dart';
import 'package:game_metrics_mobile_app/features/auth/pages/register_page.dart';

class NavigateToRegisterLink extends StatelessWidget {
  const NavigateToRegisterLink({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RegisterPage()),
        );
      },
      child: const Text(
        "Нет аккаунта? Зарегистрироваться",
        style: TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
