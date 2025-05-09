import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';

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
    final environment = GlobalConfiguration().getValue('environment');

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
