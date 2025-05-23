import 'package:flutter/material.dart';
import 'package:game_metrics_mobile_app/common/colors.dart';

class SnackbarService {
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void showSuccess(String message) {
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: gmPositiveAccentColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static void showFail(String message) {
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: gmNegativeAccentColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static void hideCurrent() {
    scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
  }
}
