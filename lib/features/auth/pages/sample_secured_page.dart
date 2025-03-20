import 'package:flutter/material.dart';
import 'package:game_metrics_mobile_app/common/colors.dart';
import 'package:game_metrics_mobile_app/common/widgets/app_bar.dart';

class SampleSecuredPage extends StatelessWidget {
  const SampleSecuredPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(),
        backgroundColor: gmPrimaryBackgroundColor,
        body: Center(
          child: Text("Hello"),
        ));
  }
}
