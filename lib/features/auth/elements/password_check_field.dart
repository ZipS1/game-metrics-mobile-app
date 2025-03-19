import 'package:flutter/material.dart';
import 'package:game_metrics_mobile_app/common/colors.dart';

class PasswordCheckField extends StatelessWidget {
  final TextEditingController passwordCheckController;
  final TextEditingController passwordController;
  final bool passwordObscured;
  final VoidCallback onTogglePassword;

  const PasswordCheckField({
    super.key,
    required this.passwordCheckController,
    required this.passwordController,
    required this.passwordObscured,
    required this.onTogglePassword,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: passwordCheckController,
      obscureText: passwordObscured,
      decoration: InputDecoration(
        labelText: "Подтвердите пароль",
        border: OutlineInputBorder(),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        suffixIcon: IconButton(
          onPressed: onTogglePassword,
          icon: Icon(
            passwordObscured ? Icons.visibility : Icons.visibility_off,
            color: passwordObscured ? gmSecondaryColor : gmAccentColor,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Поле не может быть пустым";
        } else if (passwordController.text != value) {
          return "Пароли не совпадают";
        }
        return null;
      },
    );
  }
}
