import 'package:flutter/material.dart';
import 'package:game_metrics_mobile_app/common/widgets/box_decoration.dart';
import 'package:game_metrics_mobile_app/features/auth/elements/email_field.dart';
import 'package:game_metrics_mobile_app/features/auth/elements/form_title.dart';
import 'package:game_metrics_mobile_app/features/auth/elements/login_button.dart';
import 'package:game_metrics_mobile_app/features/auth/elements/password_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(20.0),
        decoration: gmBoxDecoration(),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FormTitle(title: 'Вход'),
              const SizedBox(height: 20),
              EmailField(usernameController: _usernameController),
              const SizedBox(height: 15),
              PasswordField(passwordController: _passwordController),
              const SizedBox(height: 20),
              LoginButton(
                  formKey: _formKey,
                  usernameController: _usernameController,
                  passwordController: _passwordController),
            ],
          ),
        ),
      ),
    );
  }
}
