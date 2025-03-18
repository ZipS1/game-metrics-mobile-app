import 'package:flutter/material.dart';
import 'package:game_metrics_mobile_app/common/colors.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
    required GlobalKey<FormState> formKey,
    required TextEditingController usernameController,
    required TextEditingController passwordController,
  })  : _formKey = formKey,
        _usernameController = usernameController,
        _passwordController = passwordController;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _usernameController;
  final TextEditingController _passwordController;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          // Process login logic here
          print('Login: ${_usernameController.text}');
          print('Password: ${_passwordController.text}');
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
        'Войти',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }
}
