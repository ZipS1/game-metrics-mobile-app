import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  const EmailField({
    super.key,
    required TextEditingController emailController,
  }) : _emailController = emailController;

  final TextEditingController _emailController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _emailController,
      decoration: const InputDecoration(
        labelText: 'E-mail',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      ),
      validator: (value) {
        RegExp regExp = RegExp(r'^[\w\.]+@[\w\.]+\.(com|ru)$');
        if (value == null || value.isEmpty) {
          return "Поле не может быть пустым";
        } else if (!regExp.hasMatch(value)) {
          return "Не является допустимым e-mail";
        }
        return null;
      },
    );
  }
}
