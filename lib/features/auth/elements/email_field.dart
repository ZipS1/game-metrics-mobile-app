import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  const EmailField({
    super.key,
    required TextEditingController usernameController,
  }) : _usernameController = usernameController;

  final TextEditingController _usernameController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _usernameController,
      decoration: const InputDecoration(
        labelText: 'E-mail',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Пожалуйста, введите e-mail';
        }
        return null;
      },
    );
  }
}
