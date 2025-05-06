import 'package:flutter/material.dart';
import 'package:game_metrics_mobile_app/config/environment.dart';

class ErrorBox extends StatelessWidget {
  final String message;
  final String? productionMessage;

  const ErrorBox({
    super.key,
    required this.message,
    this.productionMessage,
  });

  @override
  Widget build(BuildContext context) {
    String text =
        environment == "production" ? productionMessage ?? message : message;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            padding:
                EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.05),
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Text(text),
            ),
          ),
        );
      },
    );
  }
}
