import 'package:flutter/material.dart';
import 'package:game_metrics_mobile_app/common/styles/text_styles.dart';
import 'package:game_metrics_mobile_app/common/widgets/box_decoration.dart';

class TitleBox extends StatelessWidget {
  final String title;

  const TitleBox({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: gmBoxDecoration(),
      child: Text(
        title,
        style: gmTitleTextStyle(),
        textAlign: TextAlign.center,
      ),
    );
  }
}
