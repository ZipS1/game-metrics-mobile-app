import 'package:flutter/material.dart';
import 'package:game_metrics_mobile_app/common/colors.dart';
import 'package:game_metrics_mobile_app/common/global/client_service.dart';

AppBar appBar({bool isAuthenticated = true}) {
  return AppBar(
    backgroundColor: gmSecondaryBackgroundColor,
    centerTitle: true,
    title: Text("Game Metrics"),
    titleTextStyle: TextStyle(fontSize: 24, color: gmTextColor),
    actions: [
      isAuthenticated
          ? IconButton(
              onPressed: () {
                ClientService().handleLogout();
              },
              icon: Icon(Icons.logout),
            )
          : Container()
    ],
  );
}
