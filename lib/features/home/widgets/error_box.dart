import 'package:flutter/material.dart';

class ErrorBox extends StatelessWidget {
  final String text;

  const ErrorBox({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
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
