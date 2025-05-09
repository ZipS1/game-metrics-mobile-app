import 'package:flutter/material.dart';
import 'package:game_metrics_mobile_app/common/colors.dart';

TextStyle gmTitleTextStyle() {
  return const TextStyle(
    fontSize: 20,
    color: gmTextColor,
    fontWeight: FontWeight.bold,
  );
}

TextStyle gmHeaderTextStyle() {
  return const TextStyle(
    fontSize: 16,
    color: gmTextColor,
    fontWeight: FontWeight.bold,
  );
}

TextStyle gmRegularTextStyle() {
  return const TextStyle(
      fontSize: 16, color: gmTextColor, fontWeight: FontWeight.normal);
}

TextStyle gmScoreTextStyle(Color scoreColor) {
  return TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: scoreColor,
  );
}

TextStyle gmPointsTextStyle() {
  return const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: gmTextColor,
  );
}

TextStyle gmMainPageDurationTextStyle() {
  return const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );
}
