import 'package:flutter/material.dart';
import 'package:game_metrics_mobile_app/common/styles/widget_styles.dart';
import 'package:game_metrics_mobile_app/features/auth/elements/email_field.dart';
import 'package:game_metrics_mobile_app/features/auth/elements/form_title.dart';
import 'package:game_metrics_mobile_app/features/auth/elements/navigate_to_login_link.dart';
import 'package:game_metrics_mobile_app/features/auth/elements/password_check_field.dart';
import 'package:game_metrics_mobile_app/features/auth/elements/password_field.dart';
import 'package:game_metrics_mobile_app/features/auth/elements/register_button.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordCheckController =
      TextEditingController();
  bool _passwordObscured = true;

  void _togglePasswordVisibility() {
    setState(() {
      _passwordObscured = !_passwordObscured;
    });
  }

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
              FormTitle(title: 'Регистрация'),
              const SizedBox(height: 20),
              EmailField(emailController: _emailController),
              const SizedBox(height: 15),
              PasswordField(
                passwordController: _passwordController,
                passwordObscured: _passwordObscured,
                onTogglePassword: _togglePasswordVisibility,
              ),
              const SizedBox(height: 20),
              PasswordCheckField(
                passwordCheckController: _passwordCheckController,
                passwordController: _passwordController,
                passwordObscured: _passwordObscured,
                onTogglePassword: _togglePasswordVisibility,
              ),
              const SizedBox(height: 20),
              NavigateToLoginLink(),
              const SizedBox(height: 20),
              RegisterButton(
                  formKey: _formKey,
                  emailController: _emailController,
                  passwordController: _passwordController),
            ],
          ),
        ),
      ),
    );
  }
}
