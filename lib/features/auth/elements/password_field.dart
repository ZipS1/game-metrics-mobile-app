import 'package:flutter/material.dart';
import 'package:game_metrics_mobile_app/common/colors.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController passwordController;
  final bool passwordObscured;
  final VoidCallback onTogglePassword;

  const PasswordField({
    super.key,
    required this.passwordController,
    required this.passwordObscured,
    required this.onTogglePassword,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: passwordController,
      obscureText: passwordObscured,
      decoration: InputDecoration(
        labelText: "Пароль",
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
        } else if (value.length < 8) {
          return "Минимальная длина - 8 символов";
        }
        return null;
      },
    );
  }
}
