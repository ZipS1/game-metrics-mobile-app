import 'package:flutter/material.dart';
import 'package:game_metrics_mobile_app/common/colors.dart';

AppBar appBar() {
  return AppBar(
    backgroundColor: gmSecondaryBackgroundColor,
    centerTitle: true,
    title: Text("Game Metrics"),
    titleTextStyle: TextStyle(fontSize: 24, color: gmTextColor),
  );
}
