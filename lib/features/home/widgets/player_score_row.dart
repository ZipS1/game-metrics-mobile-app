import 'package:flutter/material.dart';
import 'package:game_metrics_mobile_app/common/colors.dart';
import 'package:game_metrics_mobile_app/common/styles/text_styles.dart';

Widget playerScoreRow(String playerName, int score) {
  Color scoreColor;
  if (score > 0) {
    scoreColor = gmPositiveAccentColor;
  } else if (score < 0) {
    scoreColor = gmNegativeAccentColor;
  } else {
    scoreColor = gmTextColor;
  }

  return Row(
    children: [
      Expanded(
        child: Text(
          playerName,
          style: gmRegularTextStyle(),
        ),
      ),
      Text(
        score.toString(),
        style: gmScoreTextStyle(scoreColor),
        textAlign: TextAlign.right,
      ),
    ],
  );
}
