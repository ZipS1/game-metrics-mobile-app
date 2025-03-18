import 'package:flutter/material.dart';
import 'package:game_metrics_mobile_app/common/colors.dart';
import 'package:game_metrics_mobile_app/common/widgets/app_bar.dart';
import 'package:game_metrics_mobile_app/features/auth/widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(),
        backgroundColor: gmPrimaryBackgroundColor,
        body: LoginForm());
  }
}
