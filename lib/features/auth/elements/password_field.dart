import 'package:flutter/material.dart';
import 'package:game_metrics_mobile_app/common/colors.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required TextEditingController passwordController,
  }) : _passwordController = passwordController;

  final TextEditingController _passwordController;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool passwordObscured = true;
  Color passwordEyeColor = gmSecondaryColor;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget._passwordController,
      obscureText: passwordObscured,
      decoration: InputDecoration(
          labelText: "Пароль",
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          suffix: TextButton(
              onPressed: () {
                setState(() {
                  passwordObscured = !passwordObscured;
                  passwordEyeColor =
                      passwordObscured ? gmSecondaryColor : gmAccentColor;
                });
              },
              child: Icon(
                Icons.remove_red_eye,
                color: passwordEyeColor,
              ))),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Поле не может быть пустым";
        }
        return null;
      },
    );
  }
}
